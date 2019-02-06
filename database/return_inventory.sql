/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : return_inventory.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for return products or components back to inventory
*    example	            : 
call return_inventory (21, 'WWMTOFauce0000000006', 2, 3, 38, '201806190044480', '201806190044480', 6, 1, 'test', 1, @_response);
select @_response
*    Log                    :
*    6/14/2018: sdong: added this header session
*    6/17/2018: sdong: added more comment
*    6/18/2018: sdong: since when used in disassemble step, the quantity_before is null, which will throw off consumption_return
*                      table, thus, replace it with 0 in this case. Also, fixed typo.
*    02/05/2019: xdong: widen _lot_alias input from varchar(20) to varchar(30) following table changes of the same column
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `return_inventory`$
CREATE PROCEDURE `return_inventory`(
  IN _lot_id int(10) unsigned,  -- id of the batch
  IN _lot_alias varchar(30),   -- name of the batch
  IN _operator_id int(10) unsigned,  -- id of the operator performed this action
  IN _process_id int(10) unsigned,   -- id of the workflow
  IN _step_id int(10) unsigned,     -- id of the step
  IN _step_start_timecode char(15),  -- the start time of the lot to the step
  IN _consumption_start_timecode char(15),  -- the start time of the last consumption if the current step is a "consume material" step
			-- the start time of the current step if the current step is a "disassemble" step, since there is no consumption in such a step
  IN _inventory_id int(10) unsigned, -- id of the inventory to be returned
  IN _quantity_returned decimal(16,4) unsigned,  -- the quantity to be returned
  IN _comment text,   -- comment associated with this action
  IN _recipe_uomid smallint(3) unsigned,    -- the id of the uom used in the recipe
  OUT _response varchar(255)    -- response of this stored procedure
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_return_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
  DECLARE _quantity_before decimal(16,4) unsigned;
  DECLARE _step_type varchar(20);
  
  SET autocommit=0;

-- integrity checks
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
  
	SELECT st.name
      INTO _step_type
      FROM step_type st
	  JOIN step s
        ON s.step_type_id = st.id
           AND s.id = _step_id;
           
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
    

    IF _step_type = 'consume material' AND _quantity_before < _quantity_returned
    -- for consume step, you can only return what has been consumed. _quantity_before is what has been consumed
    THEN
      SET _response = CONCAT("The quantity used ", _quantity_before, " is less than quantity to return. Please refresh form and reenter return quantity.");
    ELSEIF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
	  -- the uom used in inventory record might be different than the uom used in recipe. below conversion calculates the qunatity by inventory uom
      SET _inv_return_quantity=convert_quantity(_quantity_returned, _recipe_uomid, _inventory_uomid);
      
      IF _inv_return_quantity IS NULL
      THEN
        SET _response = "Can not calculate inventory return because no UoM conversion provided to convert returned quantity into the UoM used in inventory.";

      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
        -- record the returns happend in consumption step or disassemble step
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
           ifnull(_quantity_before, 0),
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
END$
