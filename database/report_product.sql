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
DROP PROCEDURE IF EXISTS `report_product`$
CREATE PROCEDURE `report_product`(
  IN _product_id int(10) unsigned,
  IN _order_id int(10) unsigned,
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
  IF _product_id IS NULL
  THEN
    SET _response = "Product is required. Please select a product.";
  ELSEIF _order_id IS NULL OR length(_order_id) = 0
  THEN
    SELECT h.lot_id,
           h.lot_alias,
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
           IF(h.status='dispatched', 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
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
                                           
     WHERE l.product_id = _product_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  
       
  ELSE
    SELECT h.lot_id,
           h.lot_alias,
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
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
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
     WHERE l.product_id = _product_id
       AND l.order_id = _order_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  END IF;
END$
