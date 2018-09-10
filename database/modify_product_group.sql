/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_product_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2018
*    Platform Dependencies  : MySql
*    Description            : Insert or edit product_group records
*    example	            : 
*    Log                    :
*    09/06/2018: Xueyan Dong: First Created. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_product_group` $
CREATE PROCEDURE `modify_product_group`(
  INOUT _product_group_id int(11) unsigned,
  IN _created_by int(11)unsigned,
  IN _name varchar(255),
  IN if_active tinyint(1) unsigned,
  IN _description text,  
  IN _default_location_id int(11) unsigned,
  IN _prefix varchar(20),
  IN _surfix varchar(20),
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _newstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Name of Product Group is required. Please give the product group a name.';
  ELSE
    IF _product_group_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM product_group
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO product_group (
		name,
        created_by,
        created_time,
        if_active,
        description,
        default_location_id,
        prefix,
        surfix,
        comment
        )
        VALUES (
          _name,
          _created_by,
          now(),
          _if_active,
          _description,
          _default_location_id,
		  _prefix,
          _surfix,
          _comment
        );
        SET _product_group_id = last_insert_id();
        -- not finished
        INSERT INTO config_history (
          event_time,
          source_table,
          source_id,
          old_state,
          new_state,
          employee,
          comment,
          new_record
        )
        SELECT create_time,
              'product_group',
              id,
              NULL,
              IF(if_active = 1, 'production', 'inactive'),
              created_by,
              concat('product group', name, ' is created'),
              concat('<PRODUCT_GTOUP><ID>',id, '</ID><NAME>', name,'</NAME><IF_ACTIVE>',if_active,
                '</IF_ACTIVE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><DEFAULT_LOCATION_ID>', uomid,
                '</DEFAULT_LOCATION_ID><PREFIX>',IFNULL(prefix, ''), 
                '</PREFIX><SURFIX>', IFNULL(surfix, ''),
                '</SURFIX><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PRODUCT_GROUP>')
        FROM product_group
        WHERE id=_product_group_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another product group. Please change the product group name and try again.');
      END IF;
    ELSE
    SELECT NAME INTO ifexist 
      FROM product 
      WHERE name=_name
        AND id !=_product_group_id;
        
    IF ifexist is NULL
    THEN
      SELECT IF(if_active = 1, 'production', 'inactive')
        INTO _oldstate
        FROM product_group
      WHERE id=_product_group_id;
        
      UPDATE product_group
        SET name = _name,
            created_by= _created_by,
            create_time = now(),
            if_active = _if_active,
            description = _description,
            default_location_id = _default_location_id,
		    prefix = _prefix,
            surfix = _surfix,
            comment = _comment
      WHERE id = _product_group_id;
      
      INSERT INTO config_history (
            event_time,
            source_table,
            source_id,
            old_state,
            new_state,
            employee,
            comment,
            new_record
          )
          SELECT state_change_time,
                'product_group',
                id,
                _oldstate,
				IF(if_active = 1, 'production', 'inactive'),
				created_by,
				concat('product group', name, ' is updated'),
				concat('<PRODUCT_GTOUP><ID>',id, '</ID><NAME>', name,'</NAME><IF_ACTIVE>',if_active,
                '</IF_ACTIVE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><DEFAULT_LOCATION_ID>', uomid,
                '</DEFAULT_LOCATION_ID><PREFIX>',IFNULL(prefix, ''), 
                '</PREFIX><SURFIX>', IFNULL(surfix, ''),
                '</SURFIX><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PRODUCT_GROUP>')                
          FROM product_group
          WHERE id=_product_group_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another product group. Please change the product group name and try again.');
    END IF;
  END IF; 
 END IF;
END $
