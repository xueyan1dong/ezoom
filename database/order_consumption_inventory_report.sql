/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : order consumption inventory report.sql
*    Created By             : Peiyu Ge 
*    Date Created           : 6/14/2019
*    Platform Dependencies  : MySql
*    Description            : Provided with open order id, check any ongoing batches that are at step 8 (consumption material step). Listed those batches with other infor such as
*                             ingredient_id, inventory location, et cetera.
*/

DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `order_consumption_inventory_report`$
CREATE PROCEDURE `order_consumption_inventory_report`(
  IN _order_id int(10) unsigned,
  IN _product_id int(10) unsigned,
  OUT _response varchar(255)
)

BEGIN
IF _order_id IS NULL
  THEN
    SET _response = "Order is required. Please select an order.";
Else 
	SELECT #h.lot_id,
           h.lot_alias,
           l1.name as batch_location,
           l.order_line_num as po_line_no,
           s.name as step_name,
           l.actual_quantity as current_quantity,
           ingredients.ingredient_id as component_part_no,
           inventory.actual_quantity as component_inventory,
           l2.name as inventory_location,

           IF(h.status='dispatched', -- dispatch has no previous step , position 1 without reposition has no prvious step either
			'',
		   (select name from step s1, lot_history lh
			Where lh.start_timecode = (select max(start_timecode) from lot_history where start_timecode < (select max(start_timecode) from lot_history where lot_id = h.lot_id)) 
			   and lh.lot_id = h.lot_id
               and s1.id = lh.step_id
			  )
			)as prev_step,
           
           if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
            
           
           get_local_time(l.dispatch_time) AS dispatch_time,
           get_local_time(str_to_date(l.update_timecode, '%Y%m%d%H%i%s0' )) AS last_move_time
           
		   FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
           LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h.position_id = 0, 1, h.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
           LEFT JOIN location l1 on l.location_id = l1.id
           LEFT JOIN ingredients on ingredients.recipe_id = s.recipe_id
           LEFT JOIN (select pd_or_mt_id, location_id, actual_quantity from inventory group by pd_or_mt_id order by actual_quantity) as inventory on inventory.pd_or_mt_id = ingredients.ingredient_id
           LEFT JOIN location l2 on inventory.location_id = l2.id
     WHERE l.order_id = _order_id
       AND if(_product_id IS NULL, 1=1, l.product_id = _product_id)
       AND s.step_type_id = 8 #consumption step
       AND l.`status` != 'done'
       AND l.quantity_status != 'made'
     ORDER BY l.status;
end if;
END

