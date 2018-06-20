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
DROP PROCEDURE IF EXISTS `modify_equipment`$
CREATE PROCEDURE `modify_equipment`(
  IN _employee_id int(10) unsigned,
  INOUT _equipment_id int(10) unsigned, 
  IN _eg_id int(10) unsigned,
  IN _location_id int(10) unsigned,
  IN _name varchar(255),
  IN _state enum('inactive','up','down','qual','checkout','checkin'),
  IN _contact_employee int(10) unsigned,
  IN _manufacture_date date,
  IN _manufacturer varchar(255),
  IN _manufacturer_phone varchar(50),
  IN _online_date date,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','up','down','qual','checkout','checkin');
  DECLARE _newstate  enum('inactive','up','down','qual','checkout','checkin');
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Equipment name is required. Please give the equipment a name.';
  ELSE
    IF _equipment_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM equipment 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO equipment (
        eg_id,
        name,
        state,
        location_id,
        create_time,
        created_by,
        contact_employee,
        manufacture_date,
        manufacturer,
        manufacturer_phone,
        online_date,
        description,
        comment)
        VALUES (
          _eg_id,
          _name,
          _state,
          _location_id,
          now(),
          _employee_id,
          _contact_employee,
          _manufacture_date,
          _manufacturer,
          _manufacturer_phone,
          _online_date,
          _description,
          _comment
        );
        SET _equipment_id = last_insert_id();
        
        INSERT INTO equip_history (
        event_time,
        equip_id,
        old_state,
        new_state,
        employee,
        comment,
        new_record
        )
        SELECT create_time,
              id,
              NULL,
              state,
              created_by,
              concat('equipment ', name, ' is created'),
              concat('<EQUIPMENT><EG_ID>',eg_id,
                      '</EG_ID><NAME>',name,
                      '</NAME><STATE>', state, 
                      '</STATE><LOCATION_ID>',location_id,
                      '</LOCATION_ID><CONTACT_EMPLOYEE>',contact_employee,
                      '</CONTACT_EMPLOYEE><MANUFACTURE_DATE>', manufacture_date,
                      '</MANUFACTURE_DATE><MANUFACTURER>', manufacturer,
                      '</MANUFACTURER><MANUFACTURER_PHONE>', manufacturer_phone,
                      '</MANUFACTURER_PHONE><ONLINE_DATE>', online_date,
                      '</ONLINE_DATE><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>', comment, 
                      '</COMMENT></EQUIPMENT>')
        FROM equipment
        WHERE id=_equipment_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another equipment. Please change the product name and try again.');
      END IF;
    ELSE
    SELECT NAME INTO ifexist 
      FROM equipment 
      WHERE name=_name
        AND id !=_equipment_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM equipment
      WHERE id=_equipment_id;
        
      UPDATE equipment
         SET eg_id = _eg_id,
             name = _name,
             state = _state,
             location_id = _location_id,
             state_change_time = now(),
             state_changed_by = _employee_id,
             contact_employee = _contact_employee,
             manufacture_date = _manufacture_date,
             manufacturer = _manufacturer,
             manufacturer_phone = _manufacturer_phone,
             online_date = _online_date,
             description = _description,
             comment =_comment
      WHERE id = _equipment_id;
      
      INSERT INTO equip_history (
        event_time,
        equip_id,
        old_state,
        new_state,
        employee,
        comment,
        new_record
          )
          SELECT state_change_time,
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('equipment ', name, ' updated'),
                concat('<EQUIPMENT><EG_ID>',eg_id,
                      '</EG_ID><NAME>',name,
                      '</NAME><STATE>', state, 
                      '</STATE><LOCATION_ID>',location_id,
                      '</LOCATION_ID><CONTACT_EMPLOYEE>',contact_employee,
                      '</CONTACT_EMPLOYEE><CREATE_TIME>',create_time,
                      '</CREATE_TIME><CREATED_BY>', created_by,
                      '</CREATED_BY><MANUFACTURE_DATE>', manufacture_date,
                      '</MANUFACTURE_DATE><MANUFACTURER>', manufacturer,
                      '</MANUFACTURER><MANUFACTURER_PHONE>', manufacturer_phone,
                      '</MANUFACTURER_PHONE><ONLINE_DATE>', online_date,
                      '</ONLINE_DATE><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>', comment, 
                      '</COMMENT></EQUIPMENT>')                
          FROM equipment
          WHERE id=_equipment_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another equipment. Please change the equipment name and try again.');
    END IF;
  END IF; 
 END IF;
END$
