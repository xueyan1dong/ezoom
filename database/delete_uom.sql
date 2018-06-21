/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : delete_uom.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `delete_uom`$
CREATE PROCEDURE `delete_uom`(
  IN _uom_id smallint(3) unsigned
)
BEGIN


  
  IF _uom_id IS NOT NULL AND EXISTS (SELECT * FROM uom WHERE id = _uom_id)
  THEN
    START TRANSACTION;

      
      DELETE FROM uom_conversion
       WHERE from_id = _uom_id
          OR to_id = _uom_id;
      
      DELETE FROM uom
      WHERE id = _uom_id;
     
    COMMIT;    
  END IF;
END$
