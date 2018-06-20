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
DROP PROCEDURE IF EXISTS `modify_uom`$
CREATE PROCEDURE `modify_uom`(
  INOUT _uom_id smallint(3) unsigned, 
  IN _name varchar(20),
  IN _alias varchar(20),
  IN _description varchar(255),
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='UoM name is required. Please give the UoM a name.';
  ELSE
    IF _uom_id IS NULL
    THEN
      
      IF EXISTS (SELECT * FROM uom WHERE name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another unit of measure. Please change the UoM name and try again.');
      ELSE
        INSERT INTO uom (name,alias, description)
        VALUES (_name, _alias, _description);
        SET _uom_id = last_insert_id();
        SET _response = '';
      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM uom WHERE alias=_alias AND id != _uom_id)
      THEN
        SET _response= concat('The alias ', _alias,' is already used by another UoM. Please change it and try again.');
      ELSE
          
        UPDATE uom
          SET alias = _alias,
              description = _description
        WHERE id = _uom_id;
      END IF;
    END IF; 
  END IF;
END$
