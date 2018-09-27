/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_order_detail.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Insert new order detail/product record or modify existing order detail record. Note that when modifying
*                             Order Id, Source Type, Source Id, Line Number are acting as anchor for finding the record
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    09/25/2018: Xueyan Dong: removed input parameter _order_type and added input parameters: _source_type, _line_num, and _uomid
*                             added logic for checking against unique key
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_order_detail` $
CREATE PROCEDURE `modify_order_detail`(
  IN _operation enum('insert', 'update'),
  IN _order_id int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _source_id int(10) unsigned,
  IN _line_num smallint(5) unsigned,
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
  IN _uomid smallint(3) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _origin_uomid smallint(3) unsigned;
  
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
  ELSEIF EXISTS (SELECT line_num 
				   FROM order_detail 
				  WHERE order_id = _order_id
                    AND source_type = _source_type
                    AND source_id = _source_id
                    AND line_num = _line_num)
  THEN
	SET _response = CONCAT('The same detail line ', _line_num , ' has been recorded'); 
  ELSE
	IF _source_type IS NULL  -- if source type is null, pull default by order type
    THEN
		IF _order_type IN ('inventory', 'customer')
		THEN
		  SET _source_type = 'product';
		ELSE
		  SET _source_type = 'material';
		END IF;
    END IF;
    
    -- pull out original uomid
    IF _source_type = 'product'
    THEN
      SELECT uomid INTO _origin_uomid
        FROM product
       WHERE id = _source_id;
    ELSE
      SELECT uom_id INTO _origin_uomid
        FROM material
       WHERE id = _source_id;
    END IF;
    
    IF _origin_uomid IS NULL
    THEN
      SET _response = 'THE product or material selected does not exist in database.';
    ELSE

      IF _operation = 'insert'
      THEN
        INSERT INTO `order_detail` (
          order_id,
          source_type,
          source_id,
          line_num,
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
          _line_num,
	      _quantity_requested, -- IFNULL(_quantity_requested, (_quantity_requested, _uomid, _origin_uomid)),
          _unit_price,
          _quantity_made, -- IFNULL(_quantity_made, (_quantity_made, _uomid, _origin_uomid)),
          _quantity_in_process, -- IFNULL(_quantity_in_process, (_quantity_in_process, _uomid, _origin_uomid)),
          _quantity_shipped, -- ifNULL(_quantity_shipped, (_quantity_shipped, _uomid, _origin_uomid)),
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
          AND source_id = _source_id
          AND line_num = _line_num;
      END IF;
    END IF;
  END IF;
END$
