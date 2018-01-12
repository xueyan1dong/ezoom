DROP PROCEDURE IF EXISTS `modify_order_detail`;
CREATE PROCEDURE `modify_order_detail`(
  IN _operation enum('insert', 'update'),
  IN _order_id int(10) unsigned,
  IN _order_type enum('inventory', 'customer', 'supplier'),
  IN _source_id int(10) unsigned,
  IN _quantity_requested decimal(16,4) unsigned,
  IN _unit_price decimal(10,2) unsigned,
  IN _quantity_made decimal(16,4) unsigned,
  IN _quantity_in_process decimal(16,4) unsigned,
  IN _quantity_shipped decimal(16,4) unsigned,
  IN _output_date datetime,
  IN _expected_deliver_date datetime,  
  IN _actual_deliver_date datetime,
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _source_type enum('product', 'material');
  DECLARE _uomid smallint(3) unsigned;
  
  IF _operation IS NULL OR length(_operation) < 1
  THEN
    SET _response = 'No operation is defined. Please define an operation.';
  ELSEIF _order_id IS NULL
  THEN
    SET _response = 'You must select an order for adding details. Please select an order.';
  ELSEIF _order_type IS NULL OR length(_order_type) <1
  THEN
    SET _response='Order type is required. Please select an order type.';
  ELSEIF  _source_id is NULL
  THEN 
    SET _response='No item selected for ordering. Please select an item.';
  ELSEIF  _quantity_requested is NULL OR _quantity_requested <= 0
  THEN 
    SET _response='Quantity requested is required. Please fill the quantity requested.';
   
  ELSE
  
    IF _order_type IN ('inventory', 'customer')
    THEN
      SET _source_type = 'product';
      SELECT uomid INTO _uomid
        FROM product
       WHERE id = _source_id;
       
    ELSE
      SET _source_type = 'material';
      SELECT uom_id INTO _uomid
        FROM material
       WHERE id = _source_id;
    END IF;
    
    IF _uomid IS NULL
    THEN
      SET _response = 'THE product or material selected does not exist in database.';
    ELSE
    
      IF _operation = 'insert'
      THEN
        INSERT INTO `order_detail` (
          order_id,
          source_type,
          source_id,
          quantity_requested,
          unit_price,
          quantity_made,
          quantity_in_process,
          quantity_shipped,
          uomid,
          output_date,
          expected_deliver_date,
          actual_deliver_date,
          recorder_id,
          record_time,
          comment   
    )
        values (
          _order_id,
          _source_type,
          _source_id,
          _quantity_requested,
          _unit_price,
          _quantity_made,
          _quantity_in_process,
          _quantity_shipped,
          _uomid,
          _output_date,
          _expected_deliver_date,
          _actual_deliver_date,
          _recorder_id,
          now(),
          _comment
            );
      ELSEIF _operation= 'update'
      THEN
        UPDATE order_detail
          SET quantity_requested = _quantity_requested,
              unit_price = _unit_price,
              quantity_made = _quantity_made,
              quantity_in_process = _quantity_in_process,
              quantity_shipped = _quantity_shipped,
              uomid = _uomid,
              output_date = _output_date,
              expected_deliver_date = _expected_deliver_date,
              actual_deliver_date = _actual_deliver_date,
              recorder_id = _recorder_id,
              record_time = now(),
              comment = _comment
        WHERE order_id = _order_id
          AND source_type = _source_type
          AND source_id = _source_id;
      END IF;
    END IF;
  END IF;
END;
