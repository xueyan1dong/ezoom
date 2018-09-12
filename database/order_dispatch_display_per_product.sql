/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : order_dispatch_display_per_product
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/10/2018
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :		
*/

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_dispatch_display_per_product`()
BEGIN

-- This procedure assume that all same product or material will use the same uom. and the UOM

-- may not be the same as the uom used in recipe.

-- Practically, same product or material may use different uoms depending on order or supplier.

-- will need to deal with this later (Xueyan 10/5/2010)



  -- IF _product_id IS NOT NULL

  -- THEN


   -- table record infor for a process
    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 

    (
      product_id int(10) unsigned,
      
	  process_id int(10) unsigned,

      source_type varchar(20),

      ingredient_id int(10) unsigned,

      ingredient_name varchar(255),

      quantity decimal(16,4) unsigned,

      uomid smallint(3) unsigned

    ) DEFAULT CHARSET=utf8;

  

    

    -- collect recipe and ingredient information from steps in the flow: 
    -- for a specific flow/process, the ingrediens (source_type, id, quantity and uom_id)
    -- used in all contained receipts were extracted into process_bom

    INSERT INTO process_bom

    SELECT
          pp.product_id,
          
		  p.process_id,
        
          i.source_type ,

          i.ingredient_id,

          ' ',

          i.quantity,

          i.uom_id

      FROM product_process pp, ingredients i, step s, step_type t, recipe r, process_step p
      
      -- inner join (select process_id from product_process where product_id = _product_id order by priority asc limit 3) as temp on p.process_id = temp.process_id
      
      WHERE pp.process_id = p.process_id
      
      AND p.if_sub_process = 0 -- no subprocess

      AND s.id = p.step_id

      AND s.step_type_id = t.id

      AND t.name = 'consume material'

      AND r.id = s.recipe_id

      AND i.recipe_id = r.id;

    

    -- collect recipe and ingredient information from sub process in the flow. 

    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.

    INSERT INTO process_bom

    SELECT  
			product_id,
            
			p.process_id,
            
            i.source_type,

            i.ingredient_id,

            ' ', -- what is this?

            i.quantity,

            i.uom_id

      FROM  product_process pp, ingredients i, process_step p1, step s, step_type t, recipe r, process_step p

    -- inner join (select process_id from product_process where product_id = _product_id order by priority asc limit 3) as temp on p.process_id = temp.process_id

      where pp.process_id = p.process_id
      
      AND p.if_sub_process = 1 -- subprocss

      AND p.step_id = p1.process_id -- parent process's step_id is the sub_process's process_id
 
      AND s.id = p1.step_id

      AND t.id = s.step_type_id

      AND t.name = 'consume material'

      AND r.id = s.recipe_id

      AND i.recipe_id = r.id;

 

	-- record bill or material (ingredient related) information for current process
	-- added if_persistent 8/29/2028 Peiyu
      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_total 

    (
      product_id int(10) unsigned,
      
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

    
	-- insert into table 5/8 
    -- by inserting all information stored in process_bom into process_bom_total and process_bom gets dropped
    -- left 3/8 columns will be added later
     INSERT INTO process_bom_total 

     (product_id,
     
     process_id,
     
     source_type,

     ingredient_id,

     quantity,

     uomid,

     uom,
     
     if_persistent)

    SELECT pb.product_id,
    
           pb.process_id,
			
		   source_type,

           ingredient_id,

           sum(quantity), -- note here is the sum of quantity group by sourcetype i.id, i.name, uomid

           pb.uomid,

           u.name,
           
           m.if_persistent

           
	 FROM process_bom pb, uom u, material m

     WHERE u.id = pb.uomid
     
     AND pb.ingredient_id = m.id

     GROUP BY pb.product_id, pb.process_id, source_type, ingredient_id, ingredient_name, pb.uomid;

     

    DROP TABLE process_bom;

    
	-- added left 3/8 columns: 
    -- bring in information on ingredient name, alert_quantity, description from material
    -- for 'material' source_type of ingredients
    UPDATE process_bom_total pb, material m

       SET pb.ingredient_name = m.name,

           pb.alert_quantity = m.alert_quantity,

           pb.description = m.description
           
     WHERE pb.source_type = 'material'

       AND pb.ingredient_id = m.id;

       
	-- for 'product' source_type of ingredients. alert_quantity will not be updated
    UPDATE process_bom_total pb, product p

       SET pb.ingredient_name = p.name,

           pb.description = p.description
           
     WHERE pb.source_type = 'product'

       AND pb.ingredient_id = p.id;

    
	-- merge information on all kinds of quantity variables
      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_temp 

    (
      product_id int(10) unsigned,
      
      process_id int(10) unsigned,
      
      source_type varchar(20),

      ingredient_id int(10) unsigned,

      unassigned_quantity_raw varchar(31), 

      assigned_quantity_show varchar(31), -- ?

      unassigned_quantity decimal(16,4) unsigned, -- ?

      unassigned_uomid smallint(3) unsigned, -- ?

      ifalert tinyint(1) unsigned

    ) DEFAULT CHARSET=utf8;  

    

    INSERT INTO process_bom_temp

    (product_id, process_id, source_type, ingredient_id, unassigned_quantity_raw, assigned_quantity_show, ifalert)

    SELECT product_id,
           
           process_id,
           
           source_type,

           ingredient_id,
           
		-- unassigned_quantity_raw: contained total ingreditent quantity for both sourcetype ('material', 'product')
        -- without in_order_id
        -- or with in_order_id existing in order_general and 'inventory' order_type and state of 'produced'
        
           ifnull((SELECT concat(sum(inv.actual_quantity), ',', max(inv.uom_id)) -- ?

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
		
           -- assigned_quantity_show: contained total ingreditent quantity for both sourcetype ('material', 'product')
           -- with in_order_id existing in order_general and ('inventory', 'customer') order_type 
           -- and state not in 'produced'
           
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

             0 -- ifalert

     

      FROM process_bom_total pb 
      
      Where pb.if_persistent = 1;

      

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

      SET pt.ifalert =if(pt.unassigned_quantity=0 OR convert_quantity(pt.unassigned_quantity, pt.unassigned_uomid, pb.uomid)<pb.alert_quantity, 1, 0) -- ? convert_quantity

     WHERE pb.source_type = pt.source_type

       AND pb.ingredient_id = pt.ingredient_id;
       
       
    CREATE TEMPORARY TABLE IF NOT EXISTS new_order_demand_prediction_temp
    (
        product_id int(10) unsigned,
        
        process_id int(10) unsigned,
        
        process_name varchar(255), 
        
        final_product_quantity int(10) unsigned
        
    )DEFAULT CHARSET=utf8;  
    
    
    Insert Into new_order_demand_prediction_temp
    
    SELECT 
           pt.product_id,
           
           pt.process_id,
           
           p.name,
           
           min(pb.unassigned_quantity / pt.quantity)
           
           FROM process p, process_bom_total pt 

           JOIN process_bom_temp pb ON pt.source_type = pb.source_type AND pt.ingredient_id = pb.ingredient_id

           where p.id = pt.process_id and pt.if_persistent = 1
           
           group by product_id, process_id;
           
           
    CREATE TEMPORARY TABLE IF NOT EXISTS new_order_demand_prediction
    (
        product_id int(10) unsigned,
        
        product_demand_prediction varchar(255)
		
        
    )DEFAULT CHARSET=utf8;  
    
    
    Insert Into new_order_demand_prediction
    
    SELECT 
           p.product_id,
           
           Group_concat(concat(p.process_name, ": ", p.final_product_quantity) separator ' / ' ) -- Into _final_product_qtypt.process_id,
           
           FROM  new_order_demand_prediction_temp p

           group by product_id;
           
           
           
           
   SELECT 
           
g.id, 
  g.order_type, 
  g.ponumber, 
  g.client_id,
  c.name as ClientName,
  g.priority,
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
  d.expected_deliver_date, 
  d.actual_deliver_date, 
  g.internal_contact,
  CONCAT(e.firstname,' ',e.lastname) as internal_contact_name,
  g.external_contact, 
  d.comment ,
  g.id as order_id,
  np.product_demand_prediction
  FROM new_order_demand_prediction np, order_general g
  INNER JOIN order_detail d ON d.order_id = g.id AND d.source_type = 'product'
  AND (d.quantity_in_process + d.quantity_made + d.quantity_shipped )< d.quantity_requested
  INNER JOIN product p ON d.source_type = 'product' AND d.source_id = p.id
  LEFT JOIN client c ON g.client_id = c.id 
  LEFT JOIN priority pr ON g.priority = pr.id 
  LEFT JOIN uom u ON d.uomid = u.id 
  LEFT JOIN employee e ON g.internal_contact = e.id
  WHERE g.order_type in ('inventory', 'customer') AND np.product_id = d.source_id
   order by d.expected_deliver_date asc
    ;

    

    DROP TABLE process_bom_total;

    DROP TABLE process_bom_temp;

	DROP TABLE new_order_demand_prediction_temp;
    
    DROP TABLE new_order_demand_prediction;
--  END IF;

  

END$