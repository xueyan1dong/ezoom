DROP PROCEDURE IF EXISTS `report_process_bom_total`;
CREATE PROCEDURE `report_process_bom_total`(
  IN _process_id int(10) unsigned
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

    
  IF _process_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    SELECT 
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id
      FROM process_step p, step s, step_type t, recipe r, ingredients i
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    SELECT  
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id;
 

      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_total 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      alert_quantity decimal(16,4) unsigned,
      description text
    ) DEFAULT CHARSET=utf8; 
    
     INSERT INTO process_bom_total 
     (source_type,
     ingredient_id,
     quantity,
     uomid,
     uom)
    SELECT source_type,
           ingredient_id,
           sum(quantity),
           pb.uomid,
           u.name
           
      FROM process_bom pb, uom u
     WHERE u.id = pb.uomid
     GROUP BY source_type, ingredient_id, ingredient_name, pb.uomid;
     
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
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      unassigned_quantity_raw varchar(31),
      assigned_quantity_show varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;  
    
    INSERT INTO process_bom_temp
    (source_type, ingredient_id, unassigned_quantity_raw, assigned_quantity_show, ifalert)
    SELECT source_type,
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
   
    SELECT pt.source_type,
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
           FROM process_bom_total pt 
           JOIN process_bom_temp pb ON pt.source_type = pb.source_type AND pt.ingredient_id = pb.ingredient_id
           LEFT JOIN uom u ON u.id = pb.unassigned_uomid;
    
    DROP TABLE process_bom_total;
    DROP TABLE process_bom_temp;
  END IF;
  
END;
