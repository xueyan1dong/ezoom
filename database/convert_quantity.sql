/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : convert_quantity.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP FUNCTION IF EXISTS `convert_quantity`$
CREATE FUNCTION `convert_quantity`(
   _quantity decimal(16,4) unsigned,
   _from_uomid smallint(3) unsigned,
   _to_uomid smallint(3) unsigned
)
RETURNS decimal(16,4) unsigned
BEGIN
  
  DECLARE _to_quantity decimal(16,4) unsigned;
  
  IF _from_uomid = _to_uomid
  THEN
    RETURN _quantity;
  ELSE
    SELECT _quantity*constant
      INTO _to_quantity
      FROM uom_conversion
    WHERE from_id = _from_uomid
      AND method= 'ratio'
      AND to_id = _to_uomid;
  
    IF _to_quantity IS NULL
    THEN
      SELECT _quantity/constant
        INTO _to_quantity
        FROM uom_conversion
      WHERE from_id = _to_uomid
        AND method="ratio"
        AND to_id = _from_uomid
        AND constant > 0;
    END IF;
    
    return _to_quantity;
  END IF;
  
 END$