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
DROP PROCEDURE IF EXISTS `modify_dc_def_attr`$
CREATE PROCEDURE `modify_dc_def_attr`(
  IN _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _attr_id tinyint(3) unsigned, 
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
  DECLARE _data_table varchar(60);
  DECLARE _curtime datetime;
  DECLARE _db_name varchar(60);

   
  DECLARE _old_attr_name varchar(255);
  DECLARE _old_data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time','text','mediumtext','longtext','enum');
  DECLARE _old_length tinyint(3) unsigned;
  DECLARE _old_decimal_length tinyint(1) unsigned;
  DECLARE _old_enum_values text; 

  
  IF NOT EXISTS (SELECT * FROM employee WHERE id=_recorder) THEN
    SET _response = "Employee who is configuring this data collection does not exist in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_main WHERE id = _def_id) THEN
    SET _response = "The data collection you are working on is not defined in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_attr WHERE def_id = _def_id AND attr_id = _attr_id) THEN
    SET _response = "The attribute you are modifying can not be found in database.";
  ELSEIF EXISTS (SELECT * FROM dc_def_attr WHERE def_id = _def_id AND attr_id!=_attr_id AND attr_name = _attr_name) THEN
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
     
    SELECT attr_name,
           data_type,
           `length`,
           decimal_length,
           enum_values
      INTO _old_attr_name, _old_data_type, _old_length, _old_decimal_length, _old_enum_values
      FROM dc_def_attr
     WHERE def_id = _def_id
       AND attr_id = _attr_id;
       
    SET _curtime = now();
    
    -- <=> must be used instead of = to compare null as well
    IF _data_type <=> _old_data_type 
      AND _length <=> _old_length 
      AND _decimal_length <=> _old_decimal_length
      AND _enum_values <=>  _old_enum_values
    THEN
      -- no need to update data table in dc_def_main
      
      UPDATE dc_def_attr
         SET attr_name = _attr_name,
             uom_id = _uom_id,
             attr_value = _attr_value,
             max_value=_max_value,
             min_value = _min_value,
             description = _description,
             comment = _comment
       WHERE def_id = _def_id
         AND attr_id = _attr_id;
         
       IF row_count()> 0 THEN
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
            'modify',
            'dc_def_main',
            def_id,
            attr_id,
            attr_name,
            'in',
            data_type,
            `length`,
            decimal_length,
            (select data_table_name FROM dc_def_main WHERE id = _def_id),
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
        
        -- reflect the change with dc_def_main as well
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
                      ' is modified. Attribute with id ', 
                      _attr_id, 
                      ' was modified, but not data table changes.'),
              concat('<DATACOLLECTION><NAME>', name,'</NAME><STATE>',state,
                              '</STATE><CONTACT_EMP>', contact_emp, '</CONTACT_EMP><TARGET>', target,
                              '</TARGET><DATA_TABLE_NAME>', ifnull(data_table_name, ''),
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
    ELSE -- need to either modify the data table in dc_def_main or create another new data table.
    
       UPDATE dc_def_attr
         SET attr_name = _attr_name,
             data_type = _data_type,
             `length` = _length,
             decimal_length = _decimal_length,
             uom_id = _uom_id,
             attr_value = _attr_value,
             max_value=_max_value,
             min_value = _min_value,
             enum_values = _enum_values,
             description = _description,
             comment = _comment
       WHERE def_id = _def_id
         AND attr_id = _attr_id;

      IF row_count()> 0 THEN
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
          'modify',
          'dc_def_main',
          def_id,
          attr_id,
          attr_name,
          'in',
          data_type,
          `length`,
          decimal_length,
          null,
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
        
        SELECT data_table_name INTO _data_table
          FROM dc_def_main
        WHERE id = _def_id;    
        
          -- if there is no data in the data table, modify the column definition
          -- otherwise, create a new table. Need admin to handle data in the old table.
        IF NOT EXISTS (
          SELECT *
            FROM information_schema.tables
           WHERE table_schema = _db_name
            AND table_name = _data_table
        ) THEN  
          CALL create_data_table(_db_name, _def_id, _data_table); 
          
        ELSEIF NOT EXISTS (
          SELECT *
            FROM information_schema.tables
           WHERE table_schema = _db_name
            AND table_name = _data_table
            AND table_rows > 0
        ) THEN

          CALL alt_dc_column( 'MODIFY', _data_table,
            _attr_id,
            _data_type,
            _length,
           _decimal_length,
           _enum_values);
           
        ELSE

          CALL create_data_table(_db_name, _def_id, _data_table);            
        END IF;  

        IF EXISTS (
          SELECT * 
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE table_schema = _db_name
            AND table_name = _data_table 
            AND column_name = concat('attr_', _attr_id))
        THEN

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
                        ' is modified. attribute with id ', 
                        _attr_id, 
                        ' was modified and there is data table change.'),
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
          SET _response = "Error encountered when updating the attribute for data table in database. Please contact system administrator immediately.";
        END IF;
      ELSE
        SET _response = "Error encountered when modifying the attribute in data collection definition table in database. Please contact system administrator immediately.";
      END IF;
      

      
    END IF;
  END IF;
END$