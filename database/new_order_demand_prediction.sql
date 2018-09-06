/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : new_order_demand_prediction.sql
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/2/2018
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :		
*/
DELIMITER $  -- for escaping purpose
  DROP PROCEDURE IF EXISTS `new_order_demand_prediction`$
  CREATE PROCEDURE `new_order_demand_prediction`(
   IN _order_id int(10) unsigned
 )
  BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

    
   IF _order_id IS NOT NULL
   THEN
  
	CREATE TEMPORARY TABLE IF NOT EXISTS new_order_demand_temp
		(
		  order_id int(10) unsigned,
          expected_deliver_date datetime,
          priority varchar(20),
		  ponumber varchar(40),
		  product_name varchar(255),
          product_description varchar(255),
		  product_group_name varchar(255),
		  quantity_requested decimal(16,4) unsigned,
		  quantity_completed decimal(16,4) unsigned,
		  quantity_not_dispatched decimal(16,4),
		  process_id int(10) unsigned,
		  process_name varchar(255),
		  uomid smallint(3) unsigned,
		  uom varchar(20)
		) DEFAULT CHARSET=utf8;
	  
	  -- collect information of order, product, 
		INSERT INTO new_order_demand_temp
		SELECT 
				g.id,
                g.expected_deliver_date,
                pr.name,
				g.ponumber, 
				p.name, 
                p.description,
				pg.name, 
				d.quantity_requested, 
				(d.quantity_made + d.quantity_in_process + d.quantity_shipped), 
				(d.quantity_requested - d.quantity_made - d.quantity_in_process - d.quantity_shipped),
				pp.process_id,
				pc.name,
				d.uomid,
				u.name
		
		FROM order_general g, order_detail d, product p, product_group pg, process pc, product_process pp, uom u, priority pr
		where g.id = _order_id
		and g.id = d.order_id
		and p.id = d.source_id
		and p.pg_id = pg.id
		and p.id = pp.product_id
        and pp.process_id = pc.id
		and u.id = d.uomid
        and g.priority = pr.id
		;
        
    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 
    (
      process_id int(10) unsigned,
	  source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    SELECT
		  p.process_id,
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id
      FROM process_step p, step s, step_type t, recipe r, ingredients i, new_order_demand_temp o
      WHERE p. process_id = o.process_id
      AND if_sub_process = 0 -- for process with no sub_process
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    SELECT  
			p.process_id,
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i, new_order_demand_temp o
      WHERE p.process_id = o.process_id
      AND p.if_sub_process = 1 -- for process with subprocess
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id;
 

      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_total 
    (
      process_id int(10) unsigned,
	  source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      alert_quantity decimal(16,4) unsigned,
      description text,
	  if_persistent boolean
    ) DEFAULT CHARSET=utf8; 
    
     INSERT INTO process_bom_total 
     (process_id,
	 source_type,
     ingredient_id,
     quantity,
     uomid,
     uom,
	 if_persistent)
    SELECT 
		   process_id,
		   source_type,
           ingredient_id,
           sum(quantity),
           pb.uomid,
           u.name,
		   m.if_persistent
           
      FROM process_bom pb, uom u, material m
     WHERE u.id = pb.uomid And pb.ingredient_id = m.id
     GROUP BY process_id, source_type, ingredient_id, ingredient_name, pb.uomid;
     
    DROP TABLE process_bom;
    
    UPDATE process_bom_total pb, material m
       SET pb.ingredient_name = m.name,
           pb.alert_quantity = m.alert_quantity,
           pb.description = m.description
     WHERE pb.source_type = 'material'
       AND pb.ingredient_id = m.id;
       
    UPDATE process_bom_total pb, product p
       SET pb.ingredient_name = p.name,
           pb.description = p.description
     WHERE pb.source_type = 'product'
       AND pb.ingredient_id = p.id;
    
      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_temp 
    (
      process_id int(10) unsigned,
	  source_type varchar(20),
      ingredient_id int(10) unsigned,
      unassigned_quantity_raw varchar(31),
      assigned_quantity_show varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;  
    
    INSERT INTO process_bom_temp
    (process_id, source_type, ingredient_id, unassigned_quantity_raw, assigned_quantity_show, ifalert)
    SELECT 
		   process_id,
		   source_type,
           ingredient_id,
           ifnull((SELECT concat(sum(inv.actual_quantity), ',', max(inv.uom_id))
              FROM inventory inv 
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND 
                (EXISTS (SELECT * 
                           FROM `order_general` o, order_state_history os
                          WHERE o.id = inv.in_order_id
                            AND o.order_type = 'inventory'
                            AND os.order_id = o.id
                            AND os.state='produced'
                            ) 
                 OR
                  (inv.in_order_id IS NULL))), 0)  ,
           ifnull((SELECT concat(format(sum(inv.actual_quantity),1), ' ', max(u3.name))
              FROM inventory inv LEFT JOIN uom u3 ON u3.id = inv.uom_id
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND EXISTS (SELECT *
                            FROM `order_general` o
                           WHERE o.id = inv.in_order_id
                              AND o.order_type in( 'customer','inventory')
                              AND NOT EXISTS (SELECT *
                                                FROM order_state_history os
                                               WHERE os.order_id = o.id
                                                 AND os.state = 'produced'))),0),
             0
     
      FROM process_bom_total pb ;
      
    UPDATE process_bom_temp
       SET unassigned_quantity = CAST(LEFT(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')) AS DECIMAL),
           unassigned_uomid =SUBSTRING(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')+1)
     WHERE unassigned_quantity_raw != '0';
 
     UPDATE process_bom_temp
       SET unassigned_quantity = 0,
           unassigned_uomid =0
     WHERE unassigned_quantity_raw = '0';
    
    -- unassigned inventory is empty or below alert level will raise the ifalert flag
    UPDATE process_bom_temp pt, process_bom_total pb
      SET pt.ifalert =if(pt.unassigned_quantity=0 OR convert_quantity(pt.unassigned_quantity, pt.unassigned_uomid, pb.uomid)<pb.alert_quantity, 1, 0)
     WHERE pb.source_type = pt.source_type
       AND pb.ingredient_id = pt.ingredient_id;
   
    
    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_sum
    (
      process_id int(10) unsigned,
	  source_type varchar(20),
      ingredient_id int(10) unsigned,
	  ingredient_name varchar(255),
	  quantity decimal(16,4) unsigned,
	  uomid  smallint(3) unsigned,
	  uom varchar(20),
	  alert_quantity decimal(16,4) unsigned,
	  description text,
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
	  unassigned_uom varchar(20),
	  assigned_quantity_show varchar(31),
      ifalert tinyint(1) unsigned,
	  if_persistent boolean
     -- maxFinalQty int(10) unsigned
      
    ) DEFAULT CHARSET=utf8;  
    
    INSERT INTO process_bom_sum
    (process_id, source_type, ingredient_id, ingredient_name, quantity, uomid, uom, alert_quantity, description, unassigned_quantity, unassigned_uomid, unassigned_uom, assigned_quantity_show, ifalert, if_persistent) -- , maxFinalQty
    
	SELECT 
	       pt.process_id,
		   pt.source_type,
           pt.ingredient_id,
           pt.ingredient_name
           ,pt.quantity
           ,pt.uomid
           ,pt.uom
           ,pt.alert_quantity
           ,pt.description
           ,pb.unassigned_quantity
           ,pb.unassigned_uomid
           ,u.name AS unassigned_uom
           ,pb.assigned_quantity_show
           ,pb.ifalert
		   ,pt.if_persistent
		   
           FROM process_bom_total pt 
           JOIN process_bom_temp pb ON pt.process_id = pb.process_id AND pt.source_type = pb.source_type AND pt.ingredient_id = pb.ingredient_id-- added join condition uomid
           LEFT JOIN uom u ON u.id = pb.unassigned_uomid;
    
    -- for max allowed final product by inventory
    CREATE TEMPORARY TABLE IF NOT EXISTS max_final_product(
      process_id int(10) unsigned,
      max_product_qty int(10) unsigned
    )DEFAULT CHARSET=utf8;  
    
    INsert Into max_final_product
    ( process_id,
      max_product_qty
	)
    Select process_id,
    min(unassigned_quantity / quantity)
    from process_bom_sum
    where if_persistent = 1
    group by process_id;
    
    
	SELECT  distinct
			o.order_id,
            o.expected_deliver_date,
            o.priority,
			o.ponumber,
			o.product_name, 
            o.product_description,
			o.product_group_name, 
		-- concat(o.quantity_requested, " ", o.uom), 
		-- concat(o.quantity_completed, " ", o.uom), 
		-- concat(o.quantity_not_dispatched, " ", o.uom),
			o.quantity_requested,
			o.quantity_completed,
			o.quantity_not_dispatched,
			o.uom,
			o.process_name,
			p.ingredient_name,
            p.description,
		-- concat(p.quantity," ", p.uom),
			p.quantity,
			p.unassigned_quantity,  -- inventory
			m.max_product_qty
            
	FROM new_order_demand_temp o, process_bom_sum p, max_final_product m
	where o.process_id = p.process_id and m.process_id = o.process_id
    And p.if_persistent = 1;
	
    DROP TABLE process_bom_total;
    DROP TABLE process_bom_temp;
	DROP TABLE process_bom_sum;
	DROP TABLE new_order_demand_temp;
   END IF;
  
END$
