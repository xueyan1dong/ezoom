/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : duplicate_recipe.sql
*    Created By             : JunLu
*    Date Created           : 05/13/2019
*    Platform Dependencies  : MySql
*    Description            : 
*    example	              :
        CALL duplicate_recipe (169, 2, @diagram_file, @resp, @new_id);
        SELECT @diagram_file, @resp, @new_id;
*    Log                    :
*    	05/13/2019 Junlu Luo: First Created
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `duplicate_recipe`$
CREATE procedure duplicate_recipe (
  IN _old_recipe_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _diagram_filename varchar(255),
  OUT _response varchar(255),
  OUT _new_recipe_id int(10) unsigned
) 
BEGIN
  SET _response = "";
  
  -- make sure the name of duplicate recipe is unique
  SET @name = "";
  SET @id = 0;
  
  SELECT `name`, `id`, `diagram_filename` INTO @name, @id, _diagram_filename
  FROM recipe
  WHERE id = _old_recipe_id;
  
  SET @new_name = "";
  SET @count = 1;
  SET @index = 1;
  WHILE @count > 0 DO
    SET @new_name = CONCAT(LEFT(@name, 17), '_', LPAD(CAST(@index AS CHAR), 2, '0'));
	SET @index = @index + 1;
    SELECT COUNT(*) INTO @count
    FROM recipe
    WHERE `name` = @new_name;
  END WHILE;
  
  -- duplicate recipe
  INSERT INTO recipe (
	`name`,
	`exec_method`,
	`contact_employee`,
	`instruction`,
	`diagram_filename`,
	`create_time`,
	`created_by`,
	`update_time`,
	`updated_by`,
	`comment`
  )
  SELECT @new_name,
	`exec_method`,
	_employee_id,
	`instruction`,
	`diagram_filename`,
	`create_time`,
	`created_by`,
	`update_time`,
	`updated_by`,
	`comment`
  FROM recipe
  WHERE id = _old_recipe_id;
  
  -- newly created recipe id
  SET _new_recipe_id = last_insert_id();
  
  -- copy ingredients
  INSERT INTO ingredients (
	  `recipe_id`,
    `source_type`,
    `ingredient_id`,
    `quantity`,
    `uom_id`,
    `order`,
    `mintime`,
    `maxtime`,
    `comment`
  )
  SELECT 
    _new_recipe_id,
    `source_type`,
    `ingredient_id`,
    `quantity`,
    `uom_id`,
    `order`,
    `mintime`,
    `maxtime`,
    `comment`
  FROM ingredients
  WHERE recipe_id = _old_recipe_id;
  
  -- copy ingredient history
  INSERT INTO ingredients_history (
	`event_time`,
	`employee_id`,
	`action`,
	`recipe_id`,
	`source_type`,
	`ingredient_id`,
	`quantity`,
	`uom_id`,
	`order`,
	`mintime`,
	`maxtime`,
	`comment`              
  )
  SELECT 
	`event_time`,
	_employee_id,
	`action`,
	_new_recipe_id,
	`source_type`,
	`ingredient_id`,
	`quantity`,
	`uom_id`,
	`order`,
	`mintime`,
	`maxtime`,
	`comment`              
  FROM ingredients_history
  WHERE recipe_id = _old_recipe_id;
END$
