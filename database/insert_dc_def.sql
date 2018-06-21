/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : insert_dc_def.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `insert_dc_def`$
CREATE PROCEDURE `insert_dc_def`(
  INOUT _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _name varchar(255),
  IN _contact_emp int(10) unsigned,
  IN _target enum('product', 'equipment','supply'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  SET @stmt = '';
  SET @stmt = CONCAT('CREATE TABLE dc_', _name, ' (data_id bigint unsigned NOT NULL)');
  PREPARE stmt FROM @stmt;
  EXECUTE stmt;
END$