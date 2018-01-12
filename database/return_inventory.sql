DROP PROCEDURE IF EXISTS `return_inventory`;
CREATE PROCEDURE `return_inventory`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _consumption_start_timecode char(15),
  IN _inventory_id int(10) unsigned,
  IN _quantity_returned decimal(16,4) unsigned,
  IN _comment text, 
  IN _recipe_uomid smallint(3) unsigned,  
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_return_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
  DECLARE _quantity_before decimal(16,4) unsigned;
  
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
  )
  THEN
    SET _response = "The batch you selected hasn't reach the step given.";
  ELSE
    SELECT quantity_used
      INTO _quantity_before
      FROM inventory_consumption
     WHERE lot_id = _lot_id
       AND start_timecode = _consumption_start_timecode
       AND inventory_id = _inventory_id;
       
    SELECT uom_id
      INTO _inventory_uomid
      FROM inventory
     WHERE id=_inventory_id;
    
    IF _quantity_before < _quantity_returned
    THEN
      SET _response = CONCAT("The quantity used ", _quantity_before, " is less than quantity to return. Please refresh form and reenter return quantity.");
    ELSEIF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
      SET _inv_return_quantity=convert_quantity(_quantity_returned, _recipe_uomid, _inventory_uomid);
      IF _inv_return_quantity IS NULL
      THEN
        SET _response = "Can not calculate inventory return because no UoM conversion provided to convert returned quantity into the UoM used in inventory.";

      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
        INSERT INTO `consumption_return` (
          `lot_id` ,
          `lot_alias` ,
          `return_timecode` ,
          `inventory_id` ,
          `quantity_before` ,
          `quantity_returned` ,
          `uom_id`  , 
          `operator_id`,
          `step_start_timecode` ,
          `consumption_start_timecode` ,
          `process_id` ,
          `step_id` ,
          `comment` )
           VALUES(
           _lot_id,
           _lot_alias,
           _timecode,
           _inventory_id,
           _quantity_before,
           _quantity_returned,
           _recipe_uomid,
           _operator_id,
           _step_start_timecode,
           _consumption_start_timecode,
           _process_id,
           _step_id,
           _comment
           );
          
          IF (_quantity_before = _quantity_returned)
          THEN
            DELETE FROM inventory_consumption
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;            
          ELSE
            UPDATE inventory_consumption
              SET quantity_used = quantity_used - _quantity_returned
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;   
          END IF;
          
          UPDATE inventory
             SET actual_quantity = actual_quantity + _inv_return_quantity
           WHERE id=_inventory_id;
           
        COMMIT;
      END IF;
    END IF;
  END IF;
END;
