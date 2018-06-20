/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_process_bom`$
CREATE PROCEDURE `report_process_bom`(
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
      position_id int(10) unsigned,
      sub_position_id int(10) unsigned,
      step varchar(255),
      recipe varchar(255),
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      input_order tinyint(3) unsigned,
      alert_quantity decimal(16,4) unsigned,      
      unassigned_quantity_raw varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      unassigned_uom varchar(20),
      assigned_quantity_show varchar(31),
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    (
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uomid,
      uom,
      input_order   
    )
    SELECT position_id,
          null,
          s.name,
          r.name,
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id,
          u.name,
          if(i.order>0, i.order, null)
      FROM process_step p, step s, step_type t, recipe r, ingredients i, uom u
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id
      AND u.id = i.uom_id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    (
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uomid,
      uom,
      input_order   
    )    
    SELECT  p.position_id,
            p1.position_id,
            s.name,
            r.name,
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id,
            u.name,
            if(i.order>0, i.order, null)
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i,  uom u
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id
      AND u.id = i.uom_id;
      
    UPDATE process_bom pb, material m
       SET pb.ingredient_name = m.name,
           pb.alert_quantity = m.alert_quantity
     WHERE pb.source_type = 'material'
       AND pb.ingredient_id = m.id;
       
    UPDATE process_bom pb, product p
       SET pb.ingredient_name = p.name
     WHERE pb.source_type = 'product'
       AND pb.ingredient_id = p.id;
  
    UPDATE process_bom pb
       SET unassigned_quantity_raw=
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
                  (inv.in_order_id IS NULL))), 0),
            assigned_quantity_show=
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
                                                 AND os.state = 'produced'))),0);
                                                 
    UPDATE process_bom
       SET unassigned_quantity = CAST(LEFT(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')) AS DECIMAL),
           unassigned_uomid =SUBSTRING(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')+1)
     WHERE unassigned_quantity_raw != '0';  
     
     UPDATE process_bom
       SET unassigned_quantity = 0,
           unassigned_uomid =0
     WHERE unassigned_quantity_raw = '0';      
     
     UPDATE process_bom pb LEFT JOIN uom u ON unassigned_uomid = u.id
        SET unassigned_uom = u.name,
            ifalert=if(pb.unassigned_quantity=0 OR convert_quantity(pb.unassigned_quantity, pb.unassigned_uomid, pb.uomid) < pb.alert_quantity, 1, 0)
      ;    
     
    SELECT 
      position_id,
      sub_position_id,
      step,
      recipe,
      source_type,
      ingredient_id,
      ingredient_name,
      quantity,
      uom,
      input_order,
      alert_quantity,      
      unassigned_quantity,
      unassigned_uom,
      assigned_quantity_show,
      ifalert    
      FROM process_bom
     ORDER BY position_id, sub_position_id, input_order;

    DROP TABLE process_bom;
  END IF;
END$
