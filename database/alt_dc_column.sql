/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : alt_dc_column.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `alt_dc_column`$
CREATE PROCEDURE `alt_dc_column`(
  IN _action enum('INSERT', 'MODIFY', 'DROP'),
  IN _data_table varchar(60),
  IN _attr_id tinyint(3) unsigned,
  IN _data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum'), 
  IN _length tinyint(3) unsigned,
  IN _decimal_length tinyint(1) unsigned,
  IN _enum_values text
)
BEGIN
  SET @stmt = CONCAT('ALTER TABLE ', _data_table, ' ');
  
  IF _action IN ('MODIFY', 'DROP') THEN
    SET @stmt = CONCAT(@stmt, 'DROP COLUMN attr_', _attr_id, ';');
    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
  
  -- modify a column is down through first droping and then adding, so that to avoid data conversion problem
  -- and make sure the new column either is created correctly or simply not there.
  IF _action IN( 'INSERT', 'MODIFY') THEN
    SET @stmt = CONCAT('ALTER TABLE ', _data_table, ' ADD COLUMN attr_', _attr_id, ' ');

    CASE _data_type
      WHEN 'decimal' THEN 
        SET @stmt = CONCAT(@stmt, 'decimal(', _length, ',', _decimal_length, ')');
      WHEN 'signed integer' THEN 
        SET @stmt=CONCAT(@stmt, 'int', IF(_length IS NULL, '', IF(_length>0, CONCAT('(', _length, ')'), '')));
      WHEN 'unsigned integer' THEN 
        SET @stmt=CONCAT(@stmt, 'int', IF(_length IS NULL, '', IF(_length>0, CONCAT('(', _length, ')'), '')), ' unsigned');
      WHEN 'signed big integer' THEN
        SET @stmt= CONCAT(@stmt, 'bigint');
      WHEN 'unsigned big integer' THEN
        SET @stmt= CONCAT(@stmt, 'bigint unsigned');
      WHEN 'varchar' THEN
        SET @stmt= CONCAT(@stmt, 'varchar(', _length, ')');
      WHEN 'char' THEN
        SET @stmt=CONCAT(@stmt, 'char(', _length, ')');
      WHEN 'enum' THEN
        SET @stmt=CONCAT(@stmt, 'enum(', _enum_values, ')');
      ELSE 
        SET @stmt=CONCAT(@stmt, _data_type);
      
    END CASE;
    
    SET @stmt= CONCAT(@stmt, ';');

    PREPARE stmt FROM @stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
  -- SELECT substring(@stmt, 1, 300);

END$