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
DROP PROCEDURE IF EXISTS `ship_lot`$
CREATE PROCEDURE `ship_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _ship_timecode char(15),
  IN _shipper_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _contact_id int(10) unsigned, 
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _ship_time datetime;
  DECLARE _process_id int(10) unsigned;
  DECLARE _sub_process_id int(10) unsigned;
  DECLARE _position_id int(5) unsigned;
  DECLARE _sub_position_id int(5) unsigned;
  DECLARE _step_id int(10) unsigned;  
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Lot identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The lot you supplied does not exist in database";
    ELSE
      SET _ship_time = str_to_date(_ship_timecode, '%Y%m%d%H%i%s0' );
      
      START TRANSACTION;
      
      INSERT INTO inventory (
        source_type,
        pd_or_mt_id,
        supplier_id,
        lot_id,
        in_order_id,
        original_quantity,
        actual_quantity,
        uom_id,
        manufacture_date,
        expiration_date,
        arrive_date,
        recorded_by,
        contact_employee,
        comment
        )
      SELECT 'manufactured',
             l.product_id,
             0,
             l.id,
             l.order_id,
             _quantity,
             _quantity,
             l.uomid,
             _ship_time,
             if(p.lifespan > 0, date_add(_ship_time, INTERVAL p.lifespan DAY), NULL),
             _ship_time,
             _shipper_id,
             _contact_id,
             _comment
        FROM lot_status l, product p
       WHERE l.id=_lot_id
         AND p.id = l.product_id;
         
      IF row_count() > 0 THEN
        SET _inventory_id = last_insert_id();
        
        UPDATE `order` o, lot_status l
           SET quantity_made = quantity_made + _quantity,
               quantity_in_process = if(quantity_in_process < _quantity, 0, quantity_in_process - _quantity)
         WHERE l.id = _lot_id
           AND l.order_id = o.id;
        
        IF row_count() >= 0 THEN
        -- update lot history
          CALL end_lot_step(
            _lot_id,
            _lot_alias,
            _ship_timecode,
            _shipper_id,
            _quantity,
            null,
            null,
            _process_id,
            _sub_process_id,
            _position_id,
            _sub_position_id,
            _step_id,
            _response);
            
          IF _response IS NULL THEN
            COMMIT;
          ELSE
            ROLLBACK;
          END IF;
        ELSE
          ROLLBACK;
        END IF;
      ELSE
        ROLLBACK;
        SET _response = concat('Database error encountered when shipping lot ', _lot_id , ' to warehouse');
      END IF;
      
    END IF;
    
  END IF;
END$
