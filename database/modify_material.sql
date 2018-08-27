/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_material.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Insert or update material (item/part in UI) into the material table
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    6/29/2018: Xueyan Dong: added code to also record _alias into the alias column of material table.	
*	 8/26/2018: Peiyu Ge: added a flag if_persistent to indicate if an item/part is intermediate 			
*/
DELIMITER $

DROP PROCEDURE IF EXISTS `modify_material`$
CREATE procedure modify_material (
  INOUT _material_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  IN _name varchar(255),
  IN _alias varchar(255), -- currently take in supplier_id information. x.d. Feb 7, 2011
  IN _mg_id int(10) unsigned,
  IN _material_form enum('solid','liquid','gas'),
  IN _status enum('inactive','production','frozen'),
  IN _if_persistent boolean,
  IN _alert_quantity decimal(16,4) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Material name is required. Please give the material a name.';
    
  ELSEIF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.';  
  ELSEIF _material_id IS NULL
  THEN

    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id;
    
    IF ifexist IS NULL
    THEN
      INSERT INTO material (
        name,
        mg_id,
        alias,
        uom_id,
        alert_quantity,
        lot_size,
        material_form,
        status,
        enlist_time,
        enlisted_by,
        description,
        comment,
		if_persistent
      )
      VALUES (
        _name,
        _mg_id,
        _alias,
        _uom_id,
        _alert_quantity,
        _lot_size,
        _material_form,
        _status,
        now(),
        _employee_id,
        _description,
        _comment,
		_if_persistent
      );
      SET _material_id = last_insert_id();

    ELSE
      SET _response= concat('The material ' , _name , ' already exists in table.');
    END IF;
 ELSE
    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id
      AND id != _material_id;
      
    IF ifexist IS NULL
    THEN
      UPDATE material
         SET name = _name,
             mg_id = _mg_id,
             alias = _alias,
             uom_id = _uom_id,
             alert_quantity = _alert_quantity,
             lot_size = _lot_size,
             material_form =_material_form,
             status = _status,
             update_time = now(),
             updated_by = _employee_id,
             description = _description,
             comment = _comment,
			 if_persistent = _if_persistent
       WHERE id = _material_id;
    ELSE
      SET _response = concat('The material name ' , _name , ' is already used by another material in table.');
    END IF;
 END IF;
 IF _response IS NULL AND _material_id IS NOT NULL AND _alias IS NOT NULL
 THEN
  IF NOT EXISTS (SELECT * FROM material_supplier WHERE material_id = _material_id AND supplier_id = _alias)
  THEN
    INSERT INTO material_supplier
    (material_id
    ,supplier_id
    )
    VALUES(_material_id, _alias);
  END IF;
 END IF;
END$
