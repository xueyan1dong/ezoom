/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : delete_material.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `delete_material`$

-- delete a material and its suppliers from material_supplier table
-- a material can't be deleted if it is used by active process/workflow
CREATE procedure delete_material (
  IN _material_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
) 
BEGIN

  IF _material_id IS NULL OR NOT EXISTS (SELECT * FROM material WHERE id=_material_id)
  THEN
    SET _response = "The material you provided doesn't exist.";
    
  ELSEIF EXISTS (SELECT i.ingredient_id
                   FROM ingredients i, recipe r, step s, process_step ps, process p
                  WHERE i.source_type = 'material'
                    AND i.ingredient_id = _material_id
                    AND r.id = i.recipe_id
                    AND s.recipe_id = r.id
                    AND ps.step_id = s.id
                    AND p.id = ps.process_id
                    AND p.state='production'
                    )
  THEN
    SELECT CONCAT('The material ', name, " can't be deleted, because it is in use by a production workflow.")
      INTO _response
      FROM material
     WHERE id = _material_id;
  ELSE
    DELETE FROM material_supplier
     WHERE material_id = _material_id;
    DELETE FROM material
     WHERE id = _material_id;
  END IF;
END$
