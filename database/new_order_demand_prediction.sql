/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : new_order_demand_prediction.sql
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/2/2018
*    Platform Dependencies  : MySql
*    Description            : Provide data report on the ordered final products vs persistent parts for assemblying the product
*                             This sp only works for Inventory orders or Customer Orders, not supplier orders, because supplier orders do not contain products
*                             Also, the order would only show ordered products in the order, not materials
*                             The report reports on unique products vs unqiue processes, e.g. if an order has multiple lines of same product, the report will
*                             combine them predict based on the product total quantities.
*    example	            : CALL new_order_demand_prediction(7)
*    Log                    :		
*     09/02/2018: Peiyu Ge: first created
*     11/17/2018: Xueyan Dong: rewrote the logics
*/
DELIMITER $  
  DROP PROCEDURE IF EXISTS `new_order_demand_prediction`$
  CREATE PROCEDURE `new_order_demand_prediction`(
   IN _order_id int(10) unsigned
 )
  BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

   DECLARE _consume_step_type_id INT UNSIGNED;
   
   IF _order_id IS NOT NULL
   THEN
  -- find out unique products and ordered quantities in the given order. 
  -- Keep in mind that same products may appear in multiple lines in order_detail table
  DROP TEMPORARY TABLE IF EXISTS ordered_products;
  CREATE TEMPORARY TABLE IF NOT EXISTS ordered_products (
   order_id INT(10) UNSIGNED,
   expected_deliver_date DATETIME,
   priority TINYINT(2) UNSIGNED,
   ponumber VARCHAR(40),
   product_id INT(10) UNSIGNED,
   quantity_requested DECIMAL(16,4) UNSIGNED,
   quantity_completed DECIMAL(16,4) UNSIGNED,
   quantity_not_dispatched DECIMAL(16,4) UNSIGNED,
   product_name VARCHAR(255),
   product_description TEXT,
   product_group_name VARCHAR(255),
   uom_id SMALLINT(3) UNSIGNED);

  INSERT INTO ordered_products
  (expected_deliver_date,
   priority,
   ponumber,
   product_id,
   quantity_requested,
   quantity_completed,
   quantity_not_dispatched,
   product_name,
   product_description,
   product_group_name,
   uom_id)
  SELECT g.expected_deliver_date,
         g.priority,
         g.ponumber,
         d.source_id,
         SUM(d.quantity_requested),
         SUM(IFNULL(d.quantity_made,0.0)+IFNULL(d.quantity_shipped,0.0)),
         SUM(d.quantity_requested - IFNULL(d.quantity_made,0) - IFNULL(d.quantity_in_process,0)-IFNULL(d.quantity_shipped,0)),
         p.name,
         p.description,
         pg.name,
         d.uomid
    FROM order_general g
    JOIN order_detail d
      ON d.order_id = g.id
         AND d.source_type = 'product'
    JOIN product p
      ON p.id = d.source_id
    JOIN product_group pg
      ON pg.id = p.pg_id
   WHERE g.id =_order_id
     AND g.order_type != 'supplier'
  GROUP BY g.expected_deliver_date, g.priority, g.ponumber, d.source_id, p.name, p.description, pg.name;

  DROP TEMPORARY TABLE IF EXISTS process_bom_final;  
  CREATE TEMPORARY TABLE process_bom_final
  ( process_id INT UNSIGNED,
    process_name VARCHAR(255),
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
 INSERT INTO process_bom_final (process_id, process_name)
  SELECT DISTINCT pp.process_id, p.`name`
    FROM ordered_products op
    JOIN product_process pp 
      ON pp.product_id = op.product_id
    JOIN `process` p
      ON p.id = pp.process_id
         AND p.state = 'production';
         
 SELECT id INTO _consume_step_type_id
    FROM step_type
   WHERE name='consume material';

  DROP TEMPORARY TABLE IF EXISTS process_bom_temp;
  CREATE TEMPORARY TABLE process_bom_temp
  ( process_id INT UNSIGNED,
    process_name VARCHAR(255),
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    ingredient_description TEXT,
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    uom_name VARCHAR(20),
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
    
  -- find persistant ingredients of the processes none sub process steps of the processes
  INSERT INTO process_bom_temp
  (process_id,
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
         pp.process_id,
         pp.process_name,
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
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )  
   SELECT 
         pp.process_id,
         pp.process_name,
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
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
          process_id,
          process_name,
          ingredient_id,
          source_type,
          sum(recipe_quantity),
          uom_id
    FROM process_bom_temp pb
   GROUP BY process_id, process_name, ingredient_id, source_type, uom_id;
  
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
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id,
   inventory_quantity
   )
  SELECT pbf.process_id,
         pbf.process_name,
         pbf.ingredient_id,
         pbf.source_type,
         pbf.recipe_quantity,
         pbf.uom_id,
         SUM(IFNULL(CONVERT_QUANTITY(inv.actual_quantity,inv.uom_id, pbf.uom_id),0))
    FROM process_bom_final pbf
    LEFT JOIN inventory inv  -- **** will need to only pull out from designated location
      ON pbf.source_type = inv.source_type
         AND pbf.ingredient_id = inv.pd_or_mt_id
    GROUP BY pbf.process_id, pbf.process_name, pbf.source_type, pbf.ingredient_id, pbf.recipe_quantity, pbf.uom_id;
   
   -- calculate number of final product capable to produce with inventory in hand
   UPDATE process_bom_temp
      SET final_product_qty = inventory_quantity / recipe_quantity;
  
  -- pull out ingredient name and description from either product table or material table
  UPDATE process_bom_temp pbt
    JOIN product p
      ON p.id = pbt.ingredient_id
          SET ingredient_name = p.name,
              ingredient_description = p.description
   WHERE pbt.source_type = 'product';
 
  UPDATE process_bom_temp pbt
    JOIN material m
      ON m.id = pbt.ingredient_id
          SET ingredient_name = m.name,
              ingredient_description =m.description
   WHERE pbt.source_type = 'material';
  
  -- get uom name
  UPDATE process_bom_temp pbt
    JOIN uom u
      ON u.id = pbt.uom_id
     SET pbt.uom_name = u.name;
     
	SELECT
			_order_id,
      g.expected_deliver_date,
      g.priority,
			g.ponumber,
			g.product_name, 
      g.product_description,
			g.product_group_name, 
			g.quantity_requested,
			g.quantity_completed,
			g.quantity_not_dispatched,
			u.name as uom,
			pb.process_name,
			pb.ingredient_name,
      pb.ingredient_description AS description,
		-- concat(p.quantity," ", p.uom),
			pb.recipe_quantity as quantity,
      pb.inventory_quantity AS unassigned_quantity,
      pb.final_product_qty AS max_product_qty
            
	FROM ordered_products g
  JOIN product_process pp
    ON pp.product_id = g.product_id
  JOIN process_bom_temp pb
    ON pb.process_id = pp.process_id
  JOIN uom u
    ON u.id = g.uom_id;
    
  DROP TEMPORARY TABLE ordered_products;
  DROP TEMPORARY TABLE process_bom_final;
  DROP TEMPORARY TABLE process_bom_temp;

   END IF;
  
END$