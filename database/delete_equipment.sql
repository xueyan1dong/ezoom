DROP PROCEDURE IF EXISTS `delete_equipment`;
CREATE PROCEDURE `delete_equipment`(
  IN _employee_id int(10) unsigned,
  IN _equipment_id int(10) unsigned
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','up','down','qual','checkout','checkin');
  DECLARE _newstate  enum('inactive','up','down','qual','checkout','checkin');
  
  IF _employee_id IS NOT NULL AND EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN

    IF _equipment_id IS NOT NULL AND EXISTS (SELECT * FROM equipment WHERE id = _equipment_id)
    THEN

        
      INSERT INTO equip_history (
      event_time,
      equip_id,
      old_state,
      new_state,
      employee,
      comment,
      new_record
      )
      SELECT now(),
            id,
            state,
            null,
            _employee_id,
            concat('equipment ', name, ' is deleted'),
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
      
      DELETE FROM equipment WHERE id = _equipment_id;

    END IF; 
  END IF;
END;
