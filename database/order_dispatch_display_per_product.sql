/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : order_dispatch_display_per_product
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/10/2018
*    Platform Dependencies  : MySql
*    Description            : This stored procedure serves the grid of the dispatch page, which display orders that
*                             haven't been fully dispatched. 
*                             Note: dispatch only dispatch order detail lines for source_type = product. No need to dispatch material lines
*    example	            : CALL order_dispatch_display_per_product
*    Log                    :	
*    09/10/2018:Peiyu Ge: Created
*    10/29/2018:Xueyan Dong: Added some scripts for easy recompile
*    11/06/2018: Xueyan Dong: rewrite the logics to narrow down data volume processed and add line_num to the resultset.
*/
DELIMITER $
DROP PROCEDURE IF EXISTS order_dispatch_display_per_product$
CREATE PROCEDURE order_dispatch_display_per_product()
BEGIN
   DECLARE _consume_step_type_id INT UNSIGNED;
   
  -- pull out distinct products from order lines to be dispatched
  DROP TEMPORARY TABLE IF EXISTS ordered_products;
  CREATE TEMPORARY TABLE IF NOT EXISTS ordered_products
  (product_id INT UNSIGNED);
  INSERT INTO ordered_products
  (product_id)
  SELECT distinct source_id
  FROM order_general og
  JOIN order_detail od
    ON od.order_id = og.id
       AND od.source_type = 'product'
       AND od.quantity_requested > IFNULL(quantity_made, 0) + IFNULL(quantity_in_process, 0) + IFNULL(quantity_shipped, 0)
 WHERE og.order_type !='supplier'
   AND og.state NOT IN ('shipped', 'delivered');  
 
  DROP TEMPORARY TABLE IF EXISTS product_process_capability;
  CREATE TEMPORARY TABLE product_process_capability
  (product_id INT UNSIGNED,
   process_id INT UNSIGNED,
   process_name VARCHAR(255),
   process_priority TINYINT(2) UNSIGNED,
   final_product_qty INT UNSIGNED);
   
  INSERT INTO product_process_capability (product_id, process_id, process_name, process_priority)
  SELECT pp.product_id, pp.process_id, p.name, pp.priority
    FROM ordered_products op
    JOIN product_process pp
      ON pp.product_id = op.product_id
    JOIN `process` p 
      ON p.id = pp.process_id;
  -- table for holding the capability of each process, which is determined by the scacity of peristent ingredients,
  -- e.g. the ingredient, whose inventory allows the minimum quantity of final product produced
  DROP TEMPORARY TABLE IF EXISTS process_bom_final;
  CREATE TEMPORARY TABLE process_bom_final
  ( process_id INT UNSIGNED,
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
  -- peel out unique processes used by the ordered products
  INSERT INTO process_bom_final (process_id)
  SELECT DISTINCT process_id
    FROM product_process_capability;

      
  SELECT id INTO _consume_step_type_id
    FROM step_type
   WHERE name='consume material';

  DROP TEMPORARY TABLE IF EXISTS process_bom_temp;
  CREATE TEMPORARY TABLE process_bom_temp
  ( process_id INT UNSIGNED,
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
    
  -- find persistant ingredients of the processes none sub process steps of the processes
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
         pp.process_id,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- non sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = ps.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id;
      
   -- find persistant ingredients of the processes none sub process steps of the processes     
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )  
   SELECT 
         pp.process_id,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 1
    JOIN process_step pss -- sub process only allowed 1 depth
      ON pss.process_id = ps.step_id
         AND pss.if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = pss.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id; 

  -- same ingredient can appear in the same process multiple times. 
  -- combine the same ingredients and calculated the total quantity needed in the process
  DELETE FROM process_bom_final;
    
  INSERT INTO process_bom_final
  (
   process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
          process_id,
          ingredient_id,
          source_type,
          sum(recipe_quantity),
          uom_id
    FROM process_bom_temp pb
   GROUP BY process_id, ingredient_id, source_type, uom_id;
  
  -- remove none persistent material
  DELETE pb
    FROM process_bom_final pb
    JOIN material m
      ON m.id = pb.ingredient_id
         AND m.if_persistent = 0
   WHERE pb.source_type = 'material';
  
  -- mysql limit the use of same temporary table in a query to only once. thus, use process_bom_temp and process_bom_final
  -- to shuffle data during quantity calculation
  
  -- use process_bom_temp to temporarily store intermediate data: inventory quantities of each process/ingredient
  DELETE FROM process_bom_temp;
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id,
   inventory_quantity
   )
  SELECT pbf.process_id,
         pbf.ingredient_id,
         pbf.source_type,
         pbf.recipe_quantity,
         pbf.uom_id,
         SUM(IFNULL(CONVERT_QUANTITY(inv.actual_quantity,inv.uom_id, pbf.uom_id),0))
    FROM process_bom_final pbf
    LEFT JOIN inventory inv  -- **** will need to only pull out from designated location
      ON pbf.source_type = inv.source_type
         AND pbf.ingredient_id = inv.pd_or_mt_id
    GROUP BY pbf.process_id,pbf.source_type, pbf.ingredient_id, pbf.recipe_quantity, pbf.uom_id;
   
   -- calculate number of final product capable to produce with inventory in hand
   UPDATE process_bom_temp
      SET final_product_qty = inventory_quantity / recipe_quantity;
    

   -- identify the minimum final product count that inventory can produce
   DELETE FROM process_bom_final;
   INSERT INTO process_bom_final (process_id, final_product_qty)
   SELECT process_id,
          min(final_product_qty)
     FROM process_bom_temp
     GROUP BY process_id;
  
  -- save capability to product vs process table
  UPDATE product_process_capability ppc
    JOIN process_bom_final pbf
      ON pbf.process_id = ppc.process_id
     SET ppc.final_product_qty = pbf.final_product_qty;
      
 -- produce final result, which is one record per ordered detail line with capabilities of multiple process combined into
 -- one text as product_demand_prediction
 SELECT 
  g.id, 
  g.order_type, 
  g.ponumber, 
  g.client_id,
  c.name as ClientName,
  g.priority,
  d.line_num,
  pr.Name as PriName,
  d.source_id, 
  p.name as ProductName,
  d.quantity_requested, 
  d.quantity_made, 
  d.quantity_in_process, 
  d.quantity_shipped, 
  d.uomid,
  u.Name as uom,
  (SELECT max(state_date) FROM order_state_history h WHERE h.order_id = g.id) AS order_date,
  d.output_date, 
  g.expected_deliver_date, 
  d.actual_deliver_date, 
  g.internal_contact,
  CONCAT(e.firstname,' ',e.lastname) as internal_contact_name,
  g.external_contact, 
  d.comment ,
  g.id as order_id,
  (SELECT GROUP_CONCAT(CONCAT(ppc.process_name, ':', ppc.final_product_qty) SEPARATOR '| ') 
          FROM product_process_capability ppc 
          WHERE ppc.product_id = d.source_id
          ORDER BY ppc.process_priority desc) AS product_demand_prediction
  FROM order_general g
  JOIN order_detail d
    ON d.order_id = g.id
       AND d.source_type = 'product'
       AND d.quantity_requested > IFNULL(d.quantity_made, 0) + IFNULL(d.quantity_in_process, 0) + IFNULL(d.quantity_shipped, 0)
  JOIN product p
    ON p.id = d.source_id
  LEFT JOIN `client` c
    ON c.id = g.client_id
  LEFT JOIN uom u 
    ON u.id = d.uomid
  LEFT JOIN employee e
    ON e.id = g.internal_contact
  LEFT JOIN priority pr
    ON pr.id = g.priority
 WHERE g.order_type !='supplier'
   AND g.state NOT IN ('shipped', 'delivered') 
ORDER BY g.expected_deliver_date desc, g.priority desc, d.line_num;

  DROP TEMPORARY TABLE ordered_products;
  DROP TEMPORARY TABLE product_process_capability;
  DROP TEMPORARY TABLE process_bom_temp;
  DROP TEMPORARY TABLE process_bom_final;


END$