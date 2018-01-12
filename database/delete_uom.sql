DROP PROCEDURE IF EXISTS `delete_uom`;
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
END;
