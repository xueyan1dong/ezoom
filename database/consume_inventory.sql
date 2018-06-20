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
DROP PROCEDURE IF EXISTS `consume_inventory`$
CREATE PROCEDURE `consume_inventory`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _inventory_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _comment text,
  IN _recipe_uomid smallint(3) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_consume_quantity decimal(16,4) unsigned;
  DECLARE _inv_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
 
  SET autocommit=0;

  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch indentifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSEIF NOT EXISTS (
    SELECT *
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _step_start_timecode
       AND process_id = _process_id
       AND sub_process_id <=> _sub_process_id
       AND position_id = _position_id
       AND sub_position_id <=> _sub_position_id
       AND step_id = _step_id
  )
  THEN
    SET _response = "The batch you selected is not at the step and position given.";
  ELSE
    SELECT uom_id, actual_quantity
      INTO _inventory_uomid, _inv_quantity
      FROM inventory
     WHERE id=_inventory_id;
    
    IF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
      SET _inv_consume_quantity=convert_quantity(_quantity, _recipe_uomid, _inventory_uomid);
      IF _inv_consume_quantity IS NULL
      THEN
        SET _response = "Can not calculate consumption because no UoM conversion provided to convert quantity into the UoM used in inventory.";
      ELSEIF _inv_consume_quantity > _inv_quantity
      THEN
        SET _response = "The inventory doesn't have enough to meet the quantity required.";
      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
          INSERT INTO inventory_consumption
          (lot_id,
           lot_alias,
           start_timecode,
           end_timecode,
           inventory_id,
           quantity_used,
           uom_id,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           operator_id,
           equipment_id,
           device_id,
           comment
           )
           VALUES(
           _lot_id,
           _lot_alias,
           _timecode,
           _timecode,
           _inventory_id,
           _quantity,
           _recipe_uomid,
           _process_id,
           _sub_process_id,
           _position_id,
           _sub_position_id,
           _step_id,
           _operator_id,
           _equipment_id,
           _device_id,
           _comment
           );
           
          UPDATE inventory
             SET actual_quantity = actual_quantity - _inv_consume_quantity
           WHERE id=_inventory_id;
           
        COMMIT;
      END IF;
    END IF;
  END IF;
END$
