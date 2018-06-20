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
DROP PROCEDURE IF EXISTS `add_attribute_to_product`$
CREATE procedure add_attribute_to_product (
  IN _employee_id int(10) unsigned,
  IN _pd_id int(10) unsigned,
  IN _attr_name varchar(255),
  IN _attr_value  varchar(255),
  IN _attr_type enum('in', 'out', 'both'),
  IN _data_type enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime'),
  IN _length int(4) unsigned,
  IN _decimal_length tinyint(1) unsigned,
  IN _key_attr tinyint(1),
  IN _optional tinyint(1),  
  IN _max_value varchar(255),
  IN _min_value varchar(255),
  IN _enum_values varchar(255),
  IN _description text,
  IN _comment text,
  OUT _attr_id int(10) unsigned,  
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _pd_id IS NULL
  THEN
    SET _response='Product information is missing';   
   
  ELSEIF _attr_name IS NULL OR length(_attr_name)<1
  THEN
    SET _response = 'Attribute name is required.';
    
  ELSEIF _attr_type IS NULL
  THEN
    SET _response = 'Attribute type is required.'; 
    
  ELSEIF _data_type IS NULL
  THEN
    SET _response = 'Data type for the attribute is required.';
    
  ELSE
      SELECT name INTO ifexist
        FROM product
      WHERE id=_pd_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The product selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
         IF ifexist IS NULL
         THEN
           SET _response = 'The employee who is inserting this attribute does not exist in database.';
         ELSE
         
          SET ifexist=NULL;
          SELECT attr_name INTO ifexist
            FROM pd_attributes
            WHERE pd_id=_pd_id
              AND attr_name=_attr_name;
              
            IF ifexist IS NULL
            THEN
              SELECT ifnull(MAX(attr_id)+1,1) INTO _attr_id
                FROM pd_attributes
               WHERE pd_id = _pd_id;
               
               
              INSERT INTO pd_attributes
              (
                `pd_id`,
                `attr_id`,
                `attr_name`,
                `attr_value`,
                `attr_type`,
                `data_type`,
                `length`,
                `decimal_length`,
                `key_attr`,
                `optional` ,
                `max_value` ,
                `min_value` ,
                `enum_values` ,
                `description` ,
                `comment`
              )
              VALUES (
                _pd_id,
                _attr_id,
                _attr_name,
                _attr_value,
                _attr_type,
                _data_type,
                _length,
                _decimal_length,
                _key_attr,
                _optional,
                _max_value,
                _min_value,
                _enum_values,
                _description,
                _comment
              );
              
              INSERT INTO attribute_history
              (
                `event_time`,
                `employee_id`,
                `action`,
                `parent_type`,
                `parent_id`,
                `attr_id`,
                `attr_name`,
                `attr_value`,
                `attr_type`,
                `data_type`,
                `length`,
                `decimal_length`,
                `key_attr`,
                `optional`,  
                `max_value`,
                `min_value`,
                `enum_values`,
                `description`,
                `comment`              
              )
              SELECT _eventtime,
                     _employee_id,
                     'insert',
                     'product',
                     pd_id,
                     attr_id,
                     attr_name,
                     attr_value,
                     attr_type,
                     data_type,
                     `length`,
                     decimal_length,
                     key_attr,
                     optional,
                     max_value,
                     min_value,
                     enum_values,
                     description,
                     comment
                FROM pd_attributes
               WHERE pd_id = _pd_id
                 AND attr_id = _attr_id;
            
              UPDATE product
                 SET state_change_time = _eventtime,
                     state_changed_by = _employee_id
               WHERE id=_pd_id;
            ELSE
              SET _response = concat('An attribute with name ', _attr_name , ' for this product already exist in database.');
            END IF;
         END IF;
      END IF; 
 END IF;
END$
