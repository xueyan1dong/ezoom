DROP PROCEDURE IF EXISTS `modify_ingredient_in_recipe`;
CREATE procedure modify_ingredient_in_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _old_order tinyint(3) unsigned,
  IN _new_order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
) 

-- user is not allowed to modify ingredient choosen, source type using this procedure.
-- Quantity, order, min time, max time, comment are modifiable.
BEGIN
  DECLARE ifexist varchar(255);
  -- DECLARE _uom_id smallint(3) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source type is required.';
    
  ELSEIF _quantity IS NULL
  THEN
    SET _response = 'Quantity is required.'; 
    

    
  ELSE
      
      IF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE  
         IF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
         THEN
           SET _response = 'The employee who is adding this ingredient does not exist in database.';
         ELSE
          
          IF NOT EXISTS 
          (SELECT *
             FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND `order`= _old_order
          ) 
          THEN
              SET _response = 'The ingredient you selected does not exist in database.';
          ELSEIF _new_order != _old_order AND EXISTS
           (SELECT *
              FROM ingredients
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND `order` = _new_order
           )
          THEN
            SET _response =concat( 'The ingredient already exists at order ', _new_order);
          ELSE
            UPDATE ingredients
               SET quantity = _quantity,
                   `order` = _new_order,
                   mintime = _mintime,
                   maxtime = _maxtime,
                   comment = _comment
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND ingredient_id = _ingredient_id
               AND `order` = _old_order;


            INSERT INTO ingredients_history
            (
              event_time,
              employee_id,
              action,
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment              
            )
            SELECT
              _eventtime,
              _employee_id,
              'modify',
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment             
            FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND ingredient_id = _ingredient_id
              AND `order` = _new_order;
              
            UPDATE recipe
               SET update_time = _eventtime,
                   updated_by = _employee_id
             WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END;
