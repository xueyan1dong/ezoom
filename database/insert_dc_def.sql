DROP PROCEDURE IF EXISTS `insert_dc_def`;
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
END; 