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
DROP PROCEDURE IF EXISTS `create_data_table`$
CREATE PROCEDURE `create_data_table`(
  IN _db_name varchar(60),
  IN _def_id int(10) unsigned,
  OUT _data_table varchar(60)
)
BEGIN
  DECLARE _table_counter int;
  DECLARE _attr_id tinyint(3) unsigned;
  DECLARE _data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum');
  DECLARE _length tinyint(3) unsigned;
  DECLARE _decimal_length tinyint(1) unsigned; 
  DECLARE _enum_values text;
  
  DECLARE done INT DEFAULT 0;
  DECLARE cur1 CURSOR FOR 
      SELECT attr_id, data_type, `length`, decimal_length, enum_values 
        FROM dc_def_attr
       WHERE def_id = _def_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  
  SET _table_counter = 1;
  SET _data_table = CONCAT('dc_',_def_id, '_', _table_counter);
  WHILE EXISTS (
    SELECT *
      FROM information_schema.tables
     WHERE table_schema = _db_name
       AND table_name = _data_table)
  DO
    SET _table_counter = _table_counter + 1;
    SET _data_table = CONCAT('dc_',_def_id, '_', _table_counter);
  END WHILE;
    
  SET @stmt = CONCAT('CREATE TABLE ', _data_table, ' ( data_id int(10) unsigned not null ); ');
  
  PREPARE stmt FROM @stmt;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  
  IF EXISTS (SELECT *
        FROM information_schema.tables 
        WHERE table_schema = _db_name
          AND table_name = _data_table)
  THEN
  
    OPEN cur1;
    FETCH cur1 INTO _attr_id, _data_type, _length, _decimal_length, _enum_values;
    
    WHILE done <1 DO
      CALL alt_dc_column( 'INSERT', _data_table,
      _attr_id,
      _data_type,
      _length,
      _decimal_length,
      _enum_values);

      FETCH cur1 INTO _attr_id, _data_type, _length, _decimal_length, _enum_values;
    END WHILE;
    CLOSE cur1;
    
  END IF;

END$