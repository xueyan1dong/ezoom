DROP PROCEDURE IF EXISTS `associate_product_process`;
CREATE PROCEDURE `associate_product_process`(
  IN _product_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _priority tinyint(2) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  IF _product_id IS NULL
  THEN
    SET _response = 'No product was selected. Please select a product.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'No process was selected. Please select a process.';
  ELSE
      SELECT name INTO ifexist 
      FROM product 
      WHERE id=_product_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The product you selected does not exist in database.';
      ELSE
        SET ifexist = NULL;
        SELECT name INTO ifexist
        FROM process
        WHERE id=_process_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The process you selected does not exist in database.';
        ELSE
          SET ifexist = NULL;
          SELECT 'RECORD EXIST' INTO ifexist
           FROM product_process
          WHERE product_id = _product_id
            AND process_id = _process_id;
          
          IF ifexist IS NULL
          THEN
            INSERT INTO product_process (
              product_id,
              process_id,
              priority,
              recorder,
              comment)
            VALUES (
              _product_id,
              _process_id,
              _priority,
              _recorder,
              _comment
            );
          ELSE
            UPDATE product_process
               SET priority = _priority,
                   recorder = _recorder,
                   comment = _comment
             WHERE product_id = _product_id
               AND process_id = _process_id
               ;
          END IF;
        END IF;
      END IF;
  END IF;
END;