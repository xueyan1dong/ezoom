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
DROP PROCEDURE IF EXISTS `modify_material_group`$
CREATE procedure modify_material_group (
  INOUT _group_id int(10) unsigned,
  IN _name varchar(255),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Name of the material group is required. Please give the material group a name.';
    
  ELSEIF _group_id IS NULL
  THEN

    IF EXISTS (SELECT * FROM material_group WHERE name=_name)
    THEN
      SET _response= concat('The material group ' , _name , ' already exists in database.');
    ELSE
    

      INSERT INTO material_group (
        name,
        description,
        comment
      )
      VALUES (
        _name,
        _description,
        _comment
      );
      SET _group_id = last_insert_id();
      SET _response = '';
    END IF;
 ELSE
    IF EXISTS (SELECT * FROM material_group WHERE id!=_group_id AND name=_name)
    THEN
      SET _response= concat('The name ' , _name , ' is already used by another material group in database.');
    ELSE
      UPDATE material_group
         SET name = _name,
             description = _description,
             comment = _comment
       WHERE id = _group_id;
    END IF;
 END IF;
END$
