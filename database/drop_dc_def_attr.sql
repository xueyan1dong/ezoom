/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : drop_dc_def_attr.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `drop_dc_def_attr`$
CREATE PROCEDURE `drop_dc_def_attr`(
  IN _def_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _attr_name varchar(255),
  IN _attr_id tinyint(3) unsigned, 
  OUT _response varchar(255)
)
BEGIN
  DECLARE _data_table varchar(60);
  DECLARE _curtime datetime;
  DECLARE _db_name varchar(60);

  
  IF NOT EXISTS (SELECT * FROM employee WHERE id=_recorder) THEN
    SET _response = "Employee who is configuring this data collection does not exist in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_main WHERE id = _def_id) THEN
    SET _response = "The data collection you are working on is not defined in database.";
  ELSEIF NOT EXISTS (SELECT * FROM dc_def_attr WHERE def_id = _def_id AND attr_id = _attr_id) THEN
    SET _response = "The attribute you are droping can not be found in database.";
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
    
    DELETE FROM dc_def_attr
     WHERE def_id = _def_id
       AND attr_id = _attr_id;
         
     IF row_count()> 0 THEN
        SELECT data_table_name INTO _data_table
          FROM dc_def_main
        WHERE id = _def_id; 
        
      -- either data table wasn't created or the table has record in it
      -- then create a new table that has no deleted attribute/column.
      IF _data_table IS NULL OR EXISTS (
          SELECT *
            FROM information_schema.tables
           WHERE table_schema = _db_name
            AND table_name = _data_table
            AND table_rows > 0
      ) THEN
        INSERT INTO attribute_history
        (event_time,
        employee_id,
        action,
        parent_type,
        parent_id,
        attr_id,
        attr_name,
        attr_type
        )
        VALUES( 
          _curtime,
          _recorder,
          'delete',
          'dc_def_main',
          _def_id,
          _attr_id,
          _attr_name,
          'in');
        
        CALL create_data_table(_db_name, _def_id, _data_table);
        
      ELSEIF EXISTS (
        SELECT *
          FROM information_schema.tables
        WHERE table_schema = _db_name
          AND table_name = _data_table
      )
      THEN
        INSERT INTO attribute_history
        (event_time,
        employee_id,
        action,
        parent_type,
        parent_id,
        attr_id,
        attr_name,
        attr_type,
        data_table_name
        )
        VALUES( 
          _curtime,
          _recorder,
          'delete',
          'dc_def_main',
          _def_id,
          _attr_id,
          _attr_name,
          'in',
          _data_table);
          
        CALL alt_dc_column( 'DROP', _data_table,
            _attr_id,
            null,
            null,
            null,
            null);      
      ELSE
        INSERT INTO attribute_history
        (event_time,
        employee_id,
        action,
        parent_type,
        parent_id,
        attr_id,
        attr_name,
        attr_type
        )
        VALUES( 
          _curtime,
          _recorder,
          'delete',
          'dc_def_main',
          _def_id,
          _attr_id,
          _attr_name,
          'in');      
        CALL create_data_table(_db_name, _def_id, _data_table);
      END IF;
      
      IF EXISTS (
        SELECT *
          FROM information_schema.tables
        WHERE table_schema = _db_name
          AND table_name = _data_table
      )
       AND NOT EXISTS (
          SELECT * 
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE table_schema = _db_name
            AND table_name = _data_table 
            AND column_name = concat('attr_', _attr_id))
      THEN
        -- reflect the change with dc_def_main as well
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
                      ' is modified. Attribute with id ', 
                      _attr_id, 
                      ' was droped and there is data table change accordingly.'),
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
      ELSE
        SET _response = "Error encountered when droping the attribute for data table in database. Please contact system administrator immediately.";
      END IF;
    ELSE
      SET _response = "Error encountered when droping the attribute from data collectiond definition table in database. Please contact system administrator imeediately.";
    END IF;
  END IF;
END$