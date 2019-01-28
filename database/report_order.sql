/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_order.sql
*    Created By             : Peiyu Ge 
*    Date Created           : 1/13/2019
*    Platform Dependencies  : MySql
*    Description            : Given an order id, list all products in that order if product_id and lot_status are not provide. Otherwise list only specified products.
*    example	            : 
*    Log                    :1/25/19 revised code to account for null selection of product_id, so basicly when product_id is null, display all products in the given order. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_order`$
CREATE PROCEDURE `report_order`(
  IN _order_id int(10) unsigned,
  IN _product_id int(10) unsigned,
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _response varchar(255)
)
BEGIN
-- given an order id, a product_id and lot_status, shows reports on other information of the given product in the order at the current status
-- 1/13/2019

IF _order_id IS NULL
  THEN
    SET _response = "Order is required. Please select an order.";
ELSEIF _product_id IS NULL OR length(_product_id) = 0 Then
	SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           l.order_line_num as po_linenumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           get_local_time(str_to_date(l.update_timecode, '%Y%m%d%H%i%s0' )) AS last_move_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           IF(h.status='dispatched','',(select name from step s1 where s1.id = lh1.step_id))as pre_step,-- dispatch has no previous step , position 1 without reposition has no prvious step either
           'next' as pre_step,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
            
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
		   FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)
		   Left join lot_history lh1 on lh1.lot_id = h.lot_id and lh1.start_timecode = (SELECT start_timecode from lot_history lh2-- start_timecode from lot_history lh1
                                          WHERE lh2.lot_id=h.lot_id
                                            order by start_timecode desc
                                            limit 1
										    offset 1)
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
     WHERE l.order_id = _order_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
Else 
	SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           l.order_line_num as po_linenumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           get_local_time(str_to_date(l.update_timecode, '%Y%m%d%H%i%s0' )) AS last_move_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           IF(h.status='dispatched', -- dispatch has no previous step , position 1 without reposition has no prvious step either
			'',
		   (select name from step s1, lot_history lh
			Where lh.start_timecode = (select max(start_timecode) from lot_history where start_timecode < (select max(start_timecode) from lot_history where lot_id = h.lot_id)) 
			   and lh.lot_id = h.lot_id
               and s1.id = lh.step_id
			  )
			)as pre_step,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
            
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
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
     WHERE l.order_id = _order_id
       AND l.product_id = _product_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
end if;
END $