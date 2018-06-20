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
DROP PROCEDURE IF EXISTS `delete_recipe`$
CREATE PROCEDURE `delete_recipe`(
  IN _recipe_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _event_time datetime;
  SET _event_time = now();
  
  IF _recipe_id IS NULL
  THEN
    SET _response='No recipe selected. Please select a recipe to delete.';
    
  ELSEIF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
  THEN
    SET _response = 'The selected recipe does not exist in database';
  ELSEIF _employee_id IS NULL
  THEN
    SET _response='Employee information that initiated deletion is missing .'; 
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN
    SET _response = 'The employee that initiated deletion does not have record in database.';
  ELSE
    START TRANSACTION;
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
        _event_time,
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
        'delete recipe'  
      FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM recipe
      WHERE id = _recipe_id;
     
    COMMIT;    
  END IF;
END$
