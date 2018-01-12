DROP PROCEDURE IF EXISTS `insert_uom_conversion`;
CREATE procedure insert_uom_conversion (
  IN _from_id smallint(3) unsigned,
  IN _to_id smallint(3) unsigned,
  IN _method enum('ratio', 'reduction', 'addtion'),
  IN _constant decimal(16,4) unsigned,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN


  
  IF _from_id IS NULL
  THEN
    SET _response='From UoM is required. Please select a From UoM.';
    
  ELSEIF _to_id IS NULL
  THEN
    SET _response = 'To UoM is required. Please select a To UoM.';    
  ELSEIF _method IS NULL
  THEN
    SET _response = 'Converting Method is required. Please select a method.';
  ELSEIF _constant IS NULL 
  THEN
    SET _response = 'Conversion costant is required. Please provide a constant.';
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_from_id)
  THEN
    SET _response = 'The From Uom does not exist in database.';    
    
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_to_id)
  THEN
    SET _response = 'The To Uom does not exist in database.';  
  ELSEIF EXISTS (SELECT * FROM uom_conversion WHERE from_id = _from_id AND to_id=_to_id)
  THEN
    SET _response = 'The conversion between the selected UoMs already exists in database.';     
  ELSE

  INSERT INTO uom_conversion
  (from_id, to_id, method,constant, comment)
  VALUES (_from_id, _to_id, _method, _constant, _comment);
 END IF;
END;
