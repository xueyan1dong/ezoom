DROP PROCEDURE IF EXISTS `insert_dc_def_attr`;
CREATE PROCEDURE `insert_dc_def_attr`(
  IN _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _attr_name varchar(255),
  IN _data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum'), 
  IN _length tinyint(3) unsigned,
  IN _decimal_length tinyint(1) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _attr_value text,
  IN _max_value text,
  IN _min_value text,
  IN _enum_values text,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _db_name varchar(60);
  DECLARE _data_table varchar(60);
  DECLARE _table_counter int;
  DECLARE _if_newtable tinyint(1);
  DECLARE _attr_id tinyint(3) unsigned;
  DECLARE _rowcount tinyint(1);
  DECLARE _curtime datetime;

  
  IF NOT EXISTS (SELECT * FROM employee WHERE id=_recorder) THEN
    SET _response = "Employee who is configuring this data collection does not exist in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_main WHERE id = _def_id) THEN
    SET _response = "The data collection you are working on is not defined in database.";
  ELSEIF EXISTS (SELECT * FROM dc_def_attr WHERE def_id = _def_id AND attr_name = _attr_name) THEN
    SET _response = concat('The name ', _attr_name, ' is already used by another attribute in the data collection');
  ELSEIF _data_type IS NULL THEN
    SET _response = "You must select a data type for the attribute.";
  ELSEIF _data_type='decimal' AND _length IS NULL THEN
    SET _response = "You must specify a length when data type is decimal";
  ELSEIF _data_type = 'decimal' AND _decimal_length IS NULL THEN
    SET _response = "You must specify a decimal length when data type is decimal";
  ELSEIF _data_type = 'decimal' AND _length < _decimal_length THEN
    SET _response = "The full length specified for decimal data type must be longer than the decimal length.";
  ELSEIF _data_type in ('varchar', 'char') AND _length IS NULL THEN
    SET _response = "You must specify a length when data type is char or varchar";
  ELSEIF _data_type = 'enum' AND _enum_values IS NULL THEN
    SET _response = "You must specify enumeration values when data type is enum";
  ELSEIF _data_type = 'enum' AND length(_enum_values)=0 THEN
    SET _response = "You must specify enumberation values when data type is enum";
  ELSE
    SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
                              between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
                              and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
                           substring(addtime(timezone, '01:00'), 1, 6),
                           timezone)  
                     FROM company c, employee e
                    WHERE e.id = _recorder AND c.id = e.company_id);
                    
    SELECT c.db_name INTO _db_name
      FROM company c, employee e
     WHERE e.id = _recorder AND c.id = e.company_id;                    
                    
    SET _curtime = now();
    -- insert new column into dc_def_attr table
    SELECT ifnull(max(attr_id),0)+1 INTO _attr_id
    FROM dc_def_attr 
    WHERE def_id = _def_id;
    
    INSERT INTO dc_def_attr
    (def_id,
     attr_id,
     attr_name,
     data_type,
     `length`,
     decimal_length,
     uom_id,
     attr_value,
     max_value,
     min_value,
     enum_values,
     description,
     comment
     )
    VALUES (
      _def_id,
      _attr_id,
      _attr_name,
      _data_type,
      _length,
      _decimal_length,
      _uom_id,
      _attr_value,
      _max_value,
      _min_value,
      _enum_values,
      _description,
      _comment
    );
  
    IF row_count()> 0 THEN
    
      SELECT data_table_name INTO _data_table
        FROM dc_def_main
      WHERE id = _def_id;
      
      -- log the insertion of the new attribute.
      INSERT INTO attribute_history
      (event_time,
       employee_id,
       action,
       parent_type,
       parent_id,
       attr_id,
       attr_name,
       attr_type,
       data_type,
       `length`,
       decimal_length,
       data_table_name,
       key_attr,
       optional,
       uom_id,
       attr_value,
       max_value,
       min_value,
       enum_values,
       description,
       comment
       )
       SELECT 
         _curtime,
         _recorder,
         'insert',
         'dc_def_main',
         def_id,
         attr_id,
         attr_name,
         'in',
         data_type,
         `length`,
         decimal_length,
         _data_table,
         key_attr,
         optional,
         uom_id,
         attr_value,
         max_value,
         min_value,
         enum_values,
         description,
         comment
       FROM dc_def_attr
      WHERE def_id = _def_id
        AND attr_id = _attr_id;
          
      SET @stmt = '';
      
      -- either create new data table or alter existing data table to add new attribute as a column.
      IF _data_table IS NULL OR length(_data_table)=0 THEN

        SET _if_newtable = 1;
        CALL create_data_table(_db_name, _def_id, _data_table); 
        
      ELSE
        -- SET @stmt = CONCAT('ALTER TABLE ', _data_table, ' ADD COLUMN ');

        SET _if_newtable = 0;
        CALL alt_dc_column( 'INSERT', _data_table,
          _attr_id,
          _data_type,
          _length,
         _decimal_length,
         _enum_values);
      END IF;
      
--       SET @stmt = CONCAT(@stmt, 'attr_', _attr_id, ' ');
      
      -- 'decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum'
--       CASE _data_type
--         WHEN 'decimal' THEN 
--           SET @stmt = CONCAT(@stmt, 'decimal(', _length, ',', _decimal_length, ')');
--         WHEN 'signed integer' THEN 
--           SET @stmt=CONCAT(@stmt, 'int', IF(_length IS NULL, '', IF(_length>0, CONCAT('(', _length, ')'), '')));
--         WHEN 'unsigned integer' THEN 
--           SET @stmt=CONCAT(@stmt, 'int', IF(_length IS NULL, '', IF(_length>0, CONCAT('(', _length, ')'), '')), ' unsigned');
--         WHEN 'signed big integer' THEN
--           SET @stmt= CONCAT(@stmt, 'bigint');
--         WHEN 'unsigned big integer' THEN
--           SET @stmt= CONCAT(@stmt, 'bigint unsigned');
--         WHEN 'varchar' THEN
--           SET @stmt= CONCAT(@stmt, 'varchar(', _length, ')');
--         WHEN 'char' THEN
--           SET @stmt=CONCAT(@stmt, 'char(', _length, ')');
--         WHEN 'enum' THEN
--           SET @stmt=CONCAT(@stmt, 'enum(', _enum_values, ')');
--         ELSE 
--           SET @stmt=CONCAT(@stmt, _data_type);
--         
--       END CASE;
      
--       IF _if_newtable > 0 THEN
--         SET @stmt = CONCAT(@stmt, ');');
--       ELSE
--         SET @stmt= CONCAT(@stmt, ';');
--       END IF;
      
--       PREPARE stmt FROM @stmt;
--       EXECUTE stmt;
--       DEALLOCATE PREPARE stmt;
      
      IF EXISTS (
        SELECT * 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE table_schema = _db_name
          AND table_name = _data_table 
          AND column_name = concat('attr_', _attr_id)) 
      THEN

        
        -- update dc_def_main and config_history
        IF _if_newtable > 0 THEN
          UPDATE dc_def_main
             SET data_table_name = _data_table,
                 state_change_time = _curtime,
                 state_changed_by = _recorder
           WHERE id=_def_id;
           
          INSERT INTO config_history 
          (event_time, 
          source_table, 
          source_id, 
          old_state, 
          new_state, 
          employee, 
          comment, 
          new_record)
          SELECT state_change_time,
                'dc_def_main',
                id,
                state,
                state,
                state_changed_by,
                concat('data collection ', 
                        name, 
                        ' is modified. New attribute with id ', 
                        _attr_id, 
                        ' was added and new data table ', 
                        _data_table, 
                        ' was created.'),
                concat('<DATACOLLECTION><NAME>', name,'</NAME><STATE>',state,
                                '</STATE><CONTACT_EMP>', contact_emp, '</CONTACT_EMP><TARGET>', target,
                                '</TARGET><DATA_TABLE_NAME>', data_table_name,
                                '</DATA_TABLE_NAME><CREATE_TIME>',create_time,
                                '</CREATE_TIME><CREATED_BY>',created_by,
                                '</CREATED_BY><STATE_CHANGE_TIME>', state_change_time,
                                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>', state_changed_by,
                                '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                                '</COMMENT></DATACOLLECTION>')
          FROM dc_def_main
          WHERE id=_def_id;     
        ELSE
          UPDATE dc_def_main
             SET state_change_time = _curtime,
                 state_changed_by = _recorder
           WHERE id=_def_id;
           
          INSERT INTO config_history 
          (event_time, 
          source_table, 
          source_id, 
          old_state, 
          new_state, 
          employee, 
          comment, 
          new_record)
          SELECT state_change_time,
                'dc_def_main',
                id,
                state,
                state,
                state_changed_by,
                concat('data collection ', 
                        name, 
                        ' is modified. New attribute with id ', 
                        _attr_id, 
                        ' was added and new column was added to data table.'),
                concat('<DATACOLLECTION><NAME>', name,'</NAME><STATE>',state,
                                '</STATE><CONTACT_EMP>', contact_emp, '</CONTACT_EMP><TARGET>', target,
                                '</TARGET><DATA_TABLE_NAME>',
                                data_table_name,
                                '</DATA_TABLE_NAME><CREATE_TIME>',create_time,
                                '</CREATE_TIME><CREATED_BY>',created_by,
                                '</CREATED_BY><STATE_CHANGE_TIME>', state_change_time,
                                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>', state_changed_by,
                                '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                                '</COMMENT></DATACOLLECTION>')
          FROM dc_def_main
          WHERE id=_def_id;          
        END IF;
        


      ELSE
        SET _response = "Error encountered when updating data table with new attribute. Please report the error system administrator as soon as possible.";
      END IF;
    ELSE
      SET _response="Error when adding attribute to data collection definition in database.";
    END IF;
  END IF;
END; 