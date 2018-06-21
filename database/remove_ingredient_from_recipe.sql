/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : remove_ingredient_from_recipe.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `remove_ingredient_from_recipe`$
CREATE procedure remove_ingredient_from_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type varchar(10),
  IN _order tinyint(3) unsigned,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
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
    SET _response = 'Source Type is required.';
  ELSEIF _source_type !='product' AND _source_type!= 'material'
  THEN
    SET _response = 'Source Type can only have the value of "product" or "material". Please correct the value.';
    
  ELSE
      SELECT name INTO ifexist
        FROM recipe
      WHERE id =_recipe_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The employee who is adding this ingredient does not exist in database.';
        ELSE
        
        IF NOT EXISTS (SELECT * FROM ingredients
                        WHERE recipe_id = _recipe_id
                          AND source_type = _source_type
                          AND ingredient_id = _ingredient_id
                          AND `order` <=> _order)
        THEN
          IF _response IS NULL
          THEN
            SET _response = 'The ingredient you selected does not exist in database.';
          END IF;
        ELSE
          DELETE FROM ingredients
           WHERE recipe_id = _recipe_id
             AND source_type = _source_type
             AND ingredient_id = _ingredient_id
             AND `order` <=> _order;

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
            'delete',
            recipe_id,
            source_type,
            ingredient_id,
            quantity,
            uom_id,
            `order`,
            mintime,
            maxtime,
            _comment 
           FROM ingredients
          WHERE recipe_id = _recipe_id
            AND source_type = _source_type
            AND ingredient_id = _ingredient_id
            AND `order` <=> _order
          ;
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END$
