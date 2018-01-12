DROP PROCEDURE IF EXISTS `report_product_quantity`;
CREATE PROCEDURE `report_product_quantity`(
  IN _product_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _product_id IS NOT NULL
  THEN

  
    
    
    SELECT name INTO _pname
      FROM product
      WHERE id = _product_id;
    
    IF _pname IS NOT NULL
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
      WHERE o.order_type in ('inventory', 'customer')
        AND od.source_type='product'
        AND od.source_id =_product_id ;
    END IF;
  
  END IF;

  

END;
