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
DROP PROCEDURE IF EXISTS `add_ingredient_to_recipe`$
CREATE procedure add_ingredient_to_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _uom_id smallint(3) unsigned;
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
        
          SET ifexist=NULL;
          IF _source_type = 'product'
          THEN
            SELECT name,
                   uomid
             INTO ifexist, _uom_id
              FROM product
              WHERE id=_ingredient_id;
          ELSEIF _source_type = 'material'
          THEN
            SELECT name,
                   uom_id
              INTO ifexist, _uom_id
              FROM material
              WHERE id=_ingredient_id;
          ELSE
            SET _response = concat('Source type ' , _source_type , ' is not valid.');
          END IF;
          
          IF ifexist IS NULL 
          THEN
            IF _response IS NULL
            THEN
              SET _response = 'The ingredient you selected does not exist in database.';
            END IF;
          ELSE
              INSERT INTO ingredients
              (
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
              VALUES (
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment
              );

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
              VALUES (
                _eventtime,
                _employee_id,
                'insert',
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment             
              );
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END$
