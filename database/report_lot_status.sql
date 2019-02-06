/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_lot_status.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    06/19/2018: Peiyu Ge: added header info. 
*    01/25/2019: Peiyu Ge: added selection of three more field, step, line_num, quantity_status.		
*		 02/05/2019: Xueyan Dong: widen _lot_alias input parameter from varchar(20) to varchar(30), following change in lot_status and lot_history table
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `report_lot_status`$
CREATE PROCEDURE `report_lot_status`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(30)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  

 SELECT l.product_id,
        p.name as product_name,
        l.order_id,
        o.ponumber,
        o.client_id,
        c.name as client_name,
        l.process_id,
        pr.name as process_name,
        l.status,
        l.start_quantity,
        l.actual_quantity,
        l.uomid,
        u.name as uom_name,
        l.contact,
        concat(e.firstname, ' ', e.lastname)as contact_name,
        l.priority,-- pri.name as priority,
        get_local_time(l.dispatch_time) as dispatch_time,
        get_local_time(l.output_time) as output_time,
        l.comment,
        s.name as step,
        l.order_line_num,
        l.quantity_status,
        if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step
 
 FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general o ON o.id = l.order_id
           LEFT JOIN product p ON p.id = l.product_id
           LEFT JOIN process pr ON pr.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e2 ON e2.id = l.dispatcher
           LEFT JOIN employee e ON e.id = l.contact
           LEFT JOIN client c ON c.id = o.client_id
           LEFT JOIN priority pri ON pri.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
           LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h.position_id = 0, 1, h.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
           WHERE l.id <=> _lot_id;
 -- FROM lot_status l, product p , `order_general` o , client c, process pr, employee e, uom u
-- WHERE l.id <=> _lot_id
--   AND p.id = l.product_id
-- AND o.id = l.order_id
--   AND c.id = o.client_id
--   AND pr.id = l.process_id
--   AND e.id = l.contact
--   AND u.id = l.uomid
 

 END$