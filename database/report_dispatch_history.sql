/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_dispatch_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*	 1/14/2019: Peiyu Ge: selected three more fields, line number, quantity_status, next_step.				
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_dispatch_history`$
CREATE PROCEDURE `report_dispatch_history`(
  IN _from_time datetime,
  IN _to_time datetime,
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
    
  IF _from_time IS NOT NULL AND _to_time IS NOT NULL AND _from_time < _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           l.order_line_num as po_linenumber,
           l.quantity_status,
           
           -- l.order_id,
           og.ponumber,
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
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h2.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h2.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h2.result,',',-1)), if(h2.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
           IF(h2.status ='dispatched' , 
                 '', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
		   LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h2.position_id = 0, 1, h2.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos							
     WHERE h.start_timecode between 
               DATE_FORMAT(_from_time, '%Y%m%d%H%i%s0')
           AND DATE_FORMAT(_to_time, '%Y%m%d%H%i%s0')
       AND h.status = 'dispatched';
       
  ELSEIF _from_time = _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           l.order_line_num as po_linenumber,
           l.quantity_status,
           -- l.order_id,
           og.ponumber,
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
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h2.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h2.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h2.result,',',-1)), if(h2.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
           IF(h2.status='dispatched' , 
                 ' ', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
		   LEFT JOIN step_type st ON st.id = s.step_type_id
		   LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h2.position_id = 0, 1, h2.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos	                               
     WHERE h.status = 'dispatched';
  ELSE   
      SET _response = "Both From Time and To Time need to be filled and From Time must be a datatime earlier than To Time.";
  END IF;
END$
