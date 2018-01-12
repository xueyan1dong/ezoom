DROP PROCEDURE IF EXISTS `report_lot_status`;
CREATE PROCEDURE `report_lot_status`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
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
        l.priority,
        get_local_time(l.dispatch_time) as dispatch_time,
        get_local_time(l.output_time) as output_time,
        l.comment
  FROM lot_status l, product p , `order_general` o , client c, process pr, employee e, uom u
 WHERE l.id <=> _lot_id
   AND p.id = l.product_id
   AND o.id = l.order_id
   AND c.id = o.client_id
   AND pr.id = l.process_id
   AND e.id = l.contact
   AND u.id = l.uomid;
 
 END;