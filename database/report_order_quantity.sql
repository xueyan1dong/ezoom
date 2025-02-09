/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_order_quantity.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Report the quantities of given order's detail lines. Currently used by Order Status Report
*    example	            : 
CALL report_order_quantity (7);
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    6/20/2018: Xueyan Dong: added call example to header			
*   12/03/2018: Xueyan Dong: added line_num to the output (included product_name in the column for display in application report)
*/

DELIMITER $  
DROP PROCEDURE IF EXISTS `report_order_quantity`$
CREATE PROCEDURE `report_order_quantity`(
  IN _order_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _order_id IS NOT NULL
  THEN

      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            CONCAT(od.line_num, '. ', p.name) AS line_num,
            p.id as product_id,
            p.name as product_name,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      JOIN product p ON od.source_type = 'product' AND od.source_id=p.id
      WHERE o.id = _order_id
        AND o.order_type in ('inventory', 'customer')
        AND od.source_type='product'; 
  END IF;
END$
