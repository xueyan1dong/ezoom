/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : load_procedures.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
delimiter $
-- procedure modify_uom
DROP PROCEDURE IF EXISTS `modify_uom`$
CREATE PROCEDURE `modify_uom`(
  INOUT _uom_id smallint(3) unsigned, 
  IN _name varchar(20),
  IN _alias varchar(20),
  IN _description varchar(255),
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='UoM name is required. Please give the UoM a name.';
  ELSE
    IF _uom_id IS NULL
    THEN
      
      IF EXISTS (SELECT * FROM uom WHERE name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another unit of measure. Please change the UoM name and try again.');
      ELSE
        INSERT INTO uom (name,alias, description)
        VALUES (_name, _alias, _description);
        SET _uom_id = last_insert_id();
        SET _response = '';
      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM uom WHERE alias=_alias AND id != _uom_id)
      THEN
        SET _response= concat('The alias ', _alias,' is already used by another UoM. Please change it and try again.');
      ELSE
          
        UPDATE uom
          SET alias = _alias,
              description = _description
        WHERE id = _uom_id;
      END IF;
    END IF; 
  END IF;
END$

-- procedure delete_uom
DROP PROCEDURE IF EXISTS `delete_uom`$
CREATE PROCEDURE `delete_uom`(
  IN _uom_id smallint(3) unsigned
)
BEGIN


  
  IF _uom_id IS NOT NULL AND EXISTS (SELECT * FROM uom WHERE id = _uom_id)
  THEN
    START TRANSACTION;

      
      DELETE FROM uom_conversion
       WHERE from_id = _uom_id
          OR to_id = _uom_id;
      
      DELETE FROM uom
      WHERE id = _uom_id;
     
    COMMIT;    
  END IF;
END$

-- procedure insert_uom_conversion
DROP PROCEDURE IF EXISTS `insert_uom_conversion`$
CREATE procedure insert_uom_conversion (
  IN _from_id smallint(3) unsigned,
  IN _to_id smallint(3) unsigned,
  IN _method enum('ratio', 'reduction', 'addtion'),
  IN _constant decimal(16,4) unsigned,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN


  
  IF _from_id IS NULL
  THEN
    SET _response='From UoM is required. Please select a From UoM.';
    
  ELSEIF _to_id IS NULL
  THEN
    SET _response = 'To UoM is required. Please select a To UoM.';    
  ELSEIF _method IS NULL
  THEN
    SET _response = 'Converting Method is required. Please select a method.';
  ELSEIF _constant IS NULL 
  THEN
    SET _response = 'Conversion costant is required. Please provide a constant.';
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_from_id)
  THEN
    SET _response = 'The From Uom does not exist in database.';    
    
  ELSEIF NOT EXISTS (SELECT * FROM uom WHERE id=_to_id)
  THEN
    SET _response = 'The To Uom does not exist in database.';  
  ELSEIF EXISTS (SELECT * FROM uom_conversion WHERE from_id = _from_id AND to_id=_to_id)
  THEN
    SET _response = 'The conversion between the selected UoMs already exists in database.';     
  ELSE

  INSERT INTO uom_conversion
  (from_id, to_id, method,constant, comment)
  VALUES (_from_id, _to_id, _method, _constant, _comment);
 END IF;
END$

-- procedure insert_inventory
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : insert_inventory.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*	 8/16/2018: Peiyu Ge: added location_id.
*	 12/13/20: Peiyu Ge: deleted the constraint "can not be zero" for _original_quantity. Zero is a valid input now.				
*/

DROP PROCEDURE IF EXISTS insert_inventory$
CREATE PROCEDURE insert_inventory (
  IN _recorded_by int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _pd_or_mt_id int(10) unsigned,
  IN _supplier_id int(10) unsigned, -- currently not used, use 0
  IN _lot_id varchar(20),
  IN _serial_no varchar(20),
  IN _out_order_id varchar(20),
  IN _in_order_id varchar(20),
  IN _original_quantity decimal(16,4) unsigned,
  IN _actual_quantity decimal(16,4) unsigned,
  IN _location_id int(11) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _manufacture_date datetime,
  IN _expiration_date datetime,
  IN _arrive_date datetime,

  IN _contact_employee int(10) unsigned,
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE ifexist varchar(255);
  DECLARE wording varchar(20);
  
  IF _source_type IS NULL OR length(_source_type )< 1
  THEN
    SET _response='Source type is required. Please select an source type.';
  ELSEIF  _pd_or_mt_id IS NULL
  THEN 
    SET _response='No resource selected. Please select a resource.';
  ELSEIF  _supplier_id IS NULL
  THEN 
    SET _response='Supplier is required. Please select a supplier.';
  ELSEIF  _lot_id IS NULL
  THEN 
    SET _response='Supplier lot number is required. Please fill in the lot number.';
  ELSEIF  _original_quantity IS NULL -- OR _original_quantity = 0
  THEN 
    SET _response='Original Quanity is required.'; -- and can not be zero. Please fill in original quantity.';
  ELSEIF  _actual_quantity IS NULL
  THEN 
    SET _response='Actual Quanity is required. Please fill in actual quantity.';   
  ELSEIF  _uom_id IS NULL
  THEN 
    SET _response='Unit of Measure is required. Please select a unit of measure.';   
  ELSEIF  _manufacture_date IS NULL
  THEN 
    SET _response='Manufacture Date is required. Please fill in a manufacture date.'; 
  ELSEIF  _arrive_date IS NULL
  THEN 
    SET _response='Arrive Date is required. Please fill in an arrive date.';
  ELSEIF  _recorded_by IS NULL
  THEN 
    SET _response='Recorder information is missing.';   
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_recorded_by)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';  
  ELSEIF _contact_employee IS NOT NULL AND NOT EXISTS (SELECT * FROM employee WHERE id=_contact_employee)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';    
  ELSE
  

      
      IF _source_type = 'product' THEN
        IF NOT EXISTS (SELECT * FROM product WHERE id=_pd_or_mt_id)
        THEN 
          SET _response = 'The product you selected does not exist in database. Please first record the product information.';
        END IF;
        
      ELSEIF _source_type = 'material' THEN
        IF NOT EXISTS (SELECT * FROM material WHERE id=_pd_or_mt_id)
        THEN
          SET _response = 'The material you selected is not in our material list. Please first record the material information.';
        ELSE
          SELECT supplier_id into _supplier_id
            FROM material_supplier
           WHERE material_id=_pd_or_mt_id
           ORDER BY preference 
           LIMIT 1;
        END IF;
      ELSE
        SET _response = 'The source type you selected is invalid. Please select a valid source type.';
      END IF;
    
      IF _serial_no IS NULL AND EXISTS (SELECT * 
                                          FROM inventory 
                                         WHERE source_type = _source_type 
                                           AND pd_or_mt_id = _pd_or_mt_id
                                           AND supplier_id = _supplier_id
                                           AND lot_id = _lot_id
                                          )
      THEN
        SET _response = concat('The lot ', _lot_id , ' already exists in inventory.');
      ELSEIF EXISTS (SELECT * FROM inventory
                      WHERE source_type = _source_type 
                        AND pd_or_mt_id = _pd_or_mt_id
                        AND supplier_id = _supplier_id
                        AND lot_id = _lot_id
                        AND serial_no = _serial_no
                     )
      THEN
        SET _response = concat('The lot ', _lot_id , ' with serial number ', _serial_no, ' already exists in inventory.');
      END IF;
      
      IF _response IS NULL THEN

        INSERT INTO `inventory` (
          source_type,
          pd_or_mt_id,
          supplier_id,
          lot_id,
          serial_no,
          out_order_id,
          in_order_id,
          original_quantity,
          actual_quantity,
          uom_id,
          manufacture_date,
          expiration_date,
          arrive_date,
          recorded_by,
          contact_employee,
          comment,
		  location_id
        )
        values (
              _source_type,
              _pd_or_mt_id,
              _supplier_id,
              _lot_id,
              _serial_no,
              _out_order_id,
              _in_order_id,
              _original_quantity,
              _actual_quantity,
              _uom_id,
              _manufacture_date,
              _expiration_date,
              _arrive_date,
              _recorded_by,
              _contact_employee,
              _comment,
			  _location_id
            );
        SET _inventory_id = last_insert_id();

      END IF;
  END IF;
END$

-- procedure modify_material_group
DROP PROCEDURE IF EXISTS `modify_material_group`$
CREATE procedure modify_material_group (
  INOUT _group_id int(10) unsigned,
  IN _name varchar(255),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Name of the material group is required. Please give the material group a name.';
    
  ELSEIF _group_id IS NULL
  THEN

    IF EXISTS (SELECT * FROM material_group WHERE name=_name)
    THEN
      SET _response= concat('The material group ' , _name , ' already exists in database.');
    ELSE
    

      INSERT INTO material_group (
        name,
        description,
        comment
      )
      VALUES (
        _name,
        _description,
        _comment
      );
      SET _group_id = last_insert_id();
      SET _response = '';
    END IF;
 ELSE
    IF EXISTS (SELECT * FROM material_group WHERE id!=_group_id AND name=_name)
    THEN
      SET _response= concat('The name ' , _name , ' is already used by another material group in database.');
    ELSE
      UPDATE material_group
         SET name = _name,
             description = _description,
             comment = _comment
       WHERE id = _group_id;
    END IF;
 END IF;
END$
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_material.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Insert or update material (item/part in UI) into the material table
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    6/29/2018: Xueyan Dong: added code to also record _alias into the alias column of material table.				
*	 8/26/2018: Peiyu Ge: added a flag if_persistent to indicate if an item/part is intermediate 
*/
DELIMITER $

DROP PROCEDURE IF EXISTS `modify_material`$
CREATE procedure modify_material (
  INOUT _material_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  IN _name varchar(255),
  IN _alias varchar(255), -- currently take in supplier_id information. x.d. Feb 7, 2011
  IN _mg_id int(10) unsigned,
  IN _material_form enum('solid','liquid','gas'),
  IN _status enum('inactive','production','frozen'),
  IN _if_persistent boolean,
  IN _alert_quantity decimal(16,4) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Material name is required. Please give the material a name.';
    
  ELSEIF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.';  
  ELSEIF _material_id IS NULL
  THEN

    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id;
    
    IF ifexist IS NULL
    THEN
      INSERT INTO material (
        name,
        mg_id,
        alias,
        uom_id,
        alert_quantity,
        lot_size,
        material_form,
        status,
        enlist_time,
        enlisted_by,
        description,
        comment,
		if_persistent
      )
      VALUES (
        _name,
        _mg_id,
        _alias,
        _uom_id,
        _alert_quantity,
        _lot_size,
        _material_form,
        _status,
        now(),
        _employee_id,
        _description,
        _comment,
		_if_persistent
      );
      SET _material_id = last_insert_id();

    ELSE
      SET _response= concat('The material ' , _name , ' already exists in table.');
    END IF;
 ELSE
    SELECT name INTO ifexist 
    FROM material 
    WHERE name=_name
      AND mg_id = _mg_id
      AND id != _material_id;
      
    IF ifexist IS NULL
    THEN
      UPDATE material
         SET name = _name,
             mg_id = _mg_id,
             alias = _alias,
             uom_id = _uom_id,
             alert_quantity = _alert_quantity,
             lot_size = _lot_size,
             material_form =_material_form,
             status = _status,
             update_time = now(),
             updated_by = _employee_id,
             description = _description,
             comment = _comment,
			 if_persistent = _if_persistent
       WHERE id = _material_id;
    ELSE
      SET _response = concat('The material name ' , _name , ' is already used by another material in table.');
    END IF;
 END IF;
 IF _response IS NULL AND _material_id IS NOT NULL AND _alias IS NOT NULL
 THEN
  IF NOT EXISTS (SELECT * FROM material_supplier WHERE material_id = _material_id AND supplier_id = _alias)
  THEN
    INSERT INTO material_supplier
    (material_id
    ,supplier_id
    )
    VALUES(_material_id, _alias);
  END IF;
 END IF;
END$


-- procedure modify_order_general
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Modify certain order general information
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    09/25/2018: Xueyan Dong: added check for duplicate PO number					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_order_general`$
CREATE PROCEDURE `modify_order_general`(
  IN _order_id int(10) unsigned,
  IN _ponumber varchar(40),
  IN _priority tinyint(2) unsigned,
  IN _state varchar(10), 
  IN _state_date datetime,
  IN _net_total decimal(16,2) unsigned,
  IN _tax_percentage tinyint(2) unsigned,
  IN _tax_amount decimal(14,2) unsigned,
  IN _other_fees decimal(16,2) unsigned,
  IN _total_price decimal(16,2) unsigned,
  IN _expected_deliver_date datetime,
  IN _internal_contact int(10) unsigned,
  IN _external_contact varchar(255),
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _old_state varchar(10);
  
  IF  _internal_contact is NULL OR length(_internal_contact) < 1
  THEN 
    SET _response='The internal contact is required. Please fill the contact info.';
  ELSEIF EXISTS (SELECT o2.id
                   FROM order_general o1
                   JOIN order_general o2
                     ON IFNULL(o2.client_id,0) = IFNULL(o1.client_id,0)
                        AND o2.order_type = o1.order_type
                        AND o2.id != o1.id
                        AND IFNULL(o2.ponumber,'') = IFNULL(_ponumber,'')
				  WHERE o1.id = _order_id)
  THEN
	SET _response = 'The po number is already used by another order of the same order type and client';
  ELSE
    SELECT state INTO _old_state
      FROM order_general
     WHERE id = _order_id;
     
    IF _state IS NULL OR length(_state) < 1
    THEN
      SET _state = _old_state;
    ELSEIF _state=_old_state 
           AND _state_date IS NOT NULL 
           AND length(_state_date) > 0
           AND NOT EXISTS (SELECT * 
                         FROM order_state_history 
                        WHERE order_id = _order_id
                          AND state = _old_state
                          AND state_date = _state_date)
           OR _state != _old_state
    THEN
      IF _state IS NULL OR _state NOT IN ('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid')
      THEN
        SET _response='The value for state is not valid. Please select one state from following: quoted, POed, scheduled, produced, shipped, delivered, invoiced, paid.';
      ELSEIF _state_date IS NULL or length(_state_date) < 1
      THEN
        SET _response = 'The date when the state happened is required. Please fill in the state date.';
      ELSE
        INSERT INTO order_state_history
            (order_id,
            state,
            state_date,
            recorder_id,
            comment
            )
            VALUES
            (
              _order_id,
              _state,
              _state_date,
              _recorder_id,
              _comment
            );
      END IF;
    END IF;
    UPDATE `order_general`
       SET ponumber = _ponumber,
           priority = _priority,
           state = _state,
           net_total = _net_total,
           tax_percentage = _tax_percentage,
           tax_amount = _tax_amount,
           other_fees = _other_fees,
           total_price = _total_price,
           expected_deliver_date = _expected_deliver_date,
           internal_contact = _internal_contact,
           external_contact = _external_contact,
           comment = _comment
     WHERE id = _order_id;
     
  END IF;
END$

/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_order_detail.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Insert new order detail/product record or modify existing order detail record. Note that when modifying
*                             Order Id, Source Type, Source Id, Line Number are acting as anchor for finding the record
*    example	            : 
CALL modify_order_detail ('insert',  7, 'product', 5, NULL, 30, 150, 0, 0, 0, NULL, NULL, NULL, 2, '', 1, @response);
select @response
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 		
*    09/25/2018: Xueyan Dong: removed input parameter _order_type and added input parameters: _source_type, _line_num, and _uomid
*                             added logic for checking against unique key
*    10/01/2018: Junlu Luo: fixed bugs caused by last change
*    10/16/2018: Xueyan Dong: added code to auto assign _line_num, if it is inputed as null
*    11/01/2018: Xueyan Dong: fixed a bug that would block update
*/
DELIMITER $

DROP PROCEDURE IF EXISTS modify_order_detail$
CREATE PROCEDURE modify_order_detail (
  IN _operation enum('insert', 'update'),
  IN _order_id int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _source_id int(10) unsigned,
  IN _line_num smallint(5) unsigned,  -- line number of the detail line. If not supplied (null), assign the next line number of the order
  IN _quantity_requested decimal(16,4) unsigned,
  IN _unit_price decimal(10,2) unsigned,
  IN _quantity_made decimal(16,4) unsigned,
  IN _quantity_in_process decimal(16,4) unsigned,
  IN _quantity_shipped decimal(16,4) unsigned,
  IN _output_date datetime,
  IN _expected_deliver_date datetime,  
  IN _actual_deliver_date datetime,
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  IN _uomid smallint(3) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _origin_uomid smallint(3) unsigned;
  
  IF _operation IS NULL OR length(_operation) < 1
  THEN
    SET _response = 'No operation is defined. Please define an operation.';
  ELSEIF _order_id IS NULL
  THEN
    SET _response = 'You must select an order for adding details. Please select an order.';
  ELSEIF _source_type IS NULL OR length(_source_type) <1
  THEN
    SET _response='Source type is required. Please select an order type.';
  ELSEIF  _source_id is NULL
  THEN 
    SET _response='No item selected for ordering. Please select an item.';
  ELSEIF  _quantity_requested is NULL OR _quantity_requested <= 0
  THEN 
    SET _response='Quantity requested is required. Please fill the quantity requested.';
  ELSE IF _operation = 'insert' AND EXISTS (SELECT line_num 
				   FROM order_detail 
				  WHERE order_id = _order_id
                    AND source_type = _source_type
                    AND source_id = _source_id
                    AND line_num = _line_num)
  THEN
	SET _response = CONCAT('The same detail line ', _line_num , ' has been recorded'); 
  ELSE 
   -- if _line_num is entered as null, assign a line number from highest line number + 1
    IF _line_num IS NULL
	THEN 
		SELECT IFNULL(MAX(line_num),0) + 1
		INTO _line_num
		FROM order_detail
	   WHERE order_id = _order_id;
	END IF;
    -- pull out original uomid
    
    IF _source_type = 'product'
    THEN
      SELECT uomid INTO _origin_uomid
        FROM product
       WHERE id = _source_id;
    ELSE
      SELECT uom_id INTO _origin_uomid
        FROM material
       WHERE id = _source_id;
    END IF;
    
    IF _origin_uomid IS NULL
    THEN
      SET _response = 'THE product or material selected does not exist in database.';
    ELSE

      IF _operation = 'insert'
      THEN
 
        INSERT INTO `order_detail` (
          order_id,
          source_type,
          source_id,
          line_num,
          quantity_requested,
          unit_price,
          quantity_made,
          quantity_in_process,
          quantity_shipped,
          uomid,
          output_date,
          expected_deliver_date,
          actual_deliver_date,
          recorder_id,
          record_time,
          comment   
    )
        values (
          _order_id,
          _source_type,
          _source_id,
          _line_num,
	      _quantity_requested, -- IFNULL(_quantity_requested, (_quantity_requested, _uomid, _origin_uomid)),
          _unit_price,
          _quantity_made, -- IFNULL(_quantity_made, (_quantity_made, _uomid, _origin_uomid)),
          _quantity_in_process, -- IFNULL(_quantity_in_process, (_quantity_in_process, _uomid, _origin_uomid)),
          _quantity_shipped, -- ifNULL(_quantity_shipped, (_quantity_shipped, _uomid, _origin_uomid)),
          _uomid,
          _output_date,
          _expected_deliver_date,
          _actual_deliver_date,
          _recorder_id,
          now(),
          _comment
            );
      ELSEIF _operation= 'update'
      THEN
        UPDATE order_detail
          SET quantity_requested = _quantity_requested,
              unit_price = _unit_price,
              quantity_made = _quantity_made,
              quantity_in_process = _quantity_in_process,
              quantity_shipped = _quantity_shipped,
              uomid = _uomid,
              output_date = _output_date,
              expected_deliver_date = _expected_deliver_date,
              actual_deliver_date = _actual_deliver_date,
              recorder_id = _recorder_id,
              record_time = now(),
              comment = _comment
        WHERE order_id = _order_id
          AND source_type = _source_type
          AND source_id = _source_id
          AND line_num = _line_num;
      END IF;
	  END IF;
     END IF;
  END IF;
END $

-- procedure modify_equipment
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

-- procedure delete_equipment
DROP PROCEDURE IF EXISTS `delete_equipment`$
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
END$

-- procedure modify_employee
DROP PROCEDURE IF EXISTS `modify_employee`$
CREATE PROCEDURE `modify_employee`(
  INOUT _id int(10) unsigned,
  IN _username varchar(20),
  IN _password varchar(20),
  IN _status enum('active','inactive','removed'),
  IN _or_id int(10) unsigned,
  IN _eg_id int(10) unsigned,
  IN _firstname varchar(20),
  IN _lastname varchar(20),
  IN _middlename varchar(20),
  IN _email varchar(45),
  IN _phone varchar(45),
  IN _role_id int(10) unsigned,
  IN _report_to int(10) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  IF  _id IS NULL AND (_username is NULL OR length(_username) < 1)
  THEN 
    SET _response='User name is required. Please fill the username.';
  ELSEIF _id IS NULL AND ( _password is NULL OR length(_password) < 1)
  THEN 
    SET _response='Password is required. Please fill the password.';
  ELSEIF  _status is NULL OR length(_status) < 1
  THEN 
    SET _response='Status is required. Please fill the Status.';
  ELSEIF  _or_id is NULL OR length(_or_id) < 1
  THEN 
    SET _response='Organization is required. Please fill the Organization.';
  ELSEIF  _firstname is NULL OR length(_firstname) < 1
  THEN 
    SET _response='First Name is required. Please fill the first name.';
  ELSEIF  _lastname is NULL OR length(_lastname) < 1
  THEN 
    SET _response='Last name is required. Please fill the last name.';
  ELSEIF  _role_id IS NULL OR NOT EXISTS (SELECT * FROM system_roles WHERE id=_role_id)
  THEN 
    SET _response='Role is required. Please select a role.';   
  ELSEIF _id is NULL 
  THEN
    INSERT INTO `employee` (
         id, company_id, username, password,
         status, or_id, eg_id, firstname,
         lastname, middlename, email,
         phone, report_to, comment)
    values (
          _id, 1, _username, _password,
         _status, _or_id, _eg_id, _firstname,
         _lastname, _middlename, _email,
         _phone, _report_to, _comment
         );
    SET _id = last_insert_id();
    INSERT INTO users_in_roles (
      userId,
      roleId
    )
    values (_id, _role_id);
    
  ELSE
    UPDATE `employee` 
      SET 
      status = _status, 
      or_id = _or_id, 
      eg_id = _eg_id, 
      firstname = _firstname,
      lastname = _lastname, 
      middlename = _middlename, 
      email = _email,
      phone = _phone, 
      report_to = _report_to, 
      comment = _comment
    WHERE id = _id;
    
    UPDATE users_in_roles 
       SET roleId = _role_id
     WHERE userId = _id;
  END IF;
END$

-- procedure modify_product
DROP PROCEDURE IF EXISTS `modify_product`$
CREATE PROCEDURE `modify_product`(
  INOUT _product_id int(10) unsigned,
  IN _created_by int(10)unsigned,
  IN _version int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),  
  IN _pg_id int(10) unsigned,
  IN _name varchar(255),
  IN _lot_size decimal(16,4) unsigned,
  IN _uomid smallint(3) unsigned,
  IN _lifespan int(10) unsigned,
  IN _description text,
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
    SET _response='Product name is required. Please give the product a name.';
  ELSE
    IF _product_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM product 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO product (
          pg_id, 
          name, 
          `version`, 
          state,
          lot_size,
          uomid,
          lifespan,
          create_time, 
          created_by, 
          state_change_time, 
          state_changed_by, 
          description, 
          comment)
        VALUES (
          _pg_id,
          _name,
          _version,
          _state,
          _lot_size,
          _uomid,
          _lifespan,
          now(),
          _created_by,
          null,
          null,
          _description,
          _comment
        );
        SET _product_id = last_insert_id();
        
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
              'product',
              id,
              NULL,
              state,
              created_by,
              concat('product ', name, ' is created'),
              concat('<PRODUCT><PG_ID>',pg_id, '</PG_ID><NAME>', name,'</NAME><STATE>',state,
                '</STATE><LOT_SIZE>', lot_size, '</LOT_SIZE><UOMID>', uomid,
                '</UOMID><LIFESPAN>',lifespan, '</LIFESPAN><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PRODUCT>')
        FROM product
        WHERE id=_product_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another product. Please change the product name and try again.');
      END IF;
    ELSE
    SELECT NAME INTO ifexist 
      FROM product 
      WHERE name=_name
        AND id !=_product_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM product
      WHERE id=_product_id;
        
      UPDATE product
        SET pg_id=_pg_id,
            name = _name,
            `version` = _version,
            state = _state,
            lot_size = _lot_size,
            uomid = _uomid,
            lifespan = _lifespan,
            state_change_time = now(), 
            state_changed_by = _created_by,
            description = _description, 
              comment = _comment
      WHERE id = _product_id;
      
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
                'product',
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('product ', name, ' updated'),
                concat('<PRODUCT><PG_ID>',pg_id, '</PG_ID><NAME>', name,'</NAME><STATE>',state,
                  '</STATE><LOT_SIZE>', lot_size, '</LOT_SIZE><UOMID>', uomid,
                  '</UOMID><LIFESPAN>', lifespan, '</LIFESPAN><CREATE_TIME>',
                  create_time,'</CREATE_TIME><CREATED_BY>',created_by,
                  '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                  '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                  '</STATE_CHANGED_BY><DESCRIPTION>',IFNULL(description,''),
                  '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                  '</COMMENT></PRODUCT>')                
          FROM product
          WHERE id=_product_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another product. Please change the product name and try again.');
    END IF;
  END IF; 
 END IF;
END$


-- procedure add_attribute_to_product
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

-- procedure modify_recipe
DROP PROCEDURE IF EXISTS `modify_recipe`$
CREATE PROCEDURE `modify_recipe`(
  IN _created_by int(10) unsigned,
  INOUT _recipe_id int(10) unsigned,
  IN _name varchar(20),
  IN _exec_method enum('ordered','random'),
  IN _contact_employee int(10) unsigned,
  IN _instruction text,
  IN _file_action enum('delete', 'nochange', 'replace'),
  IN _diagram_filename varchar(255),
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);

  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Recipe name is required. Please give the recipe a name.';
    
  ELSEIF _exec_method IS NULL OR length(_exec_method)<1
  THEN
    SET _response = 'Execution Method is required.';
  ELSEIF _contact_employee IS NULL
  THEN
    SET _response='Contact Employee information is missing.'; 
  ELSE
    SET ifexist=NULL;
    SELECT firstname INTO ifexist
      FROM employee
     WHERE id = _created_by;
        
    IF ifexist IS NULL
    THEN
      SET _response = 'The employee who is inserting this attribute does not exist in database.';
    ELSE
      SET ifexist=NULL;
      IF _recipe_id IS NULL
      THEN
        SELECT name INTO ifexist 
        FROM recipe 
        WHERE name=_name;
        
        IF ifexist IS NULL
        THEN
          INSERT INTO recipe (
            name,
            exec_method,
            contact_employee,
            instruction,
            diagram_filename,
            create_time,
            created_by,        
            comment)
          VALUES (
            _name,
            _exec_method,
            _contact_employee,
            _instruction,
            _diagram_filename,
            now(),
            _created_by,
            _comment
  
          );
          SET _recipe_id = last_insert_id();
  
          SET _response = '';
        ELSE
          SET _response= concat('The name ',_name,' is already used by another recipe. Please change the recipe name and try again.');
        END IF;
      ELSE
      SELECT name INTO ifexist 
        FROM recipe 
        WHERE name=_name
          AND id !=_recipe_id;
          
      IF ifexist is NULL
      THEN 
        IF  _file_action = 'nochange' THEN
          UPDATE recipe
            SET name=_name,
                exec_method = _exec_method,
                contact_employee = _contact_employee,
                instruction = _instruction,
                update_time = now(),
                updated_by = _created_by,
                comment = _comment
          WHERE id = _recipe_id;
        ELSE
          IF _file_action='replace' AND _diagram_filename IS NULL
          THEN
            SET _response = "No new file supplied for replacing current file in system. Please select a file.";
          ELSEIF _file_action = 'replace' AND length(_diagram_filename)=0
          THEN
            SET _response = "No new file supplied for replacing current file in system. Please select a file.";
          ELSE
            UPDATE recipe
              SET name=_name,
                  exec_method = _exec_method,
                  contact_employee = _contact_employee,
                  instruction = _instruction,
                  diagram_filename = if(_file_action='delete', null, _diagram_filename),
                  update_time = now(),
                  updated_by = _created_by,
                  comment = _comment
            WHERE id = _recipe_id;  
          END IF;
        END IF;
        SET _response='';
      ELSE
        SET _response= concat('The name ', _name,' is already used by another recipe. Please change the recipe name and try again.');
      END IF;
    END IF; 
   END IF;
 END IF;
END$


-- procedure add_ingredient_to_recipe
DROP PROCEDURE IF EXISTS `add_ingredient_to_recipe`$
CREATE procedure add_ingredient_to_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source type is required.';
    
  ELSEIF _quantity IS NULL
  THEN
    SET _response = 'Quantity is required.'; 
    

    
  ELSE
      SELECT name INTO ifexist
        FROM recipe
      WHERE id =_recipe_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
         IF ifexist IS NULL
         THEN
           SET _response = 'The employee who is adding this ingredient does not exist in database.';
         ELSE
        
          SET ifexist=NULL;
          IF _source_type = 'product'
          THEN
            SELECT name,
                   uomid
             INTO ifexist, _uom_id
              FROM product
              WHERE id=_ingredient_id;
          ELSEIF _source_type = 'material'
          THEN
            SELECT name,
                   uom_id
              INTO ifexist, _uom_id
              FROM material
              WHERE id=_ingredient_id;
          ELSE
            SET _response = concat('Source type ' , _source_type , ' is not valid.');
          END IF;
          
          IF ifexist IS NULL 
          THEN
            IF _response IS NULL
            THEN
              SET _response = 'The ingredient you selected does not exist in database.';
            END IF;
          ELSE
              INSERT INTO ingredients
              (
                recipe_id,
                source_type,
                ingredient_id,
                quantity,
                uom_id,
                `order`,
                mintime,
                maxtime,
                comment
              )
              VALUES (
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment
              );

              INSERT INTO ingredients_history
              (
                event_time,
                employee_id,
                action,
                recipe_id,
                source_type,
                ingredient_id,
                quantity,
                uom_id,
                `order`,
                mintime,
                maxtime,
                comment              
              )
              VALUES (
                _eventtime,
                _employee_id,
                'insert',
                _recipe_id,
                _source_type,
                _ingredient_id,
                _quantity,
                _uom_id,
                _order,
                _mintime,
                _maxtime,
                _comment             
              );
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END$


-- procedure remove_ingredient_from_recipe
DROP PROCEDURE IF EXISTS `remove_ingredient_from_recipe`$
CREATE procedure remove_ingredient_from_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type varchar(10),
  IN _order tinyint(3) unsigned,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source Type is required.';
  ELSEIF _source_type !='product' AND _source_type!= 'material'
  THEN
    SET _response = 'Source Type can only have the value of "product" or "material". Please correct the value.';
    
  ELSE
      SELECT name INTO ifexist
        FROM recipe
      WHERE id =_recipe_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE
      
        SET ifexist=NULL;
        SELECT firstname INTO ifexist
          FROM employee
         WHERE id = _employee_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The employee who is adding this ingredient does not exist in database.';
        ELSE
        
        IF NOT EXISTS (SELECT * FROM ingredients
                        WHERE recipe_id = _recipe_id
                          AND source_type = _source_type
                          AND ingredient_id = _ingredient_id
                          AND `order` <=> _order)
        THEN
          IF _response IS NULL
          THEN
            SET _response = 'The ingredient you selected does not exist in database.';
          END IF;
        ELSE
          DELETE FROM ingredients
           WHERE recipe_id = _recipe_id
             AND source_type = _source_type
             AND ingredient_id = _ingredient_id
             AND `order` <=> _order;

          INSERT INTO ingredients_history
          (
            event_time,
            employee_id,
            action,
            recipe_id,
            source_type,
            ingredient_id,
            quantity,
            uom_id,
            `order`,
            mintime,
            maxtime,
            comment              
          )
          SELECT 
            _eventtime,
            _employee_id,
            'delete',
            recipe_id,
            source_type,
            ingredient_id,
            quantity,
            uom_id,
            `order`,
            mintime,
            maxtime,
            _comment 
           FROM ingredients
          WHERE recipe_id = _recipe_id
            AND source_type = _source_type
            AND ingredient_id = _ingredient_id
            AND `order` <=> _order
          ;
              UPDATE recipe
                 SET update_time = _eventtime,
                     updated_by = _employee_id
               WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END$


-- procedure modify_ingredient_in_recipe
DROP PROCEDURE IF EXISTS `modify_ingredient_in_recipe`$
CREATE procedure modify_ingredient_in_recipe (
  IN _employee_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _ingredient_id int(10) unsigned,  
  IN _source_type enum('product', 'material'),
  IN _quantity decimal(16,4) unsigned,
  IN _old_order tinyint(3) unsigned,
  IN _new_order tinyint(3) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _comment text,

  OUT _response varchar(255)
) 

-- user is not allowed to modify ingredient choosen, source type using this procedure.
-- Quantity, order, min time, max time, comment are modifiable.
BEGIN
  DECLARE ifexist varchar(255);
  -- DECLARE _uom_id smallint(3) unsigned;
  DECLARE _eventtime datetime;
  SET _eventtime = now();
  
  IF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.'; 
    
  ELSEIF _recipe_id IS NULL
  THEN
    SET _response='Recipe information is required.';   
   
  ELSEIF _source_type IS NULL OR length(_source_type)<1
  THEN
    SET _response = 'Source type is required.';
    
  ELSEIF _quantity IS NULL
  THEN
    SET _response = 'Quantity is required.'; 
    

    
  ELSE
      
      IF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
      THEN
        SET _response = 'The recipe selected does not exist in database.';
      ELSE  
         IF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
         THEN
           SET _response = 'The employee who is adding this ingredient does not exist in database.';
         ELSE
          
          IF NOT EXISTS 
          (SELECT *
             FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND `order`= _old_order
          ) 
          THEN
              SET _response = 'The ingredient you selected does not exist in database.';
          ELSEIF _new_order != _old_order AND EXISTS
           (SELECT *
              FROM ingredients
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND `order` = _new_order
           )
          THEN
            SET _response =concat( 'The ingredient already exists at order ', _new_order);
          ELSE
            UPDATE ingredients
               SET quantity = _quantity,
                   `order` = _new_order,
                   mintime = _mintime,
                   maxtime = _maxtime,
                   comment = _comment
             WHERE recipe_id = _recipe_id
               AND source_type = _source_type
               AND ingredient_id = _ingredient_id
               AND `order` = _old_order;


            INSERT INTO ingredients_history
            (
              event_time,
              employee_id,
              action,
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment              
            )
            SELECT
              _eventtime,
              _employee_id,
              'modify',
              recipe_id,
              source_type,
              ingredient_id,
              quantity,
              uom_id,
              `order`,
              mintime,
              maxtime,
              comment             
            FROM ingredients
            WHERE recipe_id = _recipe_id
              AND source_type = _source_type
              AND ingredient_id = _ingredient_id
              AND `order` = _new_order;
              
            UPDATE recipe
               SET update_time = _eventtime,
                   updated_by = _employee_id
             WHERE id=_recipe_id;
            END IF;
         END IF;
    END IF;
 END IF;
END$


-- procedure delete_recipe
DROP PROCEDURE IF EXISTS `delete_recipe`$
CREATE PROCEDURE `delete_recipe`(
  IN _recipe_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _event_time datetime;
  SET _event_time = now();
  
  IF _recipe_id IS NULL
  THEN
    SET _response='No recipe selected. Please select a recipe to delete.';
    
  ELSEIF NOT EXISTS (SELECT * FROM recipe WHERE id = _recipe_id)
  THEN
    SET _response = 'The selected recipe does not exist in database';
  ELSEIF _employee_id IS NULL
  THEN
    SET _response='Employee information that initiated deletion is missing .'; 
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN
    SET _response = 'The employee that initiated deletion does not have record in database.';
  ELSE
    START TRANSACTION;
      INSERT INTO ingredients_history
        (
          event_time,
          employee_id,
          action,
          recipe_id,
          source_type,
          ingredient_id,
          quantity,
          uom_id,
          `order`,
          mintime,
          maxtime,
          comment              
        )
      SELECT 
        _event_time,
        _employee_id,
        'delete',
        recipe_id,
        source_type,
        ingredient_id,
        quantity,
        uom_id,
        `order`,
        mintime,
        maxtime,
        'delete recipe'  
      FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM ingredients
      WHERE recipe_id = _recipe_id;
      
      DELETE FROM recipe
      WHERE id = _recipe_id;
     
    COMMIT;    
  END IF;
END$


-- procedure insert_process
DROP PROCEDURE IF EXISTS `insert_process`$
CREATE procedure insert_process (
  IN _prg_id int(10) unsigned,
  IN _name varchar(255),
  IN _version  int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),
  IN _owner_id int(10) unsigned,
  IN _if_default_version tinyint(1),
  IN _employee_id int(10) unsigned,
  IN _usage enum('sub process only','main process only','both'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255),
  OUT _process_id int(10) unsigned
) 
BEGIN
  DECLARE ifexist varchar(255);

  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Process name is required. Please give the process a name.';
    
  ELSEIF _owner_id IS NULL or _owner_id<0
  THEN
    SET _response = 'Process owner is required. Please give the process an owner.';    
   
  ELSEIF _usage IS NULL or length(_usage)<1
  THEN
    SET _response = 'Process usage is required.  Please select process usage.';
    
  ELSE

      SELECT NAME INTO ifexist 
      FROM process 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO process (
          prg_id, 
          name, 
          `version`, 
          state,
          owner_id,
          if_default_version,
          create_time, 
          created_by,  
          `usage`,
          description, 
          comment)
        VALUES (
          _prg_id,
          _name,
          _version,
          _state,
          _owner_id,
          _if_default_version,
          now(),
          _employee_id,
          _usage,
          _description,
          _comment
        );
        SET _process_id = last_insert_id();
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
              'process',
              id,
              null,
              state,
              created_by,
              concat('process', name , 'is created'),
              concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
              '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
                '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
                '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><USAGE>', `usage`, 
                '</USAGE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PROCESS>')
        FROM process
        WHERE id=_process_id;
        SET _response = '';
      ELSE
        SET _response= concat('The process name ' , _name ,' is already used by another process. Please change the process name and try again.');
      END IF;
 
 END IF;
END$

-- procedure modify_process
DROP PROCEDURE IF EXISTS `modify_process`$
CREATE procedure modify_process (
  IN _process_id int(10) unsigned,
  IN _prg_id int(10) unsigned,
  IN _name varchar(255),
  IN _version  int(5) unsigned,
  IN _state enum('inactive', 'production', 'frozen', 'checkout', 'checkin', 'engineer'),
  IN _owner_id int(10) unsigned,
  IN _if_default_version tinyint(1),
  IN _employee_id int(10) unsigned,
  IN _usage enum('sub process only','main process only','both'),
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _process_id IS NULL
  THEN
    SET _response='Process id is required. Please suppy process id.';
    
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Process name is required. Please give the process a name.';
    
  ELSEIF _owner_id IS NULL or _owner_id<0
  THEN
    SET _response = 'Process owner is required. Please give the process an owner.';    
   
  ELSEIF _usage IS NULL or length(_usage)<1
  THEN
    SET _response = 'Process usage is required.  Please select process usage.';
    
  ELSE

      SELECT NAME INTO ifexist 
      FROM process 
      WHERE name=_name
        AND id!= _process_id;
      
      IF ifexist IS NULL
      THEN
       SELECT state
         INTO _oldstate
        FROM process
      WHERE id=_process_id;  
      
        UPDATE process
           SET prg_id = _prg_id,
               name = _name,
               `version` = _version,
               state = _state,
               owner_id = _owner_id,
               if_default_version = _if_default_version,
               `usage` = _usage,
               description = _description,
               comment = _comment,
               state_change_time = now(),
               state_changed_by = _employee_id
        WHERE  id = _process_id;

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
              'process',
              id,
              _oldstate,
              state,
              state_changed_by,
              concat('process' , name , ' general information is updated'),
              concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
              '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
                '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
                '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
                '</CREATE_TIME><CREATED_BY>',created_by,
                '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
                '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
                '</STATE_CHANGED_BY><USAGE>', `usage`, 
                '</USAGE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
                '</COMMENT></PROCESS>')              
        FROM process
        WHERE id=_process_id;
        SET _response = '';
      ELSE
        SET _response= concat('The process name ' , _name ,' is already used by another process. Please change the process name and try again.');
      END IF;
 
 END IF;
END$

-- procedure delete_process
DROP PROCEDURE IF EXISTS `delete_process`$
CREATE procedure delete_process (
  IN _process_id int(10) unsigned,
  IN _employee_id int(10) unsigned
) 
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  DECLARE _eventtime datetime;
  SET _eventtime = now();  


   SELECT NAME INTO ifexist 
   FROM process 
   WHERE id= _process_id;
   
   IF ifexist IS NOT NULL
   THEN
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      if_sub_process,
      need_approval,
      approve_emp_usage,
      approve_emp_id 
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'DELETE',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      if_sub_process,
      need_approval,
      approve_emp_usage,
      approve_emp_id  
    FROM process_step
    WHERE process_id=_process_id;

    
    DELETE FROM process_step
    WHERE process_id = _process_id;
  
    -- delete process_segment record
    DELETE FROM process_segment
    WHERE process_id = _process_id;
    
    SELECT state
     INTO _oldstate
     FROM process
   WHERE id=_process_id;  
   
   DELETE FROM product_process
    WHERE process_id = _process_id;
    
   DELETE FROM process
    WHERE id=_process_id;

     INSERT INTO config_history (
       event_time,
       source_table,
       source_id,
       old_state,
       new_state,
       employee,
       comment 
     )
     VALUES (_eventtime,
             'process',
             _process_id,
             _oldstate,
             'deleted',
             _employee_id,
             concat('process ' , ifexist , ' is deleted')
             );


   END IF;

END$

-- procedure modify_segment
DROP PROCEDURE IF EXISTS `modify_segment`$
CREATE PROCEDURE `modify_segment`(
  IN _process_id int(10) unsigned,
  INOUT _segment_id int(5) unsigned, 
  IN _name varchar(255),
  IN _position smallint(2),
  IN _description text,
  OUT _response varchar(255)
)
BEGIN
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Segment name is required. Please give the segment a name.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response='Workflow is required. Please select a workflow for the segment.';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
  THEN
    SET _response="The workflow you chose doesn't exist in database.";
  ELSE
    IF _segment_id IS NULL
    THEN

      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND name=_name)
      THEN
        SET _response= concat('The name ',_name,' is already used by another segment. Please change the segment name and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND `position`=_position)
      THEN
        SET _response = 'There is already another segment for the same position, please make the position available before adding new segment to it.';
      ELSE
        INSERT INTO process_segment (process_id, segment_id, name, `position`, description)
        SELECT _process_id,
               ifnull(MAX(segment_id),0)+1,
               _name,
               _position,
               _description
          FROM process_segment
         WHERE process_id = _process_id;

      END IF;
    ELSE        
      IF EXISTS (SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id!=_segment_id AND name=_name)
      THEN
        SET _response= concat('The segment name ', _name,' is already used by another segment. Please change it and try again.');
      ELSEIF EXISTS (SELECT * FROM process_segment WHERE process_id = _process_id AND segment_id!=_segment_id AND `position`=_position) 
      THEN
        SET _response=concat('The position ', _position, ' is already occupied by another segment. Please make it available before using the position.');
      ELSE
          
        UPDATE process_segment
          SET name = _name,
              `position`=_position,
              description = _description
        WHERE process_id=_process_id
          AND segment_id=_segment_id;
      END IF;
    END IF; 
  END IF;
END$

-- procedure modify_step
DROP PROCEDURE IF EXISTS `modify_step`$
CREATE PROCEDURE `modify_step`(
  INOUT _step_id int(10) unsigned, 
  IN _created_by int(10) unsigned,
  IN _version int(5) unsigned,
  IN _if_default_version tinyint(1) unsigned,
  IN _state enum('inactive','production','frozen','checkout','checkin','engineer'),
  IN _eq_usage enum('equipment group','equipment'),
  IN _emp_usage enum('employee group','employee'),
  IN _emp_id int(10) unsigned,  
  IN _name varchar(255),
  IN _step_type_id int(5) unsigned,   
  IN _eq_id int(10) unsigned,
  IN _recipe_id int(10) unsigned,
  IN _mintime int(10) unsigned,
  IN _maxtime int(10) unsigned,
  IN _description text,
  IN _comment text,  
  IN _para1 text,
  IN _para2 text,
  IN _para3 text,
  IN _para4 text,
  IN _para5 text,
  IN _para6 text,
  IN _para7 text,
  IN _para8 text,
  IN _para9 text,
  IN _para10 text,  
  IN _para_count tinyint(3),
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  DECLARE _oldrecord text;
  DECLARE _newrecord text;
  DECLARE _oldstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  DECLARE _newstate  enum('inactive','production','frozen','checkout','checkin','engineer');
  
  IF _step_type_id IS NULL OR length(_step_type_id)<1
  THEN
    SET _response='Step type is required. Please give the step a type.';
  
  ELSEIF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Step name is required. Please give the step a name.';
  ELSEIF `_version` IS NULL OR length(`_version`)<1
  THEN
    SET _response='Step version is required. Please give the step a version.';  
 
  ELSEIF _created_by IS NULL OR length(_created_by)<1
  THEN
    SET _response='Created by is required. Please select create person.';  
   
  ELSE
    IF _step_id IS NULL
    THEN
      SELECT NAME INTO ifexist 
      FROM step 
      WHERE name=_name;
      
      IF ifexist IS NULL
      THEN
        INSERT INTO step (
          step_type_id,
          name,
          `version`,
          if_default_version,
          state,
          eq_usage,
          eq_id,
          emp_usage,
          emp_id,
          recipe_id,
          mintime,
          maxtime,
          create_time,
          created_by,
          para_count,
          description,
          comment,
          para1,
          para2,
          para3,
          para4,
          para5,
          para6,
          para7,
          para8,
          para9,
          para10
        )
        VALUES (
          _step_type_id,
          _name,
          _version,
          _if_default_version,
          _state,
          _eq_usage,
          _eq_id,
          _emp_usage,
          _emp_id,
          _recipe_id,
          _mintime,
          _maxtime,
          now(),
          _created_by,
          _para_count,
          _description,
          _comment,  
          _para1,
          _para2,
          _para3,
          _para4,
          _para5,
          _para6,
          _para7,
          _para8,
          _para9,
          _para10
        );
        SET _step_id = last_insert_id();
        
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
              'step',
              id,
              NULL,
              state,
              created_by,
              concat('Step ', name, ' is created'),
              concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')
        FROM step
        WHERE id=_step_id;
        SET _response = '';
      ELSE
        SET _response= concat('The name ',_name,' is already used by another step. Please change the step name and try again.');
      END IF;
    ELSE
    SELECT name INTO ifexist 
      FROM step 
      WHERE name=_name
        AND id !=_step_id;
        
    IF ifexist is NULL
    THEN
      SELECT state
        INTO _oldstate
        FROM step
      WHERE id=_step_id;
        
      UPDATE step
        SET step_type_id = _step_type_id,
            name = _name,
            `version` = _version,
            if_default_version = _if_default_version,
            state = _state,
            eq_usage = _eq_usage,
            eq_id = _eq_id,
            emp_usage = _emp_usage,
            emp_id = _emp_id,
            recipe_id = _recipe_id,
            mintime = _mintime,
            maxtime = _maxtime,
            state_change_time = now(),
            state_changed_by = _created_by,
            para_count = _para_count,
            description = _description,
            comment = _comment,  
            para1 = _para1,
            para2 = _para2,
            para3 = _para3,
            para4 = _para4,
            para5 = _para5,
            para6 = _para6,
            para7 = _para7,
            para8 = _para8,
            para9 = _para9,
            para10 = _para10
      WHERE id = _step_id;
      
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
                'step',
                id,
                _oldstate,
                state,
                state_changed_by,
                concat('step ', name, ' updated'),
                concat('<STEP><STEP_TYPE_ID', step_type_id,
                      '</STEP_TYPE_ID><NAME>',name,
                      '</NAME><VERSION>',`version`,
                      '</VERSION><IF_DEFAULT_VERSION>',if_default_version,
                      '</IF_DEFAULT_VERSION><STATE>',state,
                      '</STATE><EQ_USAGE>',eq_usage,
                      '</EQ_USAGE><EQ_ID>',eq_id,
                      '</EQ_ID><EMP_USAGE>',emp_usage,
                      '</EMP_USAGE><EMP_ID>',emp_id,
                      '</EMP_ID><RECIPE_ID>',recipe_id,
                      '</RECIPE_ID><MINTIME>',mintime,
                      '</MINTIME><MAXTIME>',maxtime,
                      '</MAXTIME><PARA_COUNT>',para_count,
                      '</PARA_COUNT><DESCRIPTION>',description,
                      '</DESCRIPTION><COMMENT>',comment,
                      '</COMMENT><PARA1>',para1,
                      '</PARA1><PARA2>',para2,
                      '</PARA2><PARA3>',para3,
                      '</PARA3><PARA4>',para4,
                      '</PARA4><PARA5>',para5,
                      '</PARA5><PARA6>',para6,
                      '</PARA6><PARA7>',para7,
                      '</PARA7><PARA8>',para8,
                      '</PARA8><PARA9>',para9,
                      '</PARA9><PARA10>',para10,
                      '</PARA10></STEP>')                
          FROM step
          WHERE id=_step_id;
      SET _response='';
    ELSE
      SET _response= concat('The name ', _name,' is already used by another step. Please change the step name and try again.');
    END IF;
  END IF; 
 END IF;
END$

-- procedure add_step_to_process
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : add_step_to_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : add a step/position to a process in process_step table
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/12/2018: xdong: add new input parameter _product_made to indicate whether at the end of current step/position, final product is made				
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `add_step_to_process`$
CREATE procedure add_step_to_process (
  IN _process_id int(10) unsigned,
  IN _position_id  int(5) unsigned,
  IN _step_id int(10) unsigned,
  IN _prev_step_pos  int(5) unsigned,
  IN _next_step_pos  int(5) unsigned,
  IN _false_step_pos  int(5) unsigned,
  IN _segment_id  int(5) unsigned,
  IN _rework_limit smallint(2) unsigned,
  IN _if_sub_process tinyint(1),
  IN _prompt varchar(255),
  IN _if_autostart tinyint(1) unsigned,
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  IN _product_made tinyint(1) unsigned,
  OUT _response varchar(255)
) 
BEGIN

  DECLARE _eventtime datetime;
  DECLARE _step_type varchar(20);
  
  
  SET _eventtime = now();
 

IF NOT EXISTS (SELECT * FROM step WHERE id=_step_id)
THEN
  SET _response="The step you selected doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT * FROM process WHERE id=_process_id)
THEN
  SET _response="The workflow you are working on doesn't exist in database.";
ELSEIF EXISTS (SELECT position_id FROM process_step WHERE process_id = _process_id AND position_id = _position_id)
THEN
  SET _response= concat('The position ' , _position_id ,' is already used in the process. Please change the position and try again.');
ELSEIF _segment_id IS NOT NULL AND NOT EXISTS(SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id = _segment_id)
THEN
  SET _response = "The segment you chose does not exist in database";
ELSEIF _product_made = 1 AND -- if setting current step/position as product made
        (EXISTS (SELECT position_id FROM process_step ps WHERE process_id = _process_id AND position_id != _position_id AND product_made = 1)
        -- no other step/position should be set as product made
         OR EXISTS (SELECT ps.position_id FROM process_step ps 
                      JOIN process_step ps2
                        ON ps.process_id = ps.step_id
                           AND ps2.product_made=1
                    WHERE ps.process_id = _process_id AND ps.if_sub_process=1)
         -- no other sub process should have it set up
         OR EXISTS (SELECT position_id
                      FROM process_step ps
                     WHERE ps.process_id = _step_id
                       AND _if_sub_process = 1
                       AND ps.product_made = 1)
        -- if current step is a sub process, inside the sub process should not have it set up
        )
THEN
  SET _response = "There is already a step or sub step has been marked as 'Product Made', please turn of that step before check current step as 'Product Made'";

ELSE
  
  SELECT t.name INTO _step_type
    FROM step s, step_type t
   WHERE s.id = _step_id
     AND t.id = s.step_type_id;
     
  IF _step_type = 'condition' AND _false_step_pos IS NULL 
  THEN
    SET _response="A step position on false result is required for conditional step.";
  ELSEIF _step_type != 'condition' AND _false_step_pos IS NOT NULL 
  THEN
    SET _response = "No step position on false result is needed. Please leave it blank.";
  ELSE
  
    IF _if_sub_process = 1
    THEN
      SET _if_autostart = 1;
    END IF;
    INSERT INTO process_step (
      process_id,
      position_id,
      step_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made)
    VALUES (
      _process_id,
      _position_id,
      _step_id,
      _prev_step_pos,
      _next_step_pos,
      _false_step_pos,
      _segment_id,
      _rework_limit,
      _if_sub_process,
      _prompt,
      _if_autostart,
      _need_approval,
      _approve_emp_usage,
      _approve_emp_id,
      _product_made
    );
  
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'insert',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    FROM process_step
    WHERE process_id=_process_id
      AND position_id = _position_id;
    
    UPDATE process
      SET state_change_time = _eventtime,
          state_changed_by = _employee_id
    WHERE id = _process_id;

   
  END IF;


END IF;

END$


-- procedure modify_step_in_process
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_step_in_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Modify a current step/position within a process in process_step table
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    11/12/2018: xdong: added new input parameter _product_made to mark whether current position produce final product				
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `modify_step_in_process`$
CREATE procedure modify_step_in_process (
  IN _process_id int(10) unsigned,  -- id of process that the position belongs to
  IN _position_id  int(5) unsigned, -- id of position. unique in current process
  IN _step_id int(10) unsigned,  -- id of step that current position points to
  IN _prev_step_pos  int(5) unsigned, -- id of previous position
  IN _next_step_pos  int(5) unsigned, -- id of next position to go to for non condition step. for conditions step, if condition is met at the end of this step
  IN _false_step_pos  int(5) unsigned, -- id of position to go to if current step is a condition step and condition is not met at the end of this step
  IN _segment_id int(5) unsigned,  -- id of the segment this step/position belongs to
  IN _rework_limit smallint(2) unsigned, -- limit of rework to this step/position
  IN _if_sub_process tinyint(1), -- whether the position is pointing to a sub process
  IN _prompt varchar(255),  -- prompt to show to operator at this position
  IN _if_autostart tinyint(1) unsigned,  -- whether to autostart the step at this position
  IN _need_approval tinyint(1), -- whether the step/position need approval
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,  -- the id of employee group, employee category or employee, who approves the step depending on _approve_emp_usage
  IN _employee_id int(10) unsigned,  -- id of employee who add or modifyied this step/position
  IN _product_made tinyint(1) unsigned,  -- whether final product is made at this step/position
  OUT _response varchar(255)
) 
BEGIN
  DECLARE _step_type varchar(20);
  DECLARE _eventtime datetime;
  SET _eventtime = now();

IF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
THEN
  SET _response = "The workflow you are working on doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT * FROM step WHERE id=_step_id)
THEN
  SET _response = "The step you selected doesn't exist in database.";
ELSEIF NOT EXISTS (SELECT position_id  
                FROM process_step 
                WHERE process_id = _process_id
                  AND position_id = _position_id)
THEN
  SET _response= concat('The position ' , _position_id ,' doesn''t exist in this process.') ;
ELSEIF _segment_id IS NOT NULL AND NOT EXISTS(SELECT * FROM process_segment WHERE process_id=_process_id AND segment_id = _segment_id)
THEN
  SET _response = "The segment you chose does not exist in database";
ELSEIF _product_made = 1 AND -- if setting current step/position as product made
        (EXISTS (SELECT position_id FROM process_step ps WHERE process_id = _process_id AND position_id != _position_id AND product_made = 1)
        -- no other step/position should be set as product made
         OR EXISTS (SELECT ps.position_id FROM process_step ps 
                      JOIN process_step ps2
                        ON ps.process_id = ps.step_id
                           AND ps2.product_made=1
                    WHERE ps.process_id = _process_id AND ps.if_sub_process=1)
         -- no other sub process should have it set up
         OR EXISTS (SELECT position_id
                      FROM process_step ps
                     WHERE ps.process_id = _step_id
                       AND _if_sub_process = 1
                       AND ps.product_made = 1)
        -- if current step is a sub process, inside the sub process should not have it set up
        )
THEN
  SET _response = "There is already a step or sub step has been marked as 'Product Made', please turn of that step before check current step as 'Product Made'";
ELSE

  SELECT t.name INTO _step_type
    FROM step s, step_type t
   WHERE s.id = _step_id
     AND t.id = s.step_type_id;
     
  IF _step_type = 'condition' AND _false_step_pos IS NULL 
  THEN
    SET _response="A step position on false result is required for conditional step.";
  ELSEIF _step_type != 'condition' AND _false_step_pos IS NOT NULL 
  THEN
    SET _response = "No step position on false result is needed. Please leave it blank.";
  ELSE  
    IF _if_sub_process = 1
    THEN
      SET _if_autostart = 1;
    END IF; 
    
    UPDATE process_step
      SET step_id=_step_id,
          prev_step_pos = _prev_step_pos,
          next_step_pos = _next_step_pos,
          false_step_pos = _false_step_pos,
          segment_id = _segment_id,
          rework_limit = _rework_limit,
          if_sub_process = _if_sub_process,
          prompt = _prompt,
          if_autostart = _if_autostart,
          need_approval = _need_approval,
          approve_emp_usage = _approve_emp_usage,
          approve_emp_id = _approve_emp_id,
          product_made = _product_made
      WHERE process_id= _process_id
        AND position_id = _position_id;
  
  
    INSERT INTO process_step_history (
      event_time,
      process_id,
      position_id,
      step_id,
      action,
      employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    )
    SELECT _eventtime,
      process_id,
      position_id,
      step_id,
      'modify',
      _employee_id,
      prev_step_pos,
      next_step_pos,
      false_step_pos,
      segment_id,
      rework_limit,
      if_sub_process,
      prompt,
      if_autostart,
      need_approval,
      approve_emp_usage,
      approve_emp_id,
      product_made
    FROM process_step
    WHERE process_id=_process_id
      AND position_id = _position_id;
    
    UPDATE process
      SET state_change_time = _eventtime,
          state_changed_by = _employee_id
    WHERE id = _process_id;
  
    
  END IF;

END IF;

END$


-- procedure modify_client_document
DROP PROCEDURE IF EXISTS `modify_client_document`$
CREATE PROCEDURE `modify_client_document`(
  IN _operation char(6), -- 'insert' or 'update'
  IN _id int(10) unsigned,
  IN _client_id int(10) unsigned,
  IN _recorder_id int(10) unsigned,  
  IN _key_words varchar(255),
  IN _title varchar(255),
  IN _path varchar(255),
  IN _version varchar(10),
  IN _contact int(10) unsigned,
  IN _description text,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  IF _title IS NULL or length(_title)<1
  THEN
    SET _response = 'Document title is missing. Please fill in the title.';
  ELSEIF _path IS NULL or length(_path)<1
  THEN
    SET _response = 'Document path is missing. Please fill in the path.';
  ELSEIF _recorder_id IS NULL or NOT EXISTS (SELECT * FROM employee WHERE id<=>_recorder_id)
  THEN
    SET _response = 'Sorry, you are not an active employee and can not record this document.';
  ELSEIF _contact IS NULL or NOT EXISTS (SELECT * FROM employee WHERE id<=>_contact)
  THEN
    SET _response = 'The contact person selected is not an active employee.';
  ELSE
    IF _operation = 'insert'
    THEN
      IF EXISTS (SELECT * FROM document WHERE source_table = 'client' AND source_id=_client_id AND title = _title)
      THEN
        SET _response = 'Sorry, the document with the same title already exists in our database. Please change the title and retry.';
      ELSE
        INSERT INTO document
        (
          source_table,
          source_id,
          key_words,
          title,
          path,
          `version`,
          recorder_id,
          contact_id,
          record_time,
          description,
          comment
      
        )
        VALUES (
          'client',
          _client_id,
          _key_words,
          _title,
          _path,
          _version,
          _recorder_id,
          _contact,
          now(),
          _description,
          _comment
          );
      END IF;
    ELSEIF _operation = 'update'
    THEN
      IF _id IS NULL 
      THEN
        SET _response = 'There is no record selected for update. Please select a record to update.';
      ELSEIF  EXISTS (SELECT * FROM document WHERE id!=_id AND source_table = 'client' AND source_id=_client_id AND title = _title)
      THEN
        SET _response = 'Sorry, the document with the same title already exists in our database. Please change the title and retry.';
      ELSE
        UPDATE document
           SET key_words = _key_words,
               title = _title,
               path = _path,
               `version` = _version,
               contact_id = _contact,
               updated_by = _recorder_id,
               update_time = now(),
               description = _description,
               comment = _comment
        WHERE id = _id;
      END IF;
    END IF;  
  END IF;
END$


-- procedure associate_product_process
DROP PROCEDURE IF EXISTS `associate_product_process`$
CREATE PROCEDURE `associate_product_process`(
  IN _product_id int(10) unsigned,
  IN _recorder int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _priority tinyint(2) unsigned,
  IN _comment text,
  OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  IF _product_id IS NULL
  THEN
    SET _response = 'No product was selected. Please select a product.';
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'No process was selected. Please select a process.';
  ELSE
      SELECT name INTO ifexist 
      FROM product 
      WHERE id=_product_id;
      
      IF ifexist IS NULL
      THEN
        SET _response = 'The product you selected does not exist in database.';
      ELSE
        SET ifexist = NULL;
        SELECT name INTO ifexist
        FROM process
        WHERE id=_process_id;
        
        IF ifexist IS NULL
        THEN
          SET _response = 'The process you selected does not exist in database.';
        ELSE
          SET ifexist = NULL;
          SELECT 'RECORD EXIST' INTO ifexist
           FROM product_process
          WHERE product_id = _product_id
            AND process_id = _process_id;
          
          IF ifexist IS NULL
          THEN
            INSERT INTO product_process (
              product_id,
              process_id,
              priority,
              recorder,
              comment)
            VALUES (
              _product_id,
              _process_id,
              _priority,
              _recorder,
              _comment
            );
          ELSE
            UPDATE product_process
               SET priority = _priority,
                   recorder = _recorder,
                   comment = _comment
             WHERE product_id = _product_id
               AND process_id = _process_id
               ;
          END IF;
        END IF;
      END IF;
  END IF;
END$

/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : dispatch_multi_lots.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Diapatch a lot/batch from a order detail line. The dispatch routine will dispatch 1-n batches depending on _num_lots input
*                             and each batch contains 1-n unit of final products depending on _lot_size
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 				
*   11/11/2018: xdong: added input _line_num now that order_detail can have multi lines of the same product	
*   12/01/2018: xdong: fixed a bug that updated the quantity_in_process of all order detail lines of the same product, by missed line_num in where clause
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `dispatch_multi_lots`$
CREATE PROCEDURE `dispatch_multi_lots`(
  IN _order_id int(10) unsigned, -- the id of the order it dispatch from
  IN _line_num smallint(5) unsigned, -- the line number in the order detail to dispatch from
  IN _product_id int(10) unsigned, -- the product id to produce with the batch
  IN _process_id int(10) unsigned, -- the id of the process that the batch will assume
  IN _lot_size decimal(16,4) unsigned, -- the size of the final product in the batch
  IN _num_lots int(10) unsigned, -- number of batch to dispatch in this call
  IN _alias_prefix varchar(10), -- prefix to use in producing the batch alias (batch name)
  IN _location_id int(11) unsigned,  -- id of location to dispatch to
  IN _lot_contact int(10) unsigned, -- employee id of the contact person for the batch
  IN _lot_priority tinyint(2) unsigned, -- priority of the batch
  IN _comment text,  -- any comment on the batch
  IN _dispatcher int(10) unsigned, -- person dispatched the batch
  OUT _response varchar(255)  -- any error or message from this stored procedure
)
BEGIN

  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(20);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
  DECLARE _new_id int(10) unsigned;
  DECLARE _total_quantity decimal(16,4) unsigned;
 
  SET autocommit=0;

  
  IF _order_id IS NULL
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id)
  THEN
    SET _response = "The order you selected doesn't exist in database.";    
    ELSEIF NOT EXISTS (SELECT * FROM order_detail WHERE order_id=_order_id AND line_num = _line_num )
  THEN
    SET _response = "The order line you selected doesn't exist in database.";    
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'Process is required. Please select a process to dispatch lots to';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
  THEN
    SET _response = "The process you selected doesn't exist in database.";
  ELSEIF _num_lots IS NULL or _num_lots < 1
  THEN
    SET _response = 'Number of lots to dispatch is incorrect. Please dispatch at least one lot.';
  ELSEIF _dispatcher IS NULL
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher)
  THEN
    SET _response = "Dispatcher information doesn't exist in our database.";
  ELSEIF _product_id IS NULL
  THEN
      SET _response = 'The order you selected does not exist in database.';
  ELSEIF NOT EXISTS
  (   SELECT *
        FROM product_process
      WHERE process_id = _process_id
        AND product_id = _product_id
   )  
  THEN
        SET _response = 'The process you selected can not be used to manufacture the ordered product.';
  ELSE
    IF _lot_size IS NULL
    THEN
      SELECT lot_size into _lot_size
        FROM product
       WHERE id = _product_id;
    ELSEIF _lot_size > (SELECT lot_size FROM product WHERE id = _product_id)
    THEN
      SET _response ="The lot size you selected is bigger than the maximum lot size limit for the product. Please adjust your lot size.";
    END IF;
        
    IF _lot_priority IS NULL
    THEN
      SELECT priority INTO _lot_priority
        FROM `order`
       WHERE id = _order_id;
    END IF;
        
    IF _lot_size IS NULL
    THEN
      SET _response = 'Lot size information can not be found. Please enter the size for a single lot.';
    ELSE
--       SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
--                             between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
--                             and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
--                         substring(addtime(timezone, '01:00'), 1, 6),
--                         timezone)  
--               FROM company c, employee e
--               WHERE e.id = _dispatcher AND c.id = e.company_id);       
      
      SET _dispatch_time = utc_timestamp();
      
      SET _alias_suffix = 0;
      SET _total_quantity = 0;
      
      IF _alias_prefix IS NULL
      THEN
        SET _alias_prefix = '';
      END IF;
      
      SELECT uomid INTO _uom_id
        FROM product
      WHERE id = _product_id;    
      
       SET _ratio = null;
      IF EXISTS (SELECT * 
                FROM order_detail
                WHERE order_id = _order_id
                  AND line_num = _line_num
                  AND source_type = 'product'
                  AND source_id = _product_id
                  AND uomid = _uom_id
              )
      THEN
        SET _ratio = 1;
      ELSE
        SELECT constant INTO _ratio
          FROM uom_conversion u 
          JOIN order_detail o ON o.order_id = _order_id 
                                AND o.line_num = _line_num
                                AND o.source_type = 'product' 
                                AND o.source_id = _product_id
        WHERE from_id = _uom_id
          AND to_id = o.uomid
          AND method = 'ratio';
        
        IF _ratio IS NULL
        THEN
          SELECT constant INTO _ratio
            FROM uom_conversion u 
            JOIN order_detail o ON o.order_id = _order_id 
                                  AND o.line_num = _line_num
                                  AND o.source_type = 'product' 
                                  AND o.source_id = _product_id
                                  AND o.line_num = _line_num
          WHERE to_id = _uom_id
            AND from_id = o.uomid
            AND method = 'ratio';  
        
          IF _ratio IS NULL OR _ratio = 0
          THEN
            SET _response = "There is no valid conversion between the unit of measure used in traveler and the unit of measure used in order. Please add conversion between the two UoMs.";
          ELSE
            SET _ratio = 1.00/_ratio;
          END IF;
        END IF;
      END IF;      
      IF _ratio IS NOT NULL AND NOT EXISTS (SELECT * FROM order_detail o
                    WHERE o.order_id = _order_id
                      AND o.line_num = _line_num
                      AND o.source_type = 'product'
                      AND o.source_id = _product_id
                      AND o.quantity_requested >= (quantity_in_process + _lot_size*_ratio*_num_lots+quantity_made+quantity_shipped))
      THEN
        SET _response = "You are dispatching more product than requested. Please adjust lot size.";
      END IF;
      
      CREATE TEMPORARY TABLE IF NOT EXISTS multilots (lot_id int(10) unsigned, lot_alias varchar(20));
      
      START TRANSACTION;
      WLOOP: WHILE _num_lots >0 DO
        SET _num_lots = _num_lots - 1;
        
        -- IF _alias_suffix = 3 THEN
        IF _alias_suffix = 4294967295 THEN
          ROLLBACK;
          SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
          LEAVE WLOOP;
          
        END IF;
        
        SET _alias_suffix = _alias_suffix + 1;
        SET _alias = CONCAT(_alias_prefix, _alias_suffix);
        
        ALOOP: WHILE EXISTS (SELECT * FROM lot_status WHERE alias=_alias)
        DO
           -- IF _alias_suffix = 3 THEN 
          IF _alias_suffix = 4294967295 THEN
          
            ROLLBACK;
            SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
            LEAVE ALOOP;
          END IF;
        
          SET _alias_suffix = _alias_suffix + 1;
          SET _alias = CONCAT(_alias_prefix, _alias_suffix);    
          
        END WHILE;
        
        IF _response IS NULL OR length(_response) = 0
        THEN
          INSERT INTO lot_status(
            alias,
            order_id,
            order_line_num,
            product_id,
            process_id,
            status,
            start_quantity,
            actual_quantity,
            uomid,
            update_timecode,
            contact,
            priority,
            dispatcher,
            dispatch_time,
			location_id,
            comment,
            quantity_status
            )
            VALUES
            (
              _alias,
              _order_id,
              _line_num,
              _product_id,
              _process_id,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _lot_contact,
              _lot_priority,
              _dispatcher,
              _dispatch_time,
			  _location_id,
              _comment ,
              'in process'
            );
          SET _new_id = last_insert_id();
            
          IF _new_id IS NOT NULL
          THEN
            INSERT INTO lot_history (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
			  location_id,
              comment,
              order_line_num,
              quantity_status
              )
            VALUES (
              _new_id,
              _alias,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _process_id,
              0,
              0,
              _dispatcher,
              _dispatcher,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
			  _location_id,
              _comment,
              _line_num,
              'in process'
              );
  
            INSERT INTO multilots (lot_id, lot_alias)
            VALUES (_new_id, _alias);
            
            SET _total_quantity = _total_quantity + _lot_size;
          ELSE
            ROLLBACK;
            SET _response = "Error countered when dispatching lot.";
            LEAVE WLOOP;
          END IF;
        ELSE
          LEAVE WLOOP;
        END IF;
 
        
        
      END WHILE;
      
      IF _response IS NULL OR length(_response) = 0
      THEN
        UPDATE `order_detail`
           SET quantity_in_process = ifnull(quantity_in_process, 0) +  _total_quantity*_ratio
         WHERE order_id=_order_id
           AND line_num = _line_num;
        COMMIT;
      
      END IF;
      
      SELECT lot_id, lot_alias
        FROM multilots;
        
      DROP TABLE multilots;
      
    END IF;
   
   
  END IF;


END$


-- procedure dispatch_single_lot
DROP PROCEDURE IF EXISTS `dispatch_single_lot`$
CREATE PROCEDURE `dispatch_single_lot`(
  IN _order_id int(10) unsigned, 
  IN _product_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _lot_size decimal(16,4) unsigned,
  IN _alias_prefix varchar(10), 
  IN _lot_contact int(10) unsigned,
  IN _lot_priority tinyint(2) unsigned,
  IN _comment text,
  IN _dispatcher int(10) unsigned,
  OUT _lot_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
 
  DECLARE _uom_id smallint(3) unsigned;
  DECLARE _alias_suffix int(10) unsigned zerofill;
  DECLARE _alias varchar(20);
  DECLARE _dispatch_time datetime;
  DECLARE _ratio decimal(16,4) unsigned;
 

 
  -- SET AUTOCOMMIT = 0;
  
  IF _order_id IS NULL
  THEN
    SET _response = 'Order is required. Please select an order to dispatch lots from';
  ELSEIF NOT EXISTS (SELECT * FROM order_general WHERE id=_order_id)
  THEN
    SET _response = "The order you selected doesn't exist in database.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = 'Process is required. Please select a process to dispatch lots to';
  ELSEIF NOT EXISTS (SELECT * FROM process WHERE id = _process_id)
  THEN
    SET _response = "The process you selected doesn't exist in database.";
  ELSEIF _dispatcher IS NULL
  THEN
    SET _response = 'Dispatcher information is missing.';
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_dispatcher)
  THEN
    SET _response = "Dispatcher information doesn't exist in our database.";
  ELSEIF _product_id IS NULL
  THEN
      SET _response = 'The order you selected does not exist in database.';
  ELSEIF NOT EXISTS
  (   SELECT *
        FROM product_process
      WHERE process_id = _process_id
        AND product_id = _product_id
   )  
  THEN
        SET _response = 'The process you selected can not be used to manufacture the ordered product.';
  ELSE
    IF _lot_size IS NULL
    THEN
      SELECT lot_size into _lot_size
        FROM product
       WHERE id = _product_id;
    ELSEIF _lot_size > (SELECT lot_size FROM product WHERE id = _product_id)
    THEN
      SET _response ="The lot size you selected is bigger than the maximum lot size limit for the product. Please adjust your lot size.";
    END IF;
  
    
    IF _lot_priority IS NULL
    THEN
      SELECT priority INTO _lot_priority
        FROM `order_general`
       WHERE id = _order_id;
    END IF;
        
    IF _lot_size IS NULL
    THEN
      SET _response = 'Lot size information can not be found. Please enter the size for a single lot.';
    ELSE
          
--       SET time_zone=(SELECT IF(convert_tz(utc_timestamp(), '+00:00', timezone) 
--                             between concat(year(utc_timestamp()), substring(daylightsaving_starttime,5)) 
--                             and concat(year(utc_timestamp()), substring(daylightsaving_endtime,5)), 
--                         substring(addtime(timezone, '01:00'), 1, 6),
--                         timezone)  
--               FROM company c, employee e
--               WHERE e.id = _dispatcher AND c.id = e.company_id); 
              
      SET _dispatch_time = utc_timestamp();
      
      SET _alias_suffix = 0;
      
        
      IF _alias_prefix IS NULL
      THEN
        SET _alias_prefix = '';
      END IF;

        
      SET _alias_suffix = _alias_suffix + 1;
      SET _alias = CONCAT(_alias_prefix, _alias_suffix);
      
      SELECT uomid INTO _uom_id
        FROM product
    WHERE id = _product_id;

    SET _ratio = null;
    IF EXISTS (SELECT * 
                  FROM order_detail
                  WHERE order_id = _order_id
                    AND source_type = 'product'
                    AND source_id = _product_id
                    AND uomid = _uom_id
                )
    THEN
      SET _ratio = 1;
    ELSE
      SELECT constant INTO _ratio
        FROM uom_conversion u 
        JOIN order_detail o ON o.order_id = _order_id 
          AND o.source_type = 'product' 
          AND o.source_id = _product_id
        WHERE from_id = _uom_id
          AND to_id = o.uomid
          AND method = 'ratio';
          
      IF _ratio IS NULL
      THEN
        SELECT constant INTO _ratio
          FROM uom_conversion u 
          JOIN order_detail o ON o.order_id = _order_id 
                                  AND o.source_type = 'product' 
                                  AND o.source_id = _product_id
         WHERE to_id = _uom_id
           AND from_id = o.uomid
           AND method = 'ratio';  
          
        IF _ratio IS NULL OR _ratio = 0
        THEN
          SET _response = "There is no valid conversion between the unit of measure used in traveler and the unit of measure used in order. Please add conversion between the two Uoms";
        ELSE  
          SET _ratio = 1.00/_ratio;
        END IF;
      END IF;
    END IF;

    IF _ratio IS NOT NULL AND NOT EXISTS (SELECT * FROM order_detail o
                    WHERE o.order_id = _order_id
                      AND o.source_type = 'product'
                      AND o.source_id = _product_id
                      AND o.quantity_requested >= (quantity_in_process + _lot_size*_ratio+quantity_made+quantity_shipped))
    THEN
      SET _response = "You are dispatching more product than requested. Please adjust lot size.";
    END IF;
    ALOOP: WHILE EXISTS (SELECT * FROM lot_status WHERE alias=_alias)
    DO
      IF _alias_suffix = 4294967295 THEN
        SET _response = concat('The alias suffix numbers ran out for prefix ' , _alias_prefix , '. Please select another prefix and dispatch the lots again.');
         
        LEAVE ALOOP;
      END IF;
      

      SET _alias_suffix = _alias_suffix + 1;
      SET _alias = CONCAT(_alias_prefix, _alias_suffix);
         
    END WHILE ALOOP;
       
    IF _response IS NULL OR length(_response) = 0
    THEN
    SET _response = _alias;  
      START TRANSACTION;
      INSERT INTO lot_status(
          alias,
          order_id,
          product_id,
          process_id,
          status,
          start_quantity,
          actual_quantity,
          uomid,
          update_timecode,
          contact,
          priority,
          dispatcher,
          dispatch_time,
          comment
          )
      VALUES
          (
            _alias,
            _order_id,
            _product_id,
            _process_id,
            'dispatched',
            _lot_size,
            _lot_size,
            _uom_id,
            DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
            _lot_contact,
            _lot_priority,
            _dispatcher,
            _dispatch_time,
            _comment  
        );
      SET _lot_id = last_insert_id();
              
      IF _lot_id IS NOT NULL THEN
         
        INSERT INTO lot_history (
              lot_id,
              lot_alias,
              start_timecode,
              end_timecode,
              process_id,
              position_id,
              step_id,
              start_operator_id,
              end_operator_id,
              status,
              start_quantity,
              end_quantity,
              uomid,
              comment
              )
        VALUES (
              _lot_id,
              _alias,
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              DATE_FORMAT(_dispatch_time, '%Y%m%d%H%i%s0'),
              _process_id,
              0,
              0,
              _dispatcher,
              _dispatcher,
              'dispatched',
              _lot_size,
              _lot_size,
              _uom_id,
              _comment
        );       
            

          
  
        UPDATE `order_detail`
           SET quantity_in_process = ifnull(quantity_in_process, 0) +  _lot_size*_ratio
         WHERE order_id=_order_id;
            
        COMMIT;
         
      ELSE
          -- COMMIT;
        ROLLBACK;
        SET _response = "Error encountered when dispatching.";
      END IF;
    END IF;
  END IF;
END IF;
END$

-- procedure start_lot_step
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : start_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for starting a lot at a step
*    Example:
set @_process_id = null;
set @_sub_process_id =null;
set @_position_id =null;
set @_sub_position_id =null;
set @_step_id =null;
  set @_location_id =null;
CALL `start_lot_step`(
                147,
                'PTBF01UB0000000007',
                2,
                1,
                1,
                null,
                null,
                'Step started automatically',
                @_process_id,
                @_sub_process_id,
                @_position_id,
                @_sub_position_id,
                @_step_id,
                @_location_id,
                @_lot_status_n,
                @_step_status_n,
                @_autostart_timecode,
                @_response
              );
              select                 @_process_id,
                @_sub_process_id,
                @_position_id,
                @_sub_position_id,
                @_step_id,
                @_location_id,
                @_lot_status_n,
                @_step_status_n,
                @_autostart_timecode,
                @_response;
*    Log                    :
*    6/1/2018: xdong: adding handling to new step type -- disassemble
*    6/5/2018: xdong: just modified delimiter of the file to be consistant with load_procedures
*	 7/16/2018 peiyu: added an new inout variable _location_id
*    11/28/2018 updated lot_status(added 'done')
*    12/04/2018: xdong: added quantity_status when inserting to lot_history table
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `start_lot_step`$
CREATE PROCEDURE `start_lot_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _check_autostart tinyint(1) unsigned,
  IN _start_quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _comment text,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  INOUT _location_id int(11) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _start_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
  -- doesn't check if operator has access to the step, because for autostart, even the operator
  -- only has access to previous step, this step can still be automaically started when previouse step
  -- is ended by the operator.
  -- start form will check employee access though.
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _result varchar(255);
  DECLARE _step_type varchar(20);
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  
 
  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch identifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);
    
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSEIF _response IS NULL
    THEN
      -- start step under two cases: 1. started by start form (_check_autostart = 0)
      -- 2. auto started after another step ends and called by stored procedure (_check_autostart=1)
      -- 3. hold lot step type always autostart, regardless whether it is configured this way
      IF _check_autostart = 0 OR 
        (_check_autostart > 0 
           AND (_if_autostart > 0 OR _step_type='hold lot')
           AND _lot_status = 'in transit' 
           AND _step_status = 'ended'
        )
      THEN

  
        IF _process_id IS NULL 
          AND _sub_process_id IS NULL 
          AND _position_id IS NULL
          AND _sub_position_id IS NULL
          AND _step_id IS NULL
        THEN  -- new step informaiton wasn't supplied
        
          SET _process_id = _process_id_p;
          SET _sub_process_id = _sub_process_id_n;
          SET _position_id = _position_id_n;
          SET _sub_position_id = _sub_position_id_n;
          SET _step_id = _step_id_n;
        ELSEIF _process_id<=>_process_id_p 
              AND _sub_process_id<=>_sub_process_id_n
              AND _position_id <=>_position_id_n
              AND _sub_position_id <=>_sub_position_id_n
              AND _step_id <=> _step_id_n
        THEN -- new step information was supplied and checked
          SET _response='';
        ELSE
          SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
        END IF;        
         
        IF (_response IS NULL OR length(_response)=0)  
        THEN
          CASE 
          WHEN _step_type in ('consume material', 'disassemble', 'condition')
          THEN
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
			  location_id,
              comment,
              quantity_status
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
			  _location_id,
              _comment,
              'in process'
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'in process';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
					,location_id = _location_id
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF; 
            
         WHEN _step_type='hold lot'
          THEN            
            SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');        
            SET _step_status = 'started';
            IF (_check_autostart > 0)
            THEN
              SET _comment=CONCAT('Batch ', _lot_alias, ' has been held due to the result from previous step.');
            END IF;
            INSERT INTO lot_history
            (
              lot_id,
              lot_alias,
              start_timecode,
              process_id,
              sub_process_id,
              position_id,
              sub_position_id,
              step_id,
              start_operator_id,
              status,
              start_quantity,
              uomid,
              equipment_id,
              device_id,
			  location_id,
              comment
            )
            VALUES (
              _lot_id,
              _lot_alias,
              _start_timecode,
              _process_id,
              _sub_process_id,
              _position_id,
              _sub_position_id,
              _step_id,
              _operator_id,
              _step_status,
              _start_quantity,
              _uomid,
              _equipment_id,
              _device_id,
			  _location_id,
              _comment
            ); 
            IF row_count() > 0 THEN
              SET _lot_status = 'hold';
              
              UPDATE lot_status
                SET status = _lot_status
                    ,actual_quantity = _start_quantity
                    ,update_timecode = _start_timecode
					,location_id = _location_id
                    ,comment=_comment
              WHERE id=_lot_id;
            ELSE
              SET _response="Error when recording step start into batch history.";
            END IF;             

         -- END IF;
         END CASE;
        END IF;


      END IF;
    END IF;
  END IF;
END$


/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : end_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for ending a lot at a step
*    Log                    :
*    6/5/2018: xdong: adding handling to new step type -- disassemble
*	 8/2/2018: peiyu: added an new variable location_id and added to call 'start_lot_step' 
*	 11/28/2018: peiyu: added status 'done' to lot_status enum; 
*                update lot_status to 'done' when the workflow completed 
*                and then update quantity_made and quantity_in_process in order_detail when product_made of current step is true (in process_step). 
*  12/04/2018: Xueyan Dong: corrected the logic around identifying last step of the workflow. Added logic to update quantities in order_detail in
*                           case of batch quantity change.
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `end_lot_step`$
CREATE PROCEDURE `end_lot_step`(
    IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _start_timecode char(15),
  IN _operator_id int(10) unsigned,
  IN _end_quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _result_comment text,  -- for long text result or comment
  IN _location_id int(11) unsigned, 
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _autostart_timecode char(15),  
  OUT _response varchar(255)
)
BEGIN
-- doesn't check employee access to the step. End form will check employee access though.
  DECLARE _process_id_p int(10) unsigned;
  DECLARE _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _result text;
  DECLARE _end_timecode char(15);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _product_made tinyint(1) unsigned;
  DECLARE _quantity_status, _quantity_status_p ENUM('in process', 'made', 'shipped');
  DECLARE _order_id int(10) unsigned;
  DECLARE _product_id int(10) unsigned;
  DECLARE _line_num smallint(5) unsigned;
  DECLARE _start_quantity decimal(16,4) unsigned;
  DECLARE _rework_limit smallint(2) unsigned;
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The batch you supplied does not exist in database";
    ELSE
      -- check position information
--       SELECT process_id,
--              sub_process_id,
--              position_id,
--              sub_position_id,
--              step_id,
--              uomid,
--              start_quantity,
--              quantity_status
--         INTO _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p, _step_id_p, _uomid, _start_quantity, _quantity_status_p
--         FROM lot_history
--        WHERE lot_id = _lot_id
--          AND start_timecode = _start_timecode
--          AND status IN ('started', 'restarted') 
--          AND end_timecode IS NULL
--        ;
   SELECT process_id,
             sub_process_id,
             position_id,
             sub_position_id,
             step_id,
             uomid,
             actual_quantity,
             quantity_status,
             order_id,
             product_id,
             order_line_num,
             lot_status
        INTO _process_id_p, 
             _sub_process_id_p, 
             _position_id_p, 
             _sub_position_id_p, 
             _step_id_p, 
             _uomid, 
             _start_quantity, 
             _quantity_status_p,
             _order_id,
             _product_id,
             _line_num,
             _lot_status
        FROM view_lot_in_process
       WHERE id = _lot_id;

         
         
      IF _process_id_p IS NULL 
      THEN
        SET _response = "The batch is currently not in a workflow step.";
      ELSE
        IF _process_id IS NOT NULL AND _process_id != _process_id_p
        THEN
          SET _response = "The batch is in a different workflow than you supplied.";
        ELSEIF _position_id IS NOT NULL AND _position_id!= _position_id_p
        THEN
          SET _response = concat("The batch is at a different position " , _position_id_p , " than you supplied.");
        ELSEIF _step_id IS NOT NULL AND _step_id != _step_id_p
        THEN
          SET _response = "The batch is at a different step than you supplied.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id_p IS NULL
        THEN
          SET _response = "The batch is not in a sub workflow as you indicated.";
        ELSEIF _sub_process_id IS NOT NULL AND _sub_process_id != _sub_process_id_p 
        THEN
          SET _response = "The batch is in a different sub workflow than you supplied.";
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id IS NULL
        THEN
          SET _response = concat("The batch is not in the position " , _sub_position_id , " in sub workflow as you indicated.");
        ELSEIF _sub_position_id IS NOT NULL AND _sub_position_id!=_sub_position_id_p
        THEN
          SET _response = "The batch is at a different position in sub workflow than you indicated.";
        ELSE
          SET _process_id = _process_id_p;
          SET _position_id = _position_id_p;
          SET _step_id = _step_id_p;
          
          IF _sub_process_id_p IS NOT NULL
          THEN
            SET _sub_process_id = _sub_process_id_p;
          END IF;
          
          IF _sub_position_id_p IS NOT NULL
          THEN
            SET _sub_position_id = _sub_position_id_p;
          END IF;
          
          -- check approver information and product_made information
          IF _sub_process_id IS NULL
          THEN
           SELECT need_approval, approve_emp_usage, approve_emp_id, product_made
             INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made
              FROM process_step
             WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
           ;
          ELSE
           SELECT need_approval, approve_emp_usage, approve_emp_id, product_made
             INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made
              FROM process_step
             WHERE process_id = _sub_process_id
               AND position_id = _sub_position_id
               AND step_id = _step_id
             ;
          END IF;
          
          CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
          
          IF _response IS NULL OR length(_response)=0
          THEN
            -- get step type
            SELECT st.name
              INTO _step_type
              FROM step s, step_type st
            WHERE s.id =_step_id
              AND st.id =s.step_type_id;
			
            IF _product_made = 1
            THEN
              SET _quantity_status = 'made';
            ELSE
              SET _quantity_status = 'in process';
            END IF;
            
            SET _end_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            -- note that this sp currently only handle below four step types
            IF _step_type in ('consume material', 'disassemble', 'condition', 'hold lot')
            THEN
              SET _step_status = 'ended';
              
              -- mark the end for current step in lot_history table
              UPDATE lot_history
                 SET end_timecode = _end_timecode
                  , end_operator_id = _operator_id
                  , status = _step_status
                  , end_quantity = _end_quantity
                  , uomid = _uomid
                  , approver_id = _approver_id
                  , result = _short_result
                  , comment = _result_comment
                  , quantity_status = _quantity_status
              WHERE lot_id = _lot_id
                AND start_timecode = _start_timecode
                AND status IN ('started', 'restarted')
                AND end_timecode IS NULL;
            
            IF row_count() > 0 THEN -- look forward to next step
                -- get next position, if Null, Lot Done
               CALL get_next_step_for_lot(_lot_id, 
                                    _lot_alias, 
                                    'in transit', -- before knowing whether current step is the last, lot status is always in transit after step ending
                                    _process_id_p,
                                    _sub_process_id_p,
                                    _position_id_p,
                                    _sub_position_id_p,
                                    _step_id_p,
                                    _short_result,
                                    _sub_process_id_n,
                                    _position_id_n,
                                    _sub_position_id_n,
                                    _step_id_n,
                                    _step_type,
                                    _rework_limit,
                                    _if_autostart,
                                    _response);
                
            IF _position_id_n IS NULL THEN  -- if no next step
              SET _lot_status = 'done';
            ELSE
              SET _lot_status = 'in transit';
                        -- SET _quantity_status = 'in process'; default is in process
            END IF;
            
            UPDATE lot_status
              SET status = _lot_status
                  ,actual_quantity = _end_quantity
                  ,update_timecode = _end_timecode
                  ,comment = _result_comment
                  ,quantity_status = _quantity_status
            WHERE id=_lot_id;


            -- if end_quantity changed from start_quantity, adjust quantities in order_detail. quantity_shipped will never need adjust, 
            -- because once product is shipped to customer, the quantity record should not change
            IF _start_quantity != _end_quantity
            THEN
              IF _quantity_status_p = 'in process' THEN
                UPDATE order_detail
                   SET quantity_in_Process = quantity_in_process - _start_quantity + _end_quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;
              ELSEIF _quantity_status_p = 'made' THEN
                 UPDATE order_detail
                   SET quantity_made = quantity_made - _start_quantity + _end_quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;             
              END IF;
            END IF;           
            
            -- check product_made flag in process_step table, if 1, update quantity_made, quantity_in_process in order_detail table 
            
            IF _product_made = 1 Then
              UPDATE order_detail
              SET quantity_made = quantity_made + _end_quantity
                ,quantity_in_process = quantity_in_process - _end_quantity
              WHERE order_id= _order_id
              And source_id = _product_id
              And source_type = 'product'
              And line_num = _line_num;
            End IF;
                
                
            SET _process_id_p = null;
            SET _sub_process_id_n = null;
            SET _position_id_n = null;
            SET _sub_position_id_n = null;
            SET _step_id_n = null;
                  
                
            IF _lot_status not in ('done') Then
              CALL `start_lot_step`(
                _lot_id,
                _lot_alias,
                _operator_id,
                1,
                _end_quantity,
                null,
                null,
                'Step started automatically',
                _process_id_p,
                _sub_process_id_n,
                _position_id_n,
                _sub_position_id_n,
                _step_id_n,
                _location_id,
                _lot_status_n,
                _step_status_n,
                _autostart_timecode,
                _response
              );
            IF _autostart_timecode IS NOT NULL
            THEN
              SET _process_id = _process_id_p;
              SET _sub_process_id = _sub_process_id_n;
              SET _position_id = _position_id_n;
              SET _sub_position_id = _sub_position_id_n;
              SET _step_id = _step_id_n;
              SET _lot_status = _lot_status_n;
              SET _step_status = _step_status_n;
            END IF;
          END IF;
          ELSE
            SET _response = "Error encountered when update batch history information.";
          END IF;             
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$


-- procedure ship_lot
DROP PROCEDURE IF EXISTS `ship_lot`$
CREATE PROCEDURE `ship_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _ship_timecode char(15),
  IN _shipper_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _contact_id int(10) unsigned, 
  IN _comment text,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE _ship_time datetime;
  DECLARE _process_id int(10) unsigned;
  DECLARE _sub_process_id int(10) unsigned;
  DECLARE _position_id int(5) unsigned;
  DECLARE _sub_position_id int(5) unsigned;
  DECLARE _step_id int(10) unsigned;  
  
  IF _lot_id IS NULL AND (_lot_alias IS NULL OR length(_lot_alias)=0) THEN
    SET _response = "Lot identifier is missing. Please supply a lot.";
  ELSE
    IF _lot_id IS NULL
    THEN
      SELECT id
        INTO _lot_id
        FROM lot_status
       WHERE alias = _lot_alias;
    END IF;
    
    IF _lot_alias IS NULL
    THEN
      SELECT alias
        INTO _lot_alias
        FROM lot_status
       WHERE id = _lot_id;
    END IF;
    
    IF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) THEN
      SET _response = "The lot you supplied does not exist in database";
    ELSE
      SET _ship_time = str_to_date(_ship_timecode, '%Y%m%d%H%i%s0' );
      
      START TRANSACTION;
      
      INSERT INTO inventory (
        source_type,
        pd_or_mt_id,
        supplier_id,
        lot_id,
        in_order_id,
        original_quantity,
        actual_quantity,
        uom_id,
        manufacture_date,
        expiration_date,
        arrive_date,
        recorded_by,
        contact_employee,
        comment
        )
      SELECT 'manufactured',
             l.product_id,
             0,
             l.id,
             l.order_id,
             _quantity,
             _quantity,
             l.uomid,
             _ship_time,
             if(p.lifespan > 0, date_add(_ship_time, INTERVAL p.lifespan DAY), NULL),
             _ship_time,
             _shipper_id,
             _contact_id,
             _comment
        FROM lot_status l, product p
       WHERE l.id=_lot_id
         AND p.id = l.product_id;
         
      IF row_count() > 0 THEN
        SET _inventory_id = last_insert_id();
        
        UPDATE `order` o, lot_status l
           SET quantity_made = quantity_made + _quantity,
               quantity_in_process = if(quantity_in_process < _quantity, 0, quantity_in_process - _quantity)
         WHERE l.id = _lot_id
           AND l.order_id = o.id;
        
        IF row_count() >= 0 THEN
        -- update lot history
          CALL end_lot_step(
            _lot_id,
            _lot_alias,
            _ship_timecode,
            _shipper_id,
            _quantity,
            null,
            null,
            _process_id,
            _sub_process_id,
            _position_id,
            _sub_position_id,
            _step_id,
            _response);
            
          IF _response IS NULL THEN
            COMMIT;
          ELSE
            ROLLBACK;
          END IF;
        ELSE
          ROLLBACK;
        END IF;
      ELSE
        ROLLBACK;
        SET _response = concat('Database error encountered when shipping lot ', _lot_id , ' to warehouse');
      END IF;
      
    END IF;
    
  END IF;
END$


-- procedure report_process_cycletime
DROP PROCEDURE IF EXISTS `report_process_cycletime`$
CREATE PROCEDURE `report_process_cycletime`(
  IN _process_id int(10) unsigned,
  IN _product_id int(10) unsigned
)
BEGIN


    
  IF _process_id IS NOT NULL AND _product_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_cycletime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      step_id int(10) unsigned,
      step varchar(255),
      step_type varchar(20),
      description varchar(255),
      min_time int(10) unsigned,
      max_time int(10) unsigned,
      average_time int(10) unsigned,
      average_yield tinyint(2) unsigned,
      prev_step_pos varchar(5),
      next_step_pos varchar(5),
      false_step_pos varchar(5),
      rework_limit smallint(2) unsigned 
    );

    -- collect step information for steps/non-subprocess in the flow
    INSERT INTO process_cycletime
    SELECT p.position_id,
          null,
          p.step_id,
          s.name,
          t.name,
          if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
          s.mintime,
          s.maxtime,
          null,
          null,
          p.prev_step_pos,
          p.next_step_pos,
          p.false_step_pos,
          p.rework_limit
      FROM process_step p, step s, step_type t
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      ;
    
    -- collect step information for steps in sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_cycletime
    SELECT  p.position_id,
            concat('s', p1.position_id),
            p1.step_id,
            s.name,
            t.name,
            if(length(s.description)>250, concat(substring(s.description, 1, 250),"..."), substring(s.description, 1, 250)),
            s.mintime,
            s.maxtime,
            null,
            null,
            concat('s',p1.prev_step_pos),
            concat('s',p1.next_step_pos),
            concat('s',p1.false_step_pos),
            p1.rework_limit

      FROM process_step p, process_step p1, step s, step_type t
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      ;
      CREATE TEMPORARY TABLE IF NOT EXISTS process_actualtime 
    (
      position_id int(5) unsigned,
      sub_position_id int(5) unsigned,
      through_count int(5) unsigned,
      total_time int(10) unsigned,
      average_yield tinyint(2) unsigned
    );    
    
    INSERT INTO process_actualtime
    SELECT position_id,
           sub_position_id,
           sum(if(h.status in ('error', 'stopped'), 0, 1)),
           sum(timestampdiff(minute, str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' ), str_to_date(h.end_timecode, '%Y%m%d%H%i%s0') )),
           avg(100 * h.end_quantity/h.start_quantity)
      FROM lot_status l, lot_history h 
     WHERE l.product_id = _product_id
       AND l.process_id = _process_id
       AND h.lot_id = l.id
       AND h.status not in ('dispatched', 'started', 'restarted')
       AND h.start_quantity != 0
     GROUP BY position_id, sub_position_id;
    
    UPDATE process_cycletime pc, process_actualtime pa
       SET pc.average_time =  pa.total_time/pa.through_count
          ,pc.average_yield = pa.average_yield
     WHERE pc.position_id = pa.position_id
       AND pc.sub_position_id <=> pc.sub_position_id;
       
    SELECT position_id,
           sub_position_id,
           step_id,
           step,
           step_type,
           description,
           min_time,
           max_time,
           average_time,
           average_yield,
           prev_step_pos,
           next_step_pos,
           false_step_pos,
           rework_limit
      FROM process_cycletime
   ORDER BY position_id, sub_position_id
  ;

    DROP TABLE process_cycletime;
    DROP TABLE process_actualtime;
  END IF;
END$

-- procedure report_product_quantity
DROP PROCEDURE IF EXISTS `report_product_quantity`$
CREATE PROCEDURE `report_product_quantity`(
  IN _product_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _product_id IS NOT NULL
  THEN

  
    
    
    SELECT name INTO _pname
      FROM product
      WHERE id = _product_id;
    
    IF _pname IS NOT NULL
    THEN

      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      WHERE o.order_type in ('inventory', 'customer')
        AND od.source_type='product'
        AND od.source_id =_product_id ;
    END IF;
  
  END IF;

  

END$

-- procedure report_lot_status
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_lot_status.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    1/25/2019: Peiyu Ge: added selection of three more field, step, line_num, quantity_status.				
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_lot_status`$
CREATE PROCEDURE `report_lot_status`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  

 SELECT l.product_id,
        p.name as product_name,
        l.order_id,
        o.ponumber,
        o.client_id,
        c.name as client_name,
        l.process_id,
        pr.name as process_name,
        l.status,
        l.start_quantity,
        l.actual_quantity,
        l.uomid,
        u.name as uom_name,
        l.contact,
        concat(e.firstname, ' ', e.lastname)as contact_name,
        l.priority,-- pri.name as priority,
        get_local_time(l.dispatch_time) as dispatch_time,
        get_local_time(l.output_time) as output_time,
        l.comment,
        s.name as step,
        l.order_line_num,
        l.quantity_status,
        if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step
 
 FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general o ON o.id = l.order_id
           LEFT JOIN product p ON p.id = l.product_id
           LEFT JOIN process pr ON pr.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e2 ON e2.id = l.dispatcher
           LEFT JOIN employee e ON e.id = l.contact
           LEFT JOIN client c ON c.id = o.client_id
           LEFT JOIN priority pri ON pri.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
           LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h.position_id = 0, 1, h.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
           WHERE l.id <=> _lot_id;
 -- FROM lot_status l, product p , `order_general` o , client c, process pr, employee e, uom u
-- WHERE l.id <=> _lot_id
--   AND p.id = l.product_id
-- AND o.id = l.order_id
--   AND c.id = o.client_id
--   AND pr.id = l.process_id
--   AND e.id = l.contact
--   AND u.id = l.uomid
 

 END$

-- procedure report_lot_history
DROP PROCEDURE IF EXISTS `report_lot_history`$
CREATE PROCEDURE `report_lot_history`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20)
)
BEGIN
  IF _lot_id IS NULL
  THEN
    SELECT id INTO _lot_id
      FROM lot_status
     WHERE alias = _lot_alias;
  END IF;
  
 CREATE TEMPORARY TABLE IF NOT EXISTS lot_history_report
 (
    start_time datetime,
    end_time datetime,
    process_id int(10) unsigned,
    process_name varchar(255),
    sub_process_id int(10) unsigned,
    sub_process_name varchar(255),
    position_id int(5) unsigned,
    sub_position_id int(5) unsigned,
    step_id int(10) unsigned,
    step_name varchar(255),
    step_type varchar(20),
    start_operator_id int(10) unsigned,
    start_operator_name varchar(60),
    end_operator_id int(10) unsigned,
    end_operator_name varchar(60),
    status varchar(20),
    start_quantity decimal(16,4) unsigned,
    end_quantity decimal(16,4) unsigned,
    uomid smallint(3) unsigned,
    uom_name  varchar(20),
    equipment_id int(10) unsigned,
    equipment_name varchar(255),
    device_id int(10) unsigned,
    approver_id int(10) unsigned,
    approver_name varchar(60),
    result text,
    comment text
 );
 
 INSERT INTO lot_history_report
 SELECT get_local_time(str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' )),
        get_local_time(str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' )),
        l.process_id,
        p.name,
        sub_process_id,
        null,
        position_id,
        sub_position_id,
        l.step_id,
        s.name,
        st.name,
        l.start_operator_id,
        concat(e.firstname, ' ', e.lastname),
        l.end_operator_id,
        concat(e2.firstname, ' ', e2.lastname),
        l.status,
        l.start_quantity,
        l.end_quantity,
        l.uomid,
        u.name,
        l.equipment_id,
        null,
        l.device_id,
        l.approver_id,
        null,
        CASE 
          WHEN st.name='condition' AND l.result='true' THEN 'Pass'
          WHEN st.name='condition' AND l.result='false' THEN 'Fail'
          ELSE l.result
        END,
        l.comment
  FROM lot_history l
  LEFT JOIN process p ON p.id = l.process_id
  LEFT JOIN step s ON  s.id = l.step_id 
  LEFT JOIN step_type st ON st.id=s.step_type_id
  LEFT JOIN employee e ON e.id = l.start_operator_id
  LEFT JOIN employee e2 ON e2.id = l.end_operator_id
  LEFT JOIN uom u ON u.id = l.uomid
 WHERE l.lot_id <=> _lot_id
 ORDER BY start_timecode
;

 UPDATE lot_history_report
   SET result=CONCAT('Reposition to --> position ',
   substring_index(right(result,length(result)-length(substring_index(result, ',', 1))-1),',',1),
   ', Step ',
   (SELECT NAME FROM step WHERE id=substring_index(result, ',', -1)))
  WHERE step_type='reposition';
  
 UPDATE lot_history_report l, process p
    SET l.sub_process_name = p.name
  WHERE l.sub_process_id IS NOT NULL
    AND p.id = l.sub_process_id
 ;
 
 UPDATE lot_history_report l, equipment eq
    SET l.equipment_name = eq.name
  WHERE l.equipment_id IS NOT NULL
    AND eq.id = l.equipment_id
 ;
 
 UPDATE lot_history_report l, employee e
    SET l.approver_name = concat(e.firstname, ' ', e.lastname)
  WHERE l.approver_id IS NOT NULL
    AND e.id = l.approver_id
 ;
 
 SELECT 
    start_time,
    end_time,
    process_id,
    process_name,
    sub_process_id,
    sub_process_name,
    position_id,
    sub_position_id,
    step_id,
    step_name,
    start_operator_id,
    start_operator_name,
    end_operator_id,
    end_operator_name,
    status,
    start_quantity,
    end_quantity,
    uomid,
    uom_name,
    equipment_id,
    equipment_name,
    device_id,
    approver_id,
    approver_name,
    result,
    comment
  FROM lot_history_report;
  DROP TABLE lot_history_report;
 END$
 
-- procedure issue_feedback
DROP PROCEDURE IF EXISTS `issue_feedback`$
CREATE PROCEDURE `issue_feedback`(
  IN _employee_id int(10) unsigned,
  INOUT _feedback_id int(10) unsigned,
  IN _subject varchar(255),
  IN _contact_info varchar(255),
  IN _note text,
  OUT _response varchar(255)
)
BEGIN

  
  IF _employee_id IS NULL OR NOT EXISTS (SELECT * FROM employee WHERE id = _employee_id)
  THEN
    SET _response='The employee who is issuing this feedback does not exist in database.'; 
  ELSE
        
    IF _feedback_id IS NULL
    THEN
      INSERT INTO feedback 
      (
        `create_time`,
        `noter_id` ,
        `contact_info` ,
        `state` ,
        `subject` ,
        `note` 
      )
      VALUES (
        now(),
        _employee_id,
        _contact_info,
        'issued',
        _subject,
        _note
      );
      SET _feedback_id = last_insert_id();
    
    ELSE
      UPDATE feedback
         SET contact_info = _contact_info,
             last_noter_id = _employee_id,
             last_note_time = now(),
             subject=_subject,
             note=_note
       WHERE id = _feedback_id;
    END IF;
  END IF;
END$

-- procedure report_process_bom_total
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_process_bom_total.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    8/30/2018: Peiyu Ge: added if_persistent to output	
*    11/02/2018: Xdong: added persistent ingredients into the bom			
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `report_process_bom_total`$
CREATE PROCEDURE `report_process_bom_total`(
  IN _process_id int(10) unsigned
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

    
  IF _process_id IS NOT NULL
  THEN

    CREATE TEMPORARY TABLE IF NOT EXISTS process_bom 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned
    ) DEFAULT CHARSET=utf8;
  
    
    -- collect recipe and ingredient information from steps in the flow
    INSERT INTO process_bom
    SELECT 
          i.source_type ,
          i.ingredient_id,
          ' ',
          i.quantity,
          i.uom_id
      FROM process_step p, step s, step_type t, recipe r, ingredients i
    WHERE process_id = _process_id
      AND if_sub_process = 0
      AND s.id = p.step_id
      AND s.step_type_id = t.id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id ;
    
    -- collect recipe and ingredient information from sub process in the flow. 
    -- Note that we only deal with one level sub process, e.g. if the sub process contains sub process, we will not see.
    INSERT INTO process_bom
    SELECT  
            i.source_type,
            i.ingredient_id,
            ' ',
            i.quantity,
            i.uom_id
      FROM process_step p, process_step p1, step s, step_type t, recipe r, ingredients i
    WHERE p.process_id = _process_id
      AND p.if_sub_process = 1
      AND p.step_id = p1.process_id
      AND s.id = p1.step_id
      AND t.id = s.step_type_id
      AND t.name = 'consume material'
      AND r.id = s.recipe_id
      AND i.recipe_id = r.id;
 

      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_total 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      ingredient_name varchar(255),
      quantity decimal(16,4) unsigned,
      uomid smallint(3) unsigned,
      uom varchar(20),
      alert_quantity decimal(16,4) unsigned,
      description text,
	  if_persistent boolean
    ) DEFAULT CHARSET=utf8; 
    
     INSERT INTO process_bom_total 
     (source_type,
     ingredient_id,
     quantity,
     uomid,
     uom,
	 if_persistent)
    SELECT source_type,
           ingredient_id,
           sum(quantity),
           pb.uomid,
           u.name,
		   1
      FROM process_bom pb, uom u
     WHERE u.id = pb.uomid
     GROUP BY source_type, ingredient_id, pb.uomid;
     
    DROP TABLE process_bom;
    
    UPDATE process_bom_total pb, material m
       SET pb.ingredient_name = m.name,
           pb.alert_quantity = m.alert_quantity,
           pb.description = m.description,
           pb.if_persistent =m.if_persistent
     WHERE pb.source_type = 'material'
       AND pb.ingredient_id = m.id;
       
    UPDATE process_bom_total pb, product p
       SET pb.ingredient_name = p.name,
           pb.description = p.description
     WHERE pb.source_type = 'product'
       AND pb.ingredient_id = p.id;
    
      CREATE TEMPORARY TABLE IF NOT EXISTS process_bom_temp 
    (
      source_type varchar(20),
      ingredient_id int(10) unsigned,
      unassigned_quantity_raw varchar(31),
      assigned_quantity_show varchar(31),
      unassigned_quantity decimal(16,4) unsigned,
      unassigned_uomid smallint(3) unsigned,
      ifalert tinyint(1) unsigned
    ) DEFAULT CHARSET=utf8;  
    
    INSERT INTO process_bom_temp
    (source_type, ingredient_id, unassigned_quantity_raw, assigned_quantity_show, ifalert)
    SELECT source_type,
           ingredient_id,
           ifnull((SELECT concat(sum(inv.actual_quantity), ',', max(inv.uom_id))
              FROM inventory inv 
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND 
                (EXISTS (SELECT * 
                           FROM `order_general` o, order_state_history os
                          WHERE o.id = inv.in_order_id
                            AND o.order_type = 'inventory'
                            AND os.order_id = o.id
                            AND os.state='produced'
                            ) 
                 OR
                  (inv.in_order_id IS NULL))), 0)  ,
           ifnull((SELECT concat(format(sum(inv.actual_quantity),1), ' ', max(u3.name))
              FROM inventory inv LEFT JOIN uom u3 ON u3.id = inv.uom_id
            WHERE inv.source_type = pb.source_type
              AND inv.pd_or_mt_id = pb.ingredient_id
              AND EXISTS (SELECT *
                            FROM `order_general` o
                           WHERE o.id = inv.in_order_id
                              AND o.order_type in( 'customer','inventory')
                              AND NOT EXISTS (SELECT *
                                                FROM order_state_history os
                                               WHERE os.order_id = o.id
                                                 AND os.state = 'produced'))),0),
             0
     
      FROM process_bom_total pb ;
      
    UPDATE process_bom_temp
       SET unassigned_quantity = CAST(LEFT(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')) AS DECIMAL),
           unassigned_uomid =SUBSTRING(unassigned_quantity_raw, INSTR(unassigned_quantity_raw, ',')+1)
     WHERE unassigned_quantity_raw != '0';
 
     UPDATE process_bom_temp
       SET unassigned_quantity = 0,
           unassigned_uomid =0
     WHERE unassigned_quantity_raw = '0';
    
    -- unassigned inventory is empty or below alert level will raise the ifalert flag
    UPDATE process_bom_temp pt, process_bom_total pb
      SET pt.ifalert =if(pt.unassigned_quantity=0 OR convert_quantity(pt.unassigned_quantity, pt.unassigned_uomid, pb.uomid)<pb.alert_quantity, 1, 0)
     WHERE pb.source_type = pt.source_type
       AND pb.ingredient_id = pt.ingredient_id;
   
    SELECT pt.source_type,
           pt.ingredient_id,
           pt.ingredient_name
           ,pt.quantity
           ,pt.uomid
           ,pt.uom
           ,pt.alert_quantity
           ,pt.description
           ,pb.unassigned_quantity
           ,pb.unassigned_uomid
           ,u.name AS unassigned_uom
           ,pb.assigned_quantity_show
           ,pb.ifalert
		   ,pt.if_persistent
           FROM process_bom_total pt 
           JOIN process_bom_temp pb ON pt.source_type = pb.source_type AND pt.ingredient_id = pb.ingredient_id
           LEFT JOIN uom u ON u.id = pb.unassigned_uomid;
    
    DROP TABLE process_bom_total;
    DROP TABLE process_bom_temp;
  END IF;
  
END$

-- procedure select_step_details
DROP PROCEDURE IF EXISTS `select_step_details`$
CREATE PROCEDURE `select_step_details`(
  IN _step_id int(10) unsigned
)
BEGIN
  SELECT s.name AS step_name,
         s.step_type_id,
         st.name as step_type_name,
         s.version,
         s.state,
         s.eq_usage,
         s.eq_id,
         IF (s.eq_usage='equipment',
             (SELECT eq.name FROM equipment eq WHERE eq.id =s.eq_id ),
             (SELECT eqg.name FROM equipment_group eqg WHERE eqg.id = s.eq_id)) AS eq_name,
         s.emp_usage,
         s.emp_id,
         IF (s.emp_usage = 'employee',
             (SELECT concat(e2.firstname, ' ', e2.lastname) FROM employee e2 WHERE e2.id = s.emp_id),
             (SELECT eg2.name FROM employee_group eg2 WHERE eg2.id = s.emp_id)) AS emp_name,
         s.recipe_id,
         s.mintime,
         s.maxtime,
         s.description,
         s.comment AS step_comment,
         s.para1,
         s.para2,
         s.para3,
         s.para4,
         s.para5,
         s.para6,
         s.para7,
         s.para8,
         s.para9,
         s.para10,
         r.name as recipe_name,
         r.exec_method,
         r.contact_employee,
         (SELECT concat(e3.firstname, ' ', e3.lastname) FROM employee e3 WHERE e3.id = r.contact_employee) AS contact_employee_name,
         r.instruction,
         r.diagram_filename,
         r.comment AS recipe_comment
    FROM step s 
         LEFT JOIN recipe r ON r.id = s.recipe_id
         LEFT JOIN step_type st ON st.id = s.step_type_id
   WHERE s.id = _step_id
  ;
END$

-- procedure get_next_step_for_lot
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : load_procedures.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    11/28/2018 updated lot_status(added 'done')					
*/
DROP PROCEDURE IF EXISTS `get_next_step_for_lot`$
CREATE PROCEDURE `get_next_step_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  IN _process_id int(10) unsigned,
  IN _sub_process_id_p int(10) unsigned,
  IN _position_id_p int(5) unsigned,
  IN _sub_position_id_p int(5) unsigned,
  IN _step_id_p int(10) unsigned,
  IN _result varchar(255),
  OUT _sub_process_id_n int(10) unsigned,
  OUT _position_id_n int(5) unsigned,
  OUT _sub_position_id_n int(5) unsigned,
  OUT _step_id_n int(10) unsigned,
  OUT _step_type varchar(20),
  OUT _rework_limit smallint(2) unsigned,
  OUT _if_autostart tinyint(1) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _step_type_p varchar(20);
  DECLARE _sub_process_id_str VARCHAR(10);
  DECLARE _sub_position_id_str VARCHAR(10);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSE
 
    
          
    IF _lot_status IN ('dispatched', 'in transit')
    THEN      
      
      SELECT st.name
        INTO _step_type_p
        FROM step s, step_type st
       WHERE s.id=_step_id_p
         AND st.id=s.step_type_id;
      
 
      CASE
      WHEN _step_type_p='reposition' THEN
        -- _result has all next step information in the format: sub_process_id_n,position_id_n,sub_position_id_n,step_id_n
        SET _sub_process_id_str=substring_index(_result,',',1);
        SET _sub_process_id_n=if(length(_sub_process_id_str)>0, _sub_process_id_str, null);

        SET _step_id_n=substring_index(_result,',',-1);     
        SET _position_id_n=substring_index(right(_result,length(_result)-length(_sub_process_id_str)-1),',',1);
        
        SET _sub_position_id_str=substring_index(left(_result, length(_result)-length(_step_id_n)-1),',',-1);
        SET _sub_position_id_n=if(length(_sub_position_id_str)>0, _sub_position_id_str, null);
        
        IF _sub_process_id_n IS NOT NULL AND _sub_position_id_n IS NOT NULL
        THEN
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _sub_process_id_n
            AND position_id = _sub_position_id_n
            AND step_id=_step_id_n;    
        ELSE
          SELECT rework_limit,
                  if_autostart
            INTO  _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n
            AND step_id=_step_id_n; 
        END IF;
      ELSE
        SET _result =substring(ifnull(_result, 'T'), 1, 1);
        IF _sub_process_id_p IS NOT NULL AND _response IS NULL THEN  
        -- the lot was in a sub process
          SELECT if(_result = "F" AND st.name='condition', ps.false_step_pos, ps.next_step_pos)
            INTO _sub_position_id_n        
            FROM process_step ps, step s, step_type st
          WHERE ps.process_id=_sub_process_id_p
            AND ps.position_id = _sub_position_id_p
            AND ps.step_id = s.id
            AND st.id = s.step_type_id;
    
          IF _sub_position_id_n IS NULL THEN  -- the lot just finished the sub process it was in
            
            SELECT if(_result="F" AND st.name='condition', ps0.false_step_pos,ps0.next_step_pos )
              INTO _position_id_n
              FROM process_step ps0, step s, step_type st
            WHERE ps0.process_id = _process_id
              AND ps0.position_id = _position_id_p
              AND ps0.step_id = s.id
              AND st.id = s.step_type_id;
                
            SELECT step_id,
                  if_sub_process,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _if_sub_process, _rework_limit,_if_autostart
              FROM process_step
            WHERE process_id = _process_id
              AND position_id = _position_id_n;
                
            IF _if_sub_process = 1 THEN  
              -- next step is a process, collect information
              
              SET _sub_process_id_n = _step_id_n;
              
              SELECT step_id,
                    position_id,
                    rework_limit,
                    if_autostart
                INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
                FROM process_step
              WHERE process_id = _sub_process_id_n
                AND position_id = (SELECT min(position_id) 
                                    FROM process_step 
                                    WHERE process_id = _sub_process_id_n);
                
            END IF;
          ELSE  -- next step is within the same sub process, collect information
            SET _position_id_n = position_id_p;
            SET _sub_process_id_n = _sub_process_id_p;
            
            SELECT step_id,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _rework_limit, _if_autostart
              FROM process_step
            WHERE process_id=_sub_process_id_n
              AND position_id = _sub_position_id_n;
          END IF;
            
        ELSE
          
          -- the lot was not in a sub process
          IF _position_id_p =0
          THEN
            SELECT min(position_id)
              INTO _position_id_n
              FROM process_step
            WHERE process_id=_process_id;
          ELSE    
            SELECT if(_result = "F" AND st.name = 'condition', ps.false_step_pos,ps.next_step_pos )
              INTO _position_id_n           
              FROM process_step ps, step s, step_type st
            WHERE ps.process_id=_process_id
              AND ps.position_id =_position_id_p
              AND ps.step_id = s.id
              AND st.id = s.step_type_id;   
          END IF;
          -- Select 'position'||ifnull(_position_id_p,_result) ;
          SELECT step_id,
                if_sub_process,
                rework_limit,
                if_autostart
            INTO _step_id_n, _if_sub_process, _rework_limit, _if_autostart
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id_n; 
              
          IF _if_sub_process = 1 THEN  
          -- next step is a process, collect information
            
            SET _sub_process_id_n = _step_id_n;
            
            SELECT step_id,
                  position_id,
                  rework_limit,
                  if_autostart
              INTO _step_id_n, _sub_position_id_n, _rework_limit, _if_autostart
              FROM process_step
            WHERE process_id = _sub_process_id_n
              AND position_id = (SELECT min(position_id)
                                  FROM process_step
                                  WHERE process_id = _sub_process_id_n
                                )
            ;
              
          END IF;           
        END IF;
      END CASE;
          
     SELECT st.name INTO _step_type
     FROM step s, step_type st
     WHERE st.id = s.step_type_id
       AND s.id = _step_id_n;
         

    END IF;  

          
  END IF;

 END$
 
 -- procedure report_dispatch_history
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_dispatch_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*	 1/14/2019: Peiyu Ge: selected three more fields, line number, quantity_status, next_step.				
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_dispatch_history`$
CREATE PROCEDURE `report_dispatch_history`(
  IN _from_time datetime,
  IN _to_time datetime,
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
    
  IF _from_time IS NOT NULL AND _to_time IS NOT NULL AND _from_time < _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           l.order_line_num as po_linenumber,
           l.quantity_status,
           
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h2.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h2.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h2.result,',',-1)), if(h2.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
           IF(h2.status ='dispatched' , 
                 '', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
		   LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h2.position_id = 0, 1, h2.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos							
     WHERE h.start_timecode between 
               DATE_FORMAT(_from_time, '%Y%m%d%H%i%s0')
           AND DATE_FORMAT(_to_time, '%Y%m%d%H%i%s0')
       AND h.status = 'dispatched';
       
  ELSEIF _from_time = _to_time
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           l.order_line_num as po_linenumber,
           l.quantity_status,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h2.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h2.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h2.result,',',-1)), if(h2.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
           IF(h2.status='dispatched' , 
                 ' ', 
                 h2.status) as step_status
      FROM lot_history h 
           INNER JOIN lot_status l on l.id = h.lot_id
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN lot_history h2 ON h2.lot_id = h.lot_id 
                 AND h2.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h3
                                           WHERE h3.lot_id=h2.lot_id)
                 AND (h2.end_timecode IS NULL OR 
                         (
                         NOT EXISTS (SELECT * FROM lot_history h4
                                      WHERE h4.lot_id = h2.lot_id
                                        AND h4.start_timecode = h2.start_timecode
                                        AND h4.end_timecode IS NULL)
                          AND h2.end_timecode = (SELECT max(h5.end_timecode)
                                                  FROM lot_history h5
                                                 WHERE h5.lot_id = h2.lot_id)))
           LEFT JOIN step s ON s.id = h2.step_id
		   LEFT JOIN step_type st ON st.id = s.step_type_id
		   LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h2.position_id = 0, 1, h2.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos	                               
     WHERE h.status = 'dispatched';
  ELSE   
      SET _response = "Both From Time and To Time need to be filled and From Time must be a datatime earlier than To Time.";
  END IF;
END$

-- report_product procedure
DROP PROCEDURE IF EXISTS `report_product`$
CREATE PROCEDURE `report_product`(
  IN _product_id int(10) unsigned,
  IN _order_id int(10) unsigned,
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _response varchar(255)
)
BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)
  IF _product_id IS NULL
  THEN
    SET _response = "Product is required. Please select a product.";
  ELSEIF _order_id IS NULL OR length(_order_id) = 0
  THEN
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h.status='dispatched', 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
                              AND h.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h2
                                           WHERE h2.lot_id=h.lot_id)
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
                                           
     WHERE l.product_id = _product_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  
       
  ELSE
    SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           og.ponumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           s.name as step_name,
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
      FROM lot_status l INNER JOIN lot_history h on l.id = h.lot_id
                 AND h.start_timecode = (SELECT MAX(start_timecode)
                                            FROM lot_history h2
                                           WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id                                         
     WHERE l.product_id = _product_id
       AND l.order_id = _order_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
  END IF;
END$


-- get_rework_count_for_lot procedure
DROP PROCEDURE IF EXISTS `get_rework_count_for_lot`$
CREATE PROCEDURE `get_rework_count_for_lot`(
  IN _lot_id int(10) unsigned,
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  OUT _rework_count smallint(2) unsigned,
  OUT _response varchar(255)
)
BEGIN
  
  DECLARE _if_sub_process tinyint(1) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please supply a batch id.";  
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id=_lot_id) 
  THEN
    SET _response = "The lot you supplied does not exist in database";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "Please select a process.";
  ELSEIF _position_id IS NULL
  THEN
    SET _response = "Please supply a position.";
  ELSE
 

    SELECT count(*) into _rework_count
      FROM lot_history
     WHERE lot_id = _lot_id
       AND process_id = _process_id
       AND sub_process_id <=> _sub_process_id
       AND step_id = _step_id
       AND status in ('ended', 'started', 'finished')
       AND position_id = _position_id
       AND sub_position_id <=>_sub_position_id
;
          
  END IF;

 END$
 
 -- check_emp_access procedure
 DROP PROCEDURE IF EXISTS `check_emp_access`$
CREATE PROCEDURE `check_emp_access`(
  IN _emp_id int(10) unsigned,
  IN _emp_usage enum('employee group', 'employee'),
  IN _allow_emp_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  DECLARE _if_allow tinyint(1) unsigned;
  SET _if_allow=0;
  IF _emp_id IS NULL
  THEN
    SET _response = "Please supply an employee id to be checked";  
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_emp_id) 
  THEN
    SET _response = "The employee selected doesn't exist in database.";
  ELSEIF _allow_emp_id IS NULL
  THEN
    SET _response = "There is no defined restriction for employee access.";
  ELSEIF _emp_usage="employee group" 
    AND EXISTS (SELECT * FROM employee WHERE id=_emp_id
                                         AND eg_id=_allow_emp_id)
  THEN
    SET _if_allow=1;
  ELSEIF _emp_usage="employee" AND _emp_id=_allow_emp_id
  THEN
    SET _if_allow=1;
          
  END IF;
  
  SELECT _if_allow;
 END$
 
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : pass_lot_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for starting and ending a step in one shot
*    Example
set @_process_id = 5;
set @_sub_process_id =null;
set @_position_id =15;
set @_sub_position_id =null;
set @_step_id =23;
call pass_lot_step(
147,
'PTBF01UB0000000007',
  2,
  1,
 null,
 null,
 2,
'test',
',13,,52', -- for short result
null,
 null,
@_process_id,
@_sub_process_id,
@_position_id,
@_sub_position_id,
@_step_id ,
@_lot_status ,
@_step_status,
@_autostart_timecode,
@_response );
select @_process_id,
@_sub_process_id,
@_position_id,
@_sub_position_id,
@_step_id,
@_lot_status ,
@_step_status,
@_autostart_timecode,
@_response;
*    Log                    :
*    6/6/2018: xdong: adding _location parameter to record batch location for certain ship steps
*	 8/2/2018: peiyu: replaced _location nvarchar  to location_id int
*	 11/29/2018 peiyu: added one more state "done" to lot status and update lot_status accordingly. if flag product_made of current step
*    in process_step is 1, update quantity_made and quantity_in_process in order details
*   11/29/2018:xdong: fixed some logical error regarding product_made and done status. 
*                      added code to update quantity_in_process when actual quantity changed
*   12/04/2018: xdong: corrected logic for updating quantities in order_detail table in case of batch quantity changed in this step.
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `pass_lot_step`$
CREATE PROCEDURE `pass_lot_step`(
IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _equipment_id int(10) unsigned,
  IN _device_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _short_result varchar(255), -- for short result
  IN _comment text,
  -- IN _location nvarchar(255), -- for location
  IN _location_id int(11) unsigned,
  INOUT _process_id int(10) unsigned,
  INOUT _sub_process_id int(10) unsigned,
  INOUT _position_id int(5) unsigned,
  INOUT _sub_position_id int(5) unsigned,
  INOUT _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),
  OUT _autostart_timecode char(15),
  OUT _response varchar(255)
)
BEGIN
 
 -- xxxx_p are for position step just processed before this step
 -- xxxx_n are for the position step to be passed in this call
 -- xxxx_nn are for the next postion step after the step to be passed in this call
 -- inout parameters _process_id, _sub_Process_id, _position_id, _sub_position_id, _step_id should have the same value
 -- as the xxxx_n obtained from call to get_next_step_for_lot
  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n, _sub_process_id_nn int(10) unsigned; 
  DECLARE _position_id_p, _position_id_n, _position_id_nn int(5) unsigned;  
  DECLARE _sub_position_id_p, _sub_position_id_n, _sub_position_id_nn int(5) unsigned; 
  DECLARE _step_id_p, _step_id_n, _step_id_nn int(10) unsigned;
  DECLARE _step_type varchar(20);
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  DECLARE _uomid smallint(3) unsigned;
  DECLARE _start_timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _product_made tinyint(1) unsigned;
  DECLARE _quantity_status, _quantity_status_p ENUM('in process', 'made', 'shipped');
  DECLARE _order_id int(10) unsigned;
  DECLARE _product_id int(10) unsigned;
  DECLARE _line_num smallint(5) unsigned;
  DECLARE _actual_quantity_p decimal(16,4);

  
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE  -- pull in lot current info, which do not have the step to be passed yet
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid,
           actual_quantity,
           order_id,
           product_id, 
           order_line_num,
           quantity_status
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid,
           _actual_quantity_p,
           _order_id,
           _product_id,
           _line_num,
           _quantity_status_p
      FROM view_lot_in_process
     WHERE id=_lot_id;
     
    IF _lot_status NOT IN ('dispatched', 'in transit', 'to warehouse')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
    -- send in last step info through _process_id_p, _sub_process_id_p, _position_id_p, _sub_position_id_p and 
    -- get the info of the step to be processed in this call and save them into _sub_process_id_n, _position_id_n, _sub_position_id_n, _step_id_n etc.
    CALL get_next_step_for_lot(_lot_id, 
                              _lot_alias, 
                              _lot_status, 
                              _process_id_p,
                              _sub_process_id_p,
                              _position_id_p,
                              _sub_position_id_p,
                              _step_id_p,
                              _result,
                              _sub_process_id_n,
                              _position_id_n,
                              _sub_position_id_n,
                              _step_id_n,
                              _step_type,
                              _rework_limit,
                              _if_autostart,
                              _response);
                              
    IF _response IS NULL
    THEN
      IF _process_id IS NULL 
        AND _sub_process_id IS NULL 
        AND _position_id IS NULL
        AND _sub_position_id IS NULL
        AND _step_id IS NULL
      THEN  -- step information wasn't supplied from input, replenish them through the internal variables
        
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSEIF _process_id<=>_process_id_p 
        AND _sub_process_id<=>_sub_process_id_n
        AND _position_id <=>_position_id_n
        AND _sub_position_id <=>_sub_position_id_n
        AND _step_id <=> _step_id_n
      THEN -- new step information was supplied and checked against the result from call to get_next_step_for_lot
        SET _response='';
      ELSE
        SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF; 
        
      IF _response IS NULL OR length(_response)=0  
      THEN
           -- check approver information and product made infomation of the pass step
        IF _sub_process_id IS NULL
        THEN
          SELECT need_approval, approve_emp_usage, approve_emp_id, product_made 
            INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made 
            FROM process_step
           WHERE process_id = _process_id
               AND position_id = _position_id
               AND step_id = _step_id
          ;
        ELSE
          SELECT need_approval, approve_emp_usage, approve_emp_id,product_made
            INTO _need_approval, _approve_emp_usage, _approve_emp_id, _product_made
            FROM process_step
           WHERE process_id = _sub_process_id
             AND position_id = _sub_position_id
             AND step_id = _step_id
             ;
        END IF;
        
        -- perform check approver routine
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);

        -- if approver routine passed
        IF _response IS NULL OR length(_response)=0 
        THEN
          
          SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
            
          SET _step_status = 'ended';
          
          -- below logic is to preserve current location, if lot is not at those
          -- ship steps
          IF _step_type NOT IN ('ship to location', 'ship outof warehouse', 'deliver to customer')
          THEN
            SELECT _location_id = location_id
              FROM lot_status
              WHERE id = _lot_id;
          END IF;     
          
          IF _product_made = 1
          THEN
            SET _quantity_status = 'made';
          ELSE
            SET _quantity_status = 'in process';
          END IF;
          
          -- record this step into lot history
          INSERT INTO lot_history
          (
            lot_id,
            lot_alias,
            start_timecode,
            end_timecode,
            process_id,
            sub_process_id,
            position_id,
            sub_position_id,
            step_id,
            start_operator_id,
            end_operator_id,
            status,
            start_quantity,
            end_quantity,
            uomid,
            equipment_id,
            device_id,
            result,
            comment,
            location_id,
            quantity_status
          )
          VALUES (
            _lot_id,
            _lot_alias,
            _start_timecode,
            _start_timecode,
            _process_id,
            _sub_process_id,
            _position_id,
            _sub_position_id,
            _step_id,
            _operator_id,
            _operator_id,
            _step_status,
            _actual_quantity_p,
            _quantity,
            _uomid ,
            _equipment_id,
            _device_id,
            _short_result,
            _comment,
            _location_id,
            _quantity_status
          ); 
          -- now that lot history is logged. update current lot information and order detail
          IF row_count() > 0 THEN
            -- look beyond the step just passed to see if at the last step
            CALL get_next_step_for_lot(_lot_id, 
                                  _lot_alias, 
                                  _lot_status, 
                                  _process_id_p,
                                  _sub_process_id_n,
                                  _position_id_n,
                                  _sub_position_id_n,
                                  _step_id_n,
                                  _short_result,
                                  _sub_process_id_nn,
                                  _position_id_nn,
                                  _sub_position_id_nn,
                                  _step_id_nn,
                                  _step_type,
                                  _rework_limit,
                                  _if_autostart,
                                  _response);
          -- check next position id, if NULL then workflow completes
            -- if no more step to perform and not special steps
            IF (_response IS NULL OR length(_response)=0) AND _position_id_nn IS NULL THEN 
              SET _lot_status = 'done';
            ELSE
              SET _lot_status = 'in transit';
            END IF;
            
  
            UPDATE lot_status
              SET status = _lot_status
                  ,actual_quantity = _quantity
                  ,update_timecode = _start_timecode
                  ,comment=_comment
                  ,location_id = _location_id
                  ,quantity_status = _quantity_status
            WHERE id=_lot_id;
			  
            
            -- if actual quantity changed, adjust quantities in order_detail. quantity_shipped will never need adjust, 
            -- because once product is shipped to customer, the quantity record should not change
            IF _actual_quantity_p != _quantity
            THEN
              IF _quantity_status_p = 'in process' THEN
                UPDATE order_detail
                   SET quantity_in_Process = quantity_in_process - _actual_quantity_p + _quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;
              ELSEIF _quantity_status_p = 'made' THEN
                 UPDATE order_detail
                   SET quantity_made = quantity_made - _actual_quantity_p + _quantity
                WHERE order_id= _order_id
                  And source_id = _product_id
                  And source_type = 'product'
                  And line_num = _line_num;             
              END IF;
            END IF;
					  
            -- if product is made at the step, deduct the quantity from quantity_in_process and add it to quantity_made in order_detail
            IF _product_made = 1
            THEN
              UPDATE order_detail
              SET quantity_made = quantity_made + _quantity
                  ,quantity_in_process = quantity_in_process - _quantity
              WHERE order_id= _order_id
              And source_id = _product_id
              And source_type = 'product'
              And line_num = _line_num;
            End IF;
            ELSE
              SET _response="Error when recording step pass in batch history.";
            END IF; 
            -- if lot is not done
            -- below process is for auto start next step. if call to start_lot_step return _autostart_timecode
            -- we know next step is auto-started, thus, set output parameters to next step
            IF (_response IS NULL OR length(_response)=0) and _lot_status != 'done' THEN
              SET _process_id_p = null;
              SET _sub_process_id_n = null;
              SET _position_id_n = null;
              SET _sub_position_id_n = null;
              SET _step_id_n = null;
              
              CALL `start_lot_step`(
                _lot_id,
                _lot_alias,
                _operator_id,
                1,
                _quantity,
                null,
                null,
                'Step started automatically',
                _process_id_p,
                _sub_process_id_n,
                _position_id_n,
                _sub_position_id_n,
                _step_id_n,
                _location_id,
                _lot_status_n,
                _step_status_n,
                _autostart_timecode,
                _response
              );
              IF _autostart_timecode IS NOT NULL
              THEN
                SET _process_id = _process_id_p;
                SET _sub_process_id = _sub_process_id_n;
                SET _position_id = _position_id_n;
                SET _sub_position_id = _sub_position_id_n;
                SET _step_id = _step_id_n;
                SET _lot_status = _lot_status_n;
                SET _step_status = _step_status_n;
              END IF;
            END IF;
          
          END IF;
        END IF;
  
  
      END IF;
    END IF;
  END IF;
END$

-- procedure report_consumption_for_step
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_consumption_for_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : output the consumption information for a given lot/batch and given step
                              This is used in Consume Material step or Disassemble step.
                              In Consume step, the final consumption is recorded in inventory_consumption table,
                              thus, this procedure retrieve the quantity_used from this table
                              In Disassemble step, this procedure actually output quantity_returned from consumption_return
                              table to the quantity_used column in output resultset, so that application can show it on UI
*    example	            : 
call report_consumption_for_step (21, 'WWMTOFauce0000000006', 3, 38, '201806190044480', @_response);
select @_response
*    Log                    :
*    6/18/2018: xdong: added logic to count inventory returned for disassemble step. 	
*	 11/30/2018: peiyu: added a new In variable _start_quantity (user's input of quantity to work on) and updated required_quantity accordingly		
*	 1/5/2019: peiyu added one more column inventory	
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `report_consumption_for_step`$
CREATE PROCEDURE `report_consumption_for_step`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _process_id int(10) unsigned,
  IN _step_id int(10) unsigned,
  IN _start_timecode char(15),
  IN _start_quantity decimal(16,4) unsigned,
  OUT _response varchar(255)
)
BEGIN
-- the procedure uses _start_timecode,  to locate the consumption record if possible
-- otherwise, it will use the 
  DECLARE _end_timecode char(15);
  DECLARE _step_type varchar(20);
  
  IF _lot_id IS NULL
  THEN
    SET _response = "Please select a batch.";
  ELSEIF _process_id IS NULL
  THEN
    SET _response = "The batch has no workflow assigned.";
  ELSEIF _step_id IS NULL
  THEN
    SET _response = "The batch is not inside a step.";
  ELSEIF _start_quantity IS NULL or _start_quantity = ''
  THEN
    SET _response = "Start quantity is required.";
  ELSE
  
	SELECT st.name
      INTO _step_type
      FROM step_type st
	  JOIN step s
        ON s.step_type_id = st.id
           AND s.id = _step_id;
           
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_consumption 
      (
        source_type varchar(20),
        ingredient_id int(10) unsigned,
        name varchar(255),
        `order` tinyint(3) unsigned,
        description text,
        required_quantity decimal(16,4),
        uom_id smallint(6) unsigned,
        uom_name varchar(20),
        mintime int(10) unsigned,
        maxtime int(10) unsigned,
        restriction varchar(255),
        comment text,
        used_quantity decimal(16,4),
        inventory varchar(255)
      ) DEFAULT CHARSET=utf8;
    
    INSERT INTO temp_consumption
    SELECT v.source_type, 
           v.ingredient_id,
           v.name, 
           v.order,
           v.description, 
           v.quantity * _start_quantity, 
           v.uom_id,
           v.uom_name, 
           v.mintime, 
           v.maxtime,
           CASE
             WHEN v.mintime>0 AND v.maxtime>0 
                 THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part, but no more than ", v.maxtime, " minutes.")
             WHEN v.mintime>0
              THEN CONCAT("You must use at least ", v.mintime, " minutes to add the part.")
             WHEN v.maxtime>0
              THEN CONCAT("You have to add the part within ", v.maxtime, " minutes.")
             ELSE
               ''
           END,
           v.comment,
           null,
           (select group_concat(concat((select name from location where id = i.location_id), ': ', Format(i.actual_quantity, 1)) separator '|') from inventory i where v.ingredient_id = i.pd_or_mt_id)as inventory
      FROM step s JOIN view_ingredient v ON v.recipe_id = s.recipe_id
    WHERE s.id =_step_id;
    
    SELECT end_timecode
      INTO _end_timecode
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _start_timecode
       AND step_id = _step_id;

	IF _step_type = 'consume material'
    THEN
		UPDATE temp_consumption t LEFT JOIN 
		  (SELECT i.source_type,
				  i.pd_or_mt_id,
				  sum(c.quantity_used) as total_used
			 FROM inventory_consumption c INNER JOIN inventory i
			   ON i.id = c.inventory_id
			WHERE c.lot_id = _lot_id
			  AND c.start_timecode >= _start_timecode
			  AND (_end_timecode IS NULL OR c.end_timecode<=_end_timecode)
			  AND c.step_id = _step_id
			GROUP BY i.source_type, i.pd_or_mt_id) a
		   ON a.source_type = t.source_type
			  AND a.pd_or_mt_id = t.ingredient_id
		 SET t.used_quantity = a.total_used;
	ELSEIF _step_type = 'disassemble'
    THEN
		UPDATE temp_consumption t LEFT JOIN 
		  (SELECT i.source_type,
				  i.pd_or_mt_id,
				  sum(c.quantity_returned) as total_used
			 FROM consumption_return c INNER JOIN inventory i
			   ON i.id = c.inventory_id
			WHERE c.lot_id = _lot_id
			  AND c.consumption_start_timecode >= _start_timecode
			  AND c.step_id = _step_id
			GROUP BY i.source_type, i.pd_or_mt_id) a
		   ON a.source_type = t.source_type
			  AND a.pd_or_mt_id = t.ingredient_id
		 SET t.used_quantity = a.total_used;    
    END IF;
    
    
    SELECT 
        source_type,
        ingredient_id,
        name,
        `order`,
        description,
        required_quantity,
        ifnull(used_quantity,0) as used_quantity,      
        uom_id,
        uom_name,
        mintime,
        maxtime,
        restriction,
        comment,
       inventory
      FROM temp_consumption
      ORDER BY `order`
      ;
    DROP TABLE temp_consumption;
  END IF;
 
END$


-- procedure report_consumption_details
DROP PROCEDURE IF EXISTS `report_consumption_details`$
CREATE PROCEDURE `report_consumption_details`(
  IN _lot_id int(10) unsigned,
  IN _step_start_timecode char(15),
  IN _source_type enum('product', 'material'),
  IN _source_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
-- If _step_start_timecode is supplied, the resultset only shows
-- the consumption for the step that started at the _step_start_timecode
-- otherwise, it shows the consumption of the whole workflow/process.

-- If _source_type is supplied, the resultset only shows the consumption of the specified source type,
-- otherwise, it shows consumption of all source type.

-- If _source_id is supplied, the resultset only shows the consumption of the particular source/ingredient,
-- otherwise, it will show the consumption of all sources.

-- _lot_id is required. The other three parameters can be used in combinations or all null.

  DECLARE _end_timecode char(15);

  IF _lot_id IS NULL
  THEN
    SET _response = "Please selected a batch.";
  ELSE
     SELECT l.lot_id,
            l.lot_alias,
            str_to_date(l.start_timecode, '%Y%m%d%H%i%s0' ) as step_start,
            str_to_date(l.end_timecode, '%Y%m%d%H%i%s0' ) as step_end,
            l.process_id,
            l.sub_process_id,
            l.position_id,
            l.sub_position_id,
            l.step_id,
            s.name as step_name,
            str_to_date(ic.start_timecode, '%Y%m%d%H%i%s0' ) as consumption_start,
            str_to_date(ic.end_timecode, '%Y%m%d%H%i%s0' ) as consumption_end,
            ic.inventory_id,
            CASE WHEN i.source_type = 'product' THEN p.name ELSE m.name END AS part_name,
            i.lot_id as inv_lot_id,
            i.serial_no as inv_serial_no,
            ic.quantity_used,
            ic.uom_id,
            u.name as uom_name,
            ic.operator_id,
            CONCAT(e.firstname, ' ', e.lastname) AS operator,
            ic.comment
       FROM lot_history l
       INNER JOIN step s ON s.id = l.step_id 
       INNER JOIN step_type st ON st.id = s.step_type_id AND st.name = 'consume material'
       INNER JOIN inventory_consumption ic 
             ON ic.start_timecode >=l.start_timecode 
             AND (l.end_timecode IS NULL or ic.end_timecode <= l.end_timecode)
       INNER JOIN inventory i 
             ON i.id = ic.inventory_id 
             AND (_source_type IS NULL OR i.source_type = _source_type)
             AND (_source_id IS NULL OR i.pd_or_mt_id = _source_id)
       INNER JOIN uom u ON u.id = ic.uom_id
       LEFT JOIN employee e ON e.id = ic.operator_id
       LEFT JOIN product p ON i.source_type = 'product' AND p.id = i.pd_or_mt_id
       LEFT JOIN material m ON i.source_type = 'material' AND m.id = i.pd_or_mt_id
      WHERE l.lot_id =_lot_id 
        AND (_step_start_timecode IS NULL OR l.start_timecode = _step_start_timecode)
        ;

   END IF;
END$

-- procedure return_inventory
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : return_inventory.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : db operations for return products or components back to inventory
*    example	            : 
call return_inventory (21, 'WWMTOFauce0000000006', 2, 3, 38, '201806190044480', '201806190044480', 6, 1, 'test', 1, @_response);
select @_response
*    Log                    :
*    6/14/2018: sdong: added this header session
*    6/17/2018: sdong: added more comment
*    6/18/2018: sdong: since when used in disassemble step, the quantity_before is null, which will throw off consumption_return
*                      table, thus, replace it with 0 in this case. Also, fixed typo.
*/
DELIMITER $
DROP PROCEDURE IF EXISTS `return_inventory`$
CREATE PROCEDURE `return_inventory`(
  IN _lot_id int(10) unsigned,  -- id of the batch
  IN _lot_alias varchar(20),   -- name of the batch
  IN _operator_id int(10) unsigned,  -- id of the operator performed this action
  IN _process_id int(10) unsigned,   -- id of the workflow
  IN _step_id int(10) unsigned,     -- id of the step
  IN _step_start_timecode char(15),  -- the start time of the lot to the step
  IN _consumption_start_timecode char(15),  -- the start time of the last consumption if the current step is a "consume material" step
			-- the start time of the current step if the current step is a "disassemble" step, since there is no consumption in such a step
  IN _inventory_id int(10) unsigned, -- id of the inventory to be returned
  IN _quantity_returned decimal(16,4) unsigned,  -- the quantity to be returned
  IN _comment text,   -- comment associated with this action
  IN _recipe_uomid smallint(3) unsigned,    -- the id of the uom used in the recipe
  OUT _response varchar(255)    -- response of this stored procedure
)
BEGIN
  
  DECLARE _inventory_uomid smallint(3) unsigned;
  DECLARE _inv_return_quantity decimal(16,4) unsigned;
  DECLARE _timecode char(15);
  DECLARE _quantity_before decimal(16,4) unsigned;
  DECLARE _step_type varchar(20);
  
  SET autocommit=0;

-- integrity checks
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a batch indentifier.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSEIF NOT EXISTS (
    SELECT *
      FROM lot_history
     WHERE lot_id = _lot_id
       AND start_timecode = _step_start_timecode
  )
  THEN
    SET _response = "The batch you selected hasn't reach the step given.";
  ELSE
  
	SELECT st.name
      INTO _step_type
      FROM step_type st
	  JOIN step s
        ON s.step_type_id = st.id
           AND s.id = _step_id;
           
    SELECT quantity_used
      INTO _quantity_before
      FROM inventory_consumption
     WHERE lot_id = _lot_id
       AND start_timecode = _consumption_start_timecode
       AND inventory_id = _inventory_id;
       
    SELECT uom_id
      INTO _inventory_uomid
      FROM inventory
     WHERE id=_inventory_id;
    

    IF _step_type = 'consume material' AND _quantity_before < _quantity_returned
    -- for consume step, you can only return what has been consumed. _quantity_before is what has been consumed
    THEN
      SET _response = CONCAT("The quantity used ", _quantity_before, " is less than quantity to return. Please refresh form and reenter return quantity.");
    ELSEIF _inventory_uomid IS NULL
    THEN
      SET _response = "The inventory you selected doesn't exist in database.";
    ELSE
	  -- the uom used in inventory record might be different than the uom used in recipe. below conversion calculates the qunatity by inventory uom
      SET _inv_return_quantity=convert_quantity(_quantity_returned, _recipe_uomid, _inventory_uomid);
      
      IF _inv_return_quantity IS NULL
      THEN
        SET _response = "Can not calculate inventory return because no UoM conversion provided to convert returned quantity into the UoM used in inventory.";

      ELSE
        SET _timecode = DATE_FORMAT(utc_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;
        -- record the returns happend in consumption step or disassemble step
        INSERT INTO `consumption_return` (
          `lot_id` ,
          `lot_alias` ,
          `return_timecode` ,
          `inventory_id` ,
          `quantity_before` ,
          `quantity_returned` ,
          `uom_id`  , 
          `operator_id`,
          `step_start_timecode` ,
          `consumption_start_timecode` ,
          `process_id` ,
          `step_id` ,
          `comment` )
           VALUES(
           _lot_id,
           _lot_alias,
           _timecode,
           _inventory_id,
           ifnull(_quantity_before, 0),
           _quantity_returned,
           _recipe_uomid,
           _operator_id,
           _step_start_timecode,
           _consumption_start_timecode,
           _process_id,
           _step_id,
           _comment
           );
          
          IF (_quantity_before = _quantity_returned)
          THEN
            DELETE FROM inventory_consumption
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;            
          ELSE
            UPDATE inventory_consumption
              SET quantity_used = quantity_used - _quantity_returned
            WHERE lot_id = _lot_id
              AND start_timecode = _consumption_start_timecode
              AND inventory_id = _inventory_id;   
          END IF;
          
          UPDATE inventory
             SET actual_quantity = actual_quantity + _inv_return_quantity
           WHERE id=_inventory_id;
           
        COMMIT;
      END IF;
    END IF;
  END IF;
END$


-- procedure check_approver
DROP PROCEDURE IF EXISTS `check_approver`$
CREATE PROCEDURE `check_approver`(
  IN _need_approval tinyint(1) unsigned,
  IN _approve_emp_usage enum('employee group','employee category','employee'),
  IN _approve_emp_id int(10) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  OUT _response varchar(255)
)
BEGIN
      
  IF _need_approval > 0
  THEN
    IF NOT EXISTS (SELECT * FROM employee WHERE id = _approver_id AND password=_approver_password AND status='active')
    THEN
      SET _response = "Approver username or password is incorrect. Please correct.";
    ELSEIF _approve_emp_usage = 'employee group' 
        AND NOT EXISTS (SELECT * FROM employee WHERE id=_approver_id AND eg_id = _approve_emp_id)
    THEN
      SET _response = "Approver doesn't belong to the employee group required for approving this step.";
    ELSEIF _approve_emp_usage='employee' AND _approver_id != _approve_emp_id
    THEN
      SET _response = "Approver is not the person required for approving this step.";
    -- currently we are not taking care of 'employee category' case. x.d.
    END IF;
  END IF;

END$

-- procedure deliver_lot
DROP PROCEDURE IF EXISTS `deliver_lot`$
CREATE PROCEDURE `deliver_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _deliver_datetime datetime,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _delivery_address varchar(255),
  IN _recipient varchar(30),
  IN _recipient_contact varchar(255),
  IN _comment text,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  
  SET autocommit=0;
   
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);    
    IF _response IS NULL AND _step_type = "deliver to customer"
    THEN
      -- SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
      IF ( _process_id IS NULL 
         AND _sub_process_id IS NULL 
         AND _position_id IS NULL
         AND _sub_position_id IS NULL
         AND _step_id IS NULL) OR
         (_process_id<=>_process_id_p 
            AND _sub_process_id<=>_sub_process_id_n
            AND _position_id <=>_position_id_n
            AND _sub_position_id <=>_sub_position_id_n
            AND _step_id <=> _step_id_n)
      THEN  -- new step informaiton wasn't supplied
      
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSE
         SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF;
      
       -- check approver information
      IF _response IS NULL
      THEN
        IF _sub_process_id IS NULL
        THEN
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id
            AND step_id = _step_id
        ;
        ELSE
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _sub_process_id
            AND position_id = _sub_position_id
            AND step_id = _step_id
          ;
        END IF;
        
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
      END IF;
      
      IF _response IS NULL
      THEN
        SET _step_status = 'shipped';
        SET _timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;        
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          end_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          end_operator_id,
          status,
          start_quantity,
          end_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _timecode,
          _timecode,
          _process_id,
          _sub_process_id,
          _position_id,
          _sub_position_id,
          _step_id,
          _operator_id,
          _operator_id,
          _step_status,
          _quantity,
          _quantity,
          _uomid ,
          CONCAT('RECIPIENT:', IFNULL(_recipient, ''), '\n', 
          'RECIPIENT CONTACT:', IFNULL(_recipient_contact,''), '\n',
          'DELIVERY DATETIME:', IFNULL(_deliver_datetime,''), '\n',
          'DELIVERY ADDRESS:', IFNULL(_delivery_address,''), '\n', 
          'COMMENT:', IFNULL(_comment,''))
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'shipped';
          
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _quantity
                ,update_timecode = _timecode
                ,comment=_comment
           WHERE id=_lot_id;
           
           UPDATE order_detail o, lot_status l
              SET o.quantity_in_process = o.quantity_in_process - convert_quantity(_quantity, _uomid, o.uomid),
                  o.quantity_shipped = o.quantity_shipped + convert_quantity(_quantity, _uomid, o.uomid),
                  o.actual_deliver_date=IFNULL(_deliver_datetime, o.actual_deliver_date)
            WHERE l.id = _lot_id
              AND o.order_id = l.order_id
              AND o.source_type = 'product'
              AND o.source_id = l.product_id
              ;
             COMMIT;         
        ELSE
          SET _response="Error when recording step pass in batch history.";
          ROLLBACK;
        END IF;  
        
        
      END IF;
    END IF;
    END IF;
  END IF;
END$

-- procedure scrap_lot
DROP PROCEDURE IF EXISTS `scrap_lot`$
CREATE PROCEDURE `scrap_lot`(
  IN _lot_id int(10) unsigned,
  IN _lot_alias varchar(20),
  IN _operator_id int(10) unsigned,
  IN _quantity decimal(16,4) unsigned,
  IN _approver_id int(10) unsigned,
  IN _approver_password varchar(20),
  IN _comment text,
  IN _process_id int(10) unsigned,
  IN _sub_process_id int(10) unsigned,
  IN _position_id int(5) unsigned,
  IN _sub_position_id int(5) unsigned,
  IN _step_id int(10) unsigned,
  OUT _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped'),
  OUT _step_status enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'),  
  OUT _response varchar(255)
)
BEGIN

  DECLARE _process_id_p, _sub_process_id_p, _sub_process_id_n int(10) unsigned;
  DECLARE _position_id_p, _position_id_n int(5) unsigned;
  DECLARE _sub_position_id_p, _sub_position_id_n int(5) unsigned;
  DECLARE _step_id_p, _step_id_n int(10) unsigned;
  DECLARE _step_type varchar(20);

  DECLARE _uomid smallint(3) unsigned;
  DECLARE _timecode char(15);
  DECLARE _rework_limit smallint(2) unsigned;
  DECLARE _result varchar(255);
  DECLARE _if_autostart tinyint(1) unsigned;
  DECLARE _lot_status_n enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped');
  DECLARE _step_status_n enum('dispatched','started','restarted','ended','error','stopped','scrapped','shipped'); 
  DECLARE _need_approval tinyint(1) unsigned;
  DECLARE _approve_emp_usage enum('employee group','employee category','employee');
  DECLARE _approve_emp_id int(10) unsigned;
  
  SET autocommit=0;
   
  IF _lot_id IS NULL THEN
     SET _response = "Batch identifier is missing. Please supply a lot.";
  ELSEIF NOT EXISTS (SELECT * FROM lot_status WHERE id= _lot_id)
  THEN
    SET _response = "The batch you selected is not in database.";
  ELSE
    SELECT lot_status,
           step_status,
           process_id,
           sub_process_id,
           position_id,
           sub_position_id,
           step_id,
           ifnull(result, 'T'),
           uomid
      INTO _lot_status, 
           _step_status, 
           _process_id_p,
           _sub_process_id_p,
           _position_id_p,
           _sub_position_id_p,
           _step_id_p,
           _result,
           _uomid
      FROM view_lot_in_process
     WHERE id=_lot_id;

    -- set _response=concat(_lot_status, ' ', _step_status, ' ', ifnull(_response, 'nnn'));
    IF _lot_status NOT IN ('dispatched', 'in transit')
    THEN
      SET _response = "The batch is either in process already or being held, or shipped, or scrapped. It can't start new step.";
    ELSEIF _step_status NOT IN ('dispatched', 'ended')
    THEN
      SET _response = "The batch didn't finish last step normally, thus can't start new step.";
    ELSE
     CALL get_next_step_for_lot(_lot_id, 
                                _lot_alias, 
                                _lot_status, 
                                _process_id_p,
                                _sub_process_id_p,
                                _position_id_p,
                                _sub_position_id_p,
                                _step_id_p,
                                _result,
                                _sub_process_id_n,
                                _position_id_n,
                                _sub_position_id_n,
                                _step_id_n,
                                _step_type,
                                _rework_limit,
                                _if_autostart,
                                _response);    
    IF _response IS NULL AND _step_type = "scrap"
    THEN
      -- SET _start_timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
      IF ( _process_id IS NULL 
         AND _sub_process_id IS NULL 
         AND _position_id IS NULL
         AND _sub_position_id IS NULL
         AND _step_id IS NULL) OR
         (_process_id<=>_process_id_p 
            AND _sub_process_id<=>_sub_process_id_n
            AND _position_id <=>_position_id_n
            AND _sub_position_id <=>_sub_position_id_n
            AND _step_id <=> _step_id_n)
      THEN  -- new step informaiton wasn't supplied
      
        SET _process_id = _process_id_p;
        SET _sub_process_id = _sub_process_id_n;
        SET _position_id = _position_id_n;
        SET _sub_position_id = _sub_position_id_n;
        SET _step_id = _step_id_n;
      ELSE
         SET _response = "The step you are about to start doesn't match the workflow followed by the batch.";
      END IF;
      
       -- check approver information
      IF _response IS NULL
      THEN
        IF _sub_process_id IS NULL
        THEN
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _process_id
            AND position_id = _position_id
            AND step_id = _step_id
        ;
        ELSE
        SELECT need_approval, approve_emp_usage, approve_emp_id
          INTO _need_approval, _approve_emp_usage, _approve_emp_id
            FROM process_step
          WHERE process_id = _sub_process_id
            AND position_id = _sub_position_id
            AND step_id = _step_id
          ;
        END IF;
        
        CALL check_approver(_need_approval, _approve_emp_usage, _approve_emp_id, _approver_id, _approver_password, _response);
      END IF;
      
      IF _response IS NULL
      THEN
        SET _step_status = 'scrapped';
        SET _timecode = DATE_FORMAT(UTC_timestamp(), '%Y%m%d%H%i%s0');
        
        START TRANSACTION;        
        INSERT INTO lot_history
        (
          lot_id,
          lot_alias,
          start_timecode,
          end_timecode,
          process_id,
          sub_process_id,
          position_id,
          sub_position_id,
          step_id,
          start_operator_id,
          end_operator_id,
          status,
          start_quantity,
          end_quantity,
          uomid,
          comment
        )
        VALUES (
          _lot_id,
          _lot_alias,
          _timecode,
          _timecode,
          _process_id,
          _sub_process_id,
          _position_id,
          _sub_position_id,
          _step_id,
          _operator_id,
          _operator_id,
          _step_status,
          _quantity,
          _quantity,
          _uomid ,
          _comment
        ); 
        IF row_count() > 0 THEN
          SET _lot_status = 'scrapped';
          
          UPDATE lot_status
             SET status = _lot_status
                ,actual_quantity = _quantity
                ,update_timecode = _timecode
                ,comment=_comment
           WHERE id=_lot_id;
           
           UPDATE order_detail o, lot_status l
              SET o.quantity_in_process = o.quantity_in_process - convert_quantity(_quantity, _uomid, o.uomid)
            WHERE l.id = _lot_id
              AND o.order_id = l.order_id
              AND o.source_type = 'product'
              AND o.source_id = l.product_id
              ;
             COMMIT;         
        ELSE
          SET _response="Error when recording scrap action in batch history.";
          ROLLBACK;
        END IF;  
        
        
      END IF;
    END IF;
    END IF;
  END IF;
END$

-- procedure autoload_client
DROP PROCEDURE IF EXISTS `autoload_client`$
-- used when load vendors/customers from Quickbooks export file
-- the only difference it has over modify_client is _client_id is not supplied
-- and the program check whether a client exists by name and if not exist, insert, but not update.
CREATE PROCEDURE `autoload_client`(
OUT _client_id int(10) unsigned,
IN _name varchar(40),
IN _type enum('supplier', 'customer', 'both'),
IN _internal_contact_id int(10) unsigned,
IN _company_phone varchar(20),
IN _address varchar(255),
IN _city varchar(20),
IN _state varchar(20),
IN _zip varchar(10),
IN _country varchar(20),
IN _address2 varchar(255),
IN _city2 varchar(20),
IN _state2 varchar(20),
IN _zip2 varchar(10),
IN _contact_person1 varchar(20),
IN _contact_person2 varchar(20),
IN _person1_workphone varchar(20),
IN _person1_cellphone varchar(20),
IN _person1_email varchar(40),
IN _person2_workphone varchar(20),
IN _person2_cellphone varchar(20),
IN _person2_email varchar(20),
IN _ifactive tinyint(1) unsigned,
IN _comment text,
OUT _response varchar(255)
)
BEGIN
  DECLARE ifexist varchar(255);
  
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Client name is required. Please input the client name.';
  ELSEIF _type IS NULL OR length(_type)<1
  THEN
    SET _response='Client type is required. Please input the client type.';  
  ELSEIF _internal_contact_id IS NULL 
  THEN
    SET _response = 'Internal contact person is required. Please select an employee as internal contact person.';
    
  ELSEIF _contact_person1 IS NULL OR length(_contact_person1)<1
  THEN
    SET _response='Contact person name from client company is required. Please fill in the name of the person.'; 
    
  ELSEIF _person1_email IS NULL OR length(_person1_email)<1
  THEN
    SET _response='Email address of the first contact person from client company is required. Please fill in the email address.';    
    
  ELSE
    SELECT id
      INTO _client_id
      FROM client
     WHERE name=_name;
     
    IF _client_id IS NULL
    THEN
      INSERT INTO client (
        name,
        type,
        internal_contact_id,
        company_phone,
        address,
        city,
        state,
        zip,
        country,
        address2,
        city2,
        state2,
        zip2,
        contact_person1,
        contact_person2,
        person1_workphone,
        person1_cellphone,
        person1_email,
        person2_workphone,
        person2_cellphone,
        person2_email,
        firstlistdate,
        ifactive,
        comment
      )
      VALUES (
        _name,
        _type,
        _internal_contact_id,
        _company_phone,
        _address,
        _city ,
        _state,
        _zip,
        _country,
        _address2,
        _city2,
        _state2,
        _zip2,
        _contact_person1,
        _contact_person2,
        _person1_workphone,
        _person1_cellphone,
        _person1_email,
        _person2_workphone,
        _person2_cellphone,
        _person2_email,
        now(),
        _ifactive,
        _comment
      );
      SET _client_id = last_insert_id();
    END IF;

  END IF;
END$

-- procedure autoload_material
DROP PROCEDURE IF EXISTS `autoload_material`$

CREATE procedure autoload_material (
  IN _employee_id int(10) unsigned,
  IN _name varchar(255),
  IN _alias varchar(255),
  IN _mg_id int(10) unsigned,
  IN _material_form enum('solid','liquid','gas'),
  IN _status enum('inactive','production','frozen'),
  IN _lot_size decimal(16,4) unsigned,
  IN _uom_name varchar(20),
  IN _supplier_id int(10) unsigned,
  IN _preference smallint(3) unsigned,  
  IN _mpn varchar(255),
  IN _price decimal(10,2) unsigned,
  IN _lead_days int(5) unsigned,
  IN _description text,
  IN _comment text,
  OUT _material_id int(10) unsigned,  
  OUT _response varchar(255)
) 
BEGIN
  DECLARE _uom_id smallint(3) unsigned;
  IF _name IS NULL OR length(_name)<1
  THEN
    SET _response='Material name is required. Please give the material a name.';
    
  ELSEIF _employee_id IS NULL
  THEN
    SET _response = 'Employee information is missing.';
  ELSEIF _uom_name IS NULL
  THEN
    SET _response = 'Unit of Measure used for item is missing.';
  ELSE

    SELECT id
      INTO _uom_id
      FROM uom
     WHERE name=_uom_name;
    
    IF _uom_id IS NULL
    THEN
      SET _response = 'Unit of Measure used by the item does not exist in database.';
    ELSE
    
      SELECT id INTO _material_id 
      FROM material 
      WHERE name=_name
        AND mg_id <=> _mg_id;
      
      IF _material_id IS NULL
      THEN
        INSERT INTO material (
          name,
          mg_id,
          alias,
          uom_id,
          lot_size,
          material_form,
          status,
          enlist_time,
          enlisted_by,
          description,
          comment
        )
        VALUES (
          _name,
          _mg_id,
          _alias,
          _uom_id,
          _lot_size,
          _material_form,
          _status,
          now(),
          _employee_id,
          _description,
          _comment
        );
        SET _material_id = last_insert_id();
        SET _response = '';
      END IF;
      
      IF _supplier_id IS NOT NULL
      THEN
        IF NOT EXISTS (SELECT * FROM material_supplier WHERE material_id = _material_id AND supplier_id = _supplier_id)
        THEN
          INSERT INTO material_supplier
          (
            `material_id`,
            `supplier_id`,
            `preference`,
            `mpn`,
            `price`,
            `price_uom_id`,
            `lead_days`
          )
          VALUES(
            _material_id,
            _supplier_id,
            _preference,  
            _mpn,
            _price,
            _uom_id,
            _lead_days        
          );
        ELSE
          UPDATE material_supplier
            SET preference = ifnull(_preference, preference)
              , mpn = ifnull(_mpn, mpn)
              , price = ifnull(_price, price)
              , price_uom_id = _uom_id
          WHERE material_id = _material_id
            AND supplier_id = _supplier_id;
        END IF;
      END IF;
    END IF;
 END IF;
END$

-- procedure autoload_inventory
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : autoload_inventory.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*	 8/23/2018: Peiyu Ge: added location info.					
*/
DROP PROCEDURE IF EXISTS autoload_inventory$
CREATE PROCEDURE autoload_inventory (
  IN _recorded_by int(10) unsigned,
  IN _source_type enum('product', 'material'),
  IN _pd_or_mt_id int(10) unsigned,
  IN _supplier_id int(10) unsigned, -- if no supplier use 0
  IN _lot_id varchar(20),
  IN _serial_no varchar(20),
  IN _out_order_id varchar(20),
  IN _in_order_id varchar(20),
  IN _original_quantity decimal(16,4) unsigned,
  IN _uom_name varchar(20),
  IN _manufacture_date datetime,
  IN _expiration_date datetime,
  IN _arrive_date datetime,
  IN _contact_employee int(10) unsigned,
  IN _comment text,
  IN _location_id int(11) unsigned,
  OUT _inventory_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN

  DECLARE ifexist varchar(255);
  DECLARE wording varchar(20);
  DECLARE _uom_id smallint(3) unsigned;
  
  SELECT id INTO _uom_id
    FROM uom
   WHERE name = _uom_name;
   
  IF _source_type IS NULL OR length(_source_type )< 1
  THEN
    SET _response='Source type is required. Please provide an source type.';
  ELSEIF  _pd_or_mt_id IS NULL
  THEN 
    SET _response='No part number provided. Please supply a part number.';
  ELSEIF  _supplier_id IS NULL
  THEN 
    SET _response='Supplier is required. Please supply a supplier.';
  ELSEIF  _lot_id IS NULL
  THEN 
    SET _response='Supplier lot number is required. Please fill in the lot number.';
  ELSEIF  _original_quantity IS NULL OR _original_quantity = 0
  THEN 
    SET _response='Original Quanity is required and can not be zero. Please provide original quantity.';
  ELSEIF  _uom_name IS NULL
  THEN 
    SET _response='Unit of Measure is required. Please provide a unit of measure.';   
  ELSEIF  _manufacture_date IS NULL
  THEN 
    SET _response='Manufacture Date is required. Please provide a manufacture date.'; 
  ELSEIF  _arrive_date IS NULL
  THEN 
    SET _response='Arrive Date is required. Please provide an arrive date.';
  ELSEIF  _recorded_by IS NULL
  THEN 
    SET _response='Recorder information is missing.';   
  ELSEIF NOT EXISTS (SELECT * FROM employee WHERE id=_recorded_by)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';  
  ELSEIF _contact_employee IS NOT NULL AND NOT EXISTS (SELECT * FROM employee WHERE id=_contact_employee)
  THEN
    SET _response='The person who submit this inventory does not exist in database.';   
  ELSEIF _uom_name IS NULL 
  THEN
    SET _response = 'Unit of Measure is required. Please provide unit of measure used by the inventory.';
  ELSEIF _uom_id IS NULL
  THEN
    SET _response = "The unit of measure used doesn't exist in database. Please insert the UoM to database first.";
  ELSE
  

      
      IF _source_type = 'product' THEN

        SET _response = "This stored procedure currently doesn't handle self produced product.";
        
      ELSEIF _source_type = 'material' THEN
        IF NOT EXISTS (SELECT * FROM material WHERE id=_pd_or_mt_id)
        THEN
          SET _response = 'The material you selected is not in our material list. Please first record the material information.';
        ELSEIF _supplier_id IS NULL
        THEN
          SET _response = "Supplier information is missing. Please provide supplier information.";
        ELSEIF _supplier_id=0 
        THEN
          SELECT ifnull(supplier_id, 0) INTO _supplier_id
            FROM material_supplier s 
           WHERE s.material_id=_pd_or_mt_id
           ORDER BY s.preference
           LIMIT 1;
           
        END IF;
      ELSE
        SET _response = 'The source type you selected is invalid. Please select a valid source type.';
      END IF;
    
      IF _response IS NULL
      THEN
        IF _serial_no IS NULL AND EXISTS (SELECT * 
                                            FROM inventory 
                                          WHERE source_type = _source_type 
                                            AND pd_or_mt_id = _pd_or_mt_id
                                            AND supplier_id = _supplier_id
                                            AND lot_id = _lot_id
                                            )
        THEN
          SET _response = concat('The batch ', _lot_id , ' already exists in inventory.');
        ELSEIF EXISTS (SELECT * FROM inventory
                        WHERE source_type = _source_type 
                          AND pd_or_mt_id = _pd_or_mt_id
                          AND supplier_id = _supplier_id
                          AND lot_id = _lot_id
                          AND serial_no = _serial_no
                      )
        THEN
          SET _response = concat('The batch ', _lot_id , ' with serial number ', _serial_no, ' already exists in inventory.');
        END IF;
      END IF;
      
      IF _response IS NULL THEN

        INSERT INTO `inventory` (
          source_type,
          pd_or_mt_id,
          supplier_id,
          lot_id,
          serial_no,
          out_order_id,
          in_order_id,
          original_quantity,
          actual_quantity,
          uom_id,
          manufacture_date,
          expiration_date,
          arrive_date,
          recorded_by,
          contact_employee,
          comment,
		  location_id
        )
        values (
              _source_type,
              _pd_or_mt_id,
              _supplier_id,
              _lot_id,
              _serial_no,
              _out_order_id,
              _in_order_id,
              _original_quantity,
              _original_quantity,
              _uom_id,
              _manufacture_date,
              _expiration_date,
              _arrive_date,
              _recorded_by,
              _contact_employee,
              _comment,
			  _location_id
            );
        SET _inventory_id = last_insert_id();

      END IF;
  END IF;
  
END$

-- function get_local_time
DROP FUNCTION IF EXISTS `get_local_time`$
CREATE FUNCTION `get_local_time`(
   _utc_time datetime
)
RETURNS datetime
BEGIN
  
  DECLARE _timezone char(6);
  DECLARE _daylightsaving_starttime datetime;
  DECLARE _daylightsaving_endtime datetime;
  DECLARE _local_time datetime;
  
  SELECT timezone,
         daylightsaving_starttime,
         daylightsaving_endtime
    INTO _timezone, _daylightsaving_starttime, _daylightsaving_endtime
  FROM company
  LIMIT 1;
  
  SET _local_time = convert_tz(_utc_time, '+00:00', _timezone);
  IF _local_time BETWEEN concat(year(_local_time), substring(_daylightsaving_starttime,5))
                      AND concat(year(_local_time), substring(_daylightsaving_endtime,5))
  THEN
    RETURN addtime(_local_time, '01:00');
  ELSE
    RETURN _local_time;
  END IF;

 END$
 
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_order_quantity.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Report the quantities of given order's detail lines. Currently used by Order Status Report
*    example	            : 
CALL report_order_quantity (7);
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    6/20/2018: Xueyan Dong: added call example to header			
*   12/03/2018: Xueyan Dong: added line_num to the output (included product_name in the column for display in application report)
*/

DELIMITER $  
DROP PROCEDURE IF EXISTS `report_order_quantity`$
CREATE PROCEDURE `report_order_quantity`(
  IN _order_id int(10) unsigned
)
BEGIN
  DECLARE _pname varchar(255);

 

    
  IF _order_id IS NOT NULL
  THEN

      SELECT 
            o.id,
            o.order_type,
            c.name as client_name,
            ponumber,
            Date_Format((SELECT max(state_date) 
                           FROM order_state_history os 
                          WHERE os.order_id = o.id
                            AND os.state='POed'),"%m/%d/%Y %H:%i") as order_date,
            CONCAT(od.line_num, '. ', p.name) AS line_num,
            p.id as product_id,
            p.name as product_name,
            quantity_made, 
            quantity_in_process,
            quantity_shipped,
            quantity_requested,
            u.name as uom          
      FROM `order_general` o 
      JOIN order_detail od ON od.order_id = o.id
      LEFT JOIN client c ON o.client_id = c.id   
        JOIN uom u
          ON od.uomid = u.id
      JOIN product p ON od.source_type = 'product' AND od.source_id=p.id
      WHERE o.id = _order_id
        AND o.order_type in ('inventory', 'customer')
        AND od.source_type='product'; 
  END IF;
END$


-- procedure new_order_demand_prediction
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : new_order_demand_prediction.sql
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/2/2018
*    Platform Dependencies  : MySql
*    Description            : Provide data report on the ordered final products vs persistent parts for assemblying the product
*                             This sp only works for Inventory orders or Customer Orders, not supplier orders, because supplier orders do not contain products
*                             Also, the order would only show ordered products in the order, not materials
*                             The report reports on unique products vs unqiue processes, e.g. if an order has multiple lines of same product, the report will
*                             combine them predict based on the product total quantities.
*    example	            : CALL new_order_demand_prediction(7)
*    Log                    :		
*     09/02/2018: Peiyu Ge: first created
*     11/17/2018: Xueyan Dong: rewrote the logics
*     11/18/2018: Xueyan Dong: add if_blocking_ingredient column to output resultset and also sorting by product and process priority.
*                              change priority to pull out from process priority
*/
DELIMITER $  
  DROP PROCEDURE IF EXISTS `new_order_demand_prediction`$
  CREATE PROCEDURE `new_order_demand_prediction`(
   IN _order_id int(10) unsigned
 )
  BEGIN
-- This procedure assume that all same product or material will use the same uom. and the UOM
-- may not be the same as the uom used in recipe.
-- Practically, same product or material may use different uoms depending on order or supplier.
-- will need to deal with this later (Xueyan 10/5/2010)

   DECLARE _consume_step_type_id INT UNSIGNED;
   
   IF _order_id IS NOT NULL
   THEN
  -- find out unique products and ordered quantities in the given order. 
  -- Keep in mind that same products may appear in multiple lines in order_detail table
  DROP TEMPORARY TABLE IF EXISTS ordered_products;
  CREATE TEMPORARY TABLE IF NOT EXISTS ordered_products (
   order_id INT(10) UNSIGNED,
   expected_deliver_date DATETIME,
   ponumber VARCHAR(40),
   product_id INT(10) UNSIGNED,
   min_line_num SMALLINT(5) UNSIGNED,
   quantity_requested DECIMAL(16,4) UNSIGNED,
   quantity_completed DECIMAL(16,4) UNSIGNED,
   quantity_not_dispatched DECIMAL(16,4) UNSIGNED,
   product_name VARCHAR(255),
   product_description TEXT,
   product_group_name VARCHAR(255),
   uom_id SMALLINT(3) UNSIGNED);

  INSERT INTO ordered_products
  (expected_deliver_date,
   ponumber,
   product_id,
   min_line_num,
   quantity_requested,
   quantity_completed,
   quantity_not_dispatched,
   product_name,
   product_description,
   product_group_name,
   uom_id)
  SELECT MIN(IFNULL(d.expected_deliver_date, g.expected_deliver_date)),
         g.ponumber,
         d.source_id,
         MIN(d.line_num),
         SUM(d.quantity_requested),
         SUM(IFNULL(d.quantity_made,0.0)+IFNULL(d.quantity_shipped,0.0)),
         SUM(d.quantity_requested - IFNULL(d.quantity_made,0) - IFNULL(d.quantity_in_process,0)-IFNULL(d.quantity_shipped,0)),
         p.name,
         p.description,
         pg.name,
         d.uomid
    FROM order_general g
    JOIN order_detail d
      ON d.order_id = g.id
         AND d.source_type = 'product'
    JOIN product p
      ON p.id = d.source_id
    JOIN product_group pg
      ON pg.id = p.pg_id
   WHERE g.id =_order_id
     AND g.order_type != 'supplier'
  GROUP BY g.expected_deliver_date, g.priority, g.ponumber, d.source_id, p.name, p.description, pg.name;

  DROP TEMPORARY TABLE IF EXISTS process_bom_final;  
  CREATE TEMPORARY TABLE process_bom_final
  ( process_id INT UNSIGNED,
    process_name VARCHAR(255),
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED, -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    if_blocking_ingredient TINYINT(1) UNSIGNED
    );
 INSERT INTO process_bom_final (process_id, process_name)
  SELECT DISTINCT pp.process_id, p.`name`
    FROM ordered_products op
    JOIN product_process pp 
      ON pp.product_id = op.product_id
    JOIN `process` p
      ON p.id = pp.process_id
         AND p.state = 'production';
         
 SELECT id INTO _consume_step_type_id
    FROM step_type
   WHERE name='consume material';

  DROP TEMPORARY TABLE IF EXISTS process_bom_temp;
  CREATE TEMPORARY TABLE process_bom_temp
  ( process_id INT UNSIGNED,
    process_name VARCHAR(255),
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    ingredient_description TEXT,
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    uom_name VARCHAR(20),
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED, -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    if_blocking_ingredient TINYINT(1) UNSIGNED
    );
    
  -- find persistant ingredients of the processes none sub process steps of the processes
  INSERT INTO process_bom_temp
  (process_id,
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
         pp.process_id,
         pp.process_name,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- non sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = ps.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id;
      
   -- find persistant ingredients of the processes none sub process steps of the processes     
  INSERT INTO process_bom_temp
  (process_id,
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )  
   SELECT 
         pp.process_id,
         pp.process_name,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 1
    JOIN process_step pss -- sub process only allowed 1 depth
      ON pss.process_id = ps.step_id
         AND pss.if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = pss.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id; 
  
  -- same ingredient can appear in the same process multiple times. 
  -- combine the same ingredients and calculated the total quantity needed in the process
  DELETE FROM process_bom_final;
    
  INSERT INTO process_bom_final
  (
   process_id,
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
          process_id,
          process_name,
          ingredient_id,
          source_type,
          sum(recipe_quantity),
          uom_id
    FROM process_bom_temp pb
   GROUP BY process_id, process_name, ingredient_id, source_type, uom_id;
  
  -- remove none persistent material
  DELETE pb
    FROM process_bom_final pb
    JOIN material m
      ON m.id = pb.ingredient_id
         AND m.if_persistent = 0
   WHERE pb.source_type = 'material';
  
  -- mysql limit the use of same temporary table in a query to only once. thus, use process_bom_temp and process_bom_final
  -- to shuffle data during quantity calculation
  
  -- use process_bom_temp to temporarily store intermediate data: inventory quantities of each process/ingredient
  DELETE FROM process_bom_temp;
  INSERT INTO process_bom_temp
  (process_id,
   process_name,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id,
   inventory_quantity
   )
  SELECT pbf.process_id,
         pbf.process_name,
         pbf.ingredient_id,
         pbf.source_type,
         pbf.recipe_quantity,
         pbf.uom_id,
         SUM(IFNULL(CONVERT_QUANTITY(inv.actual_quantity,inv.uom_id, pbf.uom_id),0))
    FROM process_bom_final pbf
    LEFT JOIN inventory inv  -- **** will need to only pull out from designated location
      ON pbf.source_type = inv.source_type
         AND pbf.ingredient_id = inv.pd_or_mt_id
    GROUP BY pbf.process_id, pbf.process_name, pbf.source_type, pbf.ingredient_id, pbf.recipe_quantity, pbf.uom_id;
   
   -- calculate number of final product capable to produce with inventory in hand
   UPDATE process_bom_temp
      SET final_product_qty = inventory_quantity / recipe_quantity;
  
  -- pull out ingredient name and description from either product table or material table
  UPDATE process_bom_temp pbt
    JOIN product p
      ON p.id = pbt.ingredient_id
          SET ingredient_name = p.name,
              ingredient_description = p.description
   WHERE pbt.source_type = 'product';
 
  UPDATE process_bom_temp pbt
    JOIN material m
      ON m.id = pbt.ingredient_id
          SET ingredient_name = m.name,
              ingredient_description =m.description
   WHERE pbt.source_type = 'material';
  
  -- get uom name
  UPDATE process_bom_temp pbt
    JOIN uom u
      ON u.id = pbt.uom_id
     SET pbt.uom_name = u.name;
  
  -- find the blocking ingredient, e.g. the one ingredient that allow minimum final_product_qty
  -- first identify the minimum final product qty decided by ingredient inventory
  DELETE FROM process_bom_final;
  INSERT INTO process_bom_final
  (process_id,
  final_product_qty
  )
  SELECT process_id,
         MIN(final_product_qty)
    FROM process_bom_temp pbt
   GROUP BY process_id;
  
  -- set the if_blocking_ingredient for the ingredients lead to minimum final product
  UPDATE process_bom_temp pbt
    JOIN process_bom_final pbf
      ON pbf.process_id = pbt.process_id
         AND pbf.final_product_qty = pbt.final_product_qty
     SET pbt.if_blocking_ingredient = 1;
  
     
	SELECT
			_order_id,
      g.expected_deliver_date,
			g.ponumber,
			g.product_name, 
      g.product_description,
			g.product_group_name, 
			g.quantity_requested,
			g.quantity_completed,
			g.quantity_not_dispatched,
			u.name as uom,
			pb.process_name,
      pp.priority,
			pb.ingredient_name,
      pb.ingredient_description AS description,
		-- concat(p.quantity," ", p.uom),
			pb.recipe_quantity as quantity,
      pb.inventory_quantity AS unassigned_quantity,
      pb.final_product_qty AS max_product_qty,
      IF(if_blocking_ingredient, 'Y', 'N') AS if_blocking_ingredient

	FROM ordered_products g
  JOIN product_process pp
    ON pp.product_id = g.product_id
  JOIN process_bom_temp pb
    ON pb.process_id = pp.process_id
  JOIN uom u
    ON u.id = g.uom_id
  ORDER BY g.min_line_num, pp.priority desc;
    
  DROP TEMPORARY TABLE ordered_products;
  DROP TEMPORARY TABLE process_bom_final;
  DROP TEMPORARY TABLE process_bom_temp;

   END IF;
  
END$


-- procedure order_dispatch_display_per_product

/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : order_dispatch_display_per_product
*    Created By             : Peiyu Ge & Xueyan Dong
*    Date Created           : 9/10/2018
*    Platform Dependencies  : MySql
*    Description            : This stored procedure serves the grid of the dispatch page, which display orders that
*                             haven't been fully dispatched. 
*                             Note: dispatch only dispatch order detail lines for source_type = product. No need to dispatch material lines
*    example	            : CALL order_dispatch_display_per_product
*    Log                    :	
*    09/10/2018:Peiyu Ge: Created
*    10/29/2018:Xueyan Dong: Added some scripts for easy recompile
*    11/06/2018: Xueyan Dong: rewrite the logics to narrow down data volume processed and add line_num to the resultset.
*/
DELIMITER $
DROP PROCEDURE IF EXISTS order_dispatch_display_per_product$
CREATE PROCEDURE order_dispatch_display_per_product()
BEGIN
   DECLARE _consume_step_type_id INT UNSIGNED;
   
  -- pull out distinct products from order lines to be dispatched
  DROP TEMPORARY TABLE IF EXISTS ordered_products;
  CREATE TEMPORARY TABLE IF NOT EXISTS ordered_products
  (product_id INT UNSIGNED);
  INSERT INTO ordered_products
  (product_id)
  SELECT distinct source_id
  FROM order_general og
  JOIN order_detail od
    ON od.order_id = og.id
       AND od.source_type = 'product'
       AND od.quantity_requested > IFNULL(quantity_made, 0) + IFNULL(quantity_in_process, 0) + IFNULL(quantity_shipped, 0)
 WHERE og.order_type !='supplier'
   AND og.state NOT IN ('shipped', 'delivered');  
 
  DROP TEMPORARY TABLE IF EXISTS product_process_capability;
  CREATE TEMPORARY TABLE product_process_capability
  (product_id INT UNSIGNED,
   process_id INT UNSIGNED,
   process_name VARCHAR(255),
   process_priority TINYINT(2) UNSIGNED,
   final_product_qty INT UNSIGNED);
   
  INSERT INTO product_process_capability (product_id, process_id, process_name, process_priority)
  SELECT pp.product_id, pp.process_id, p.name, pp.priority
    FROM ordered_products op
    JOIN product_process pp
      ON pp.product_id = op.product_id
    JOIN `process` p 
      ON p.id = pp.process_id;
  -- table for holding the capability of each process, which is determined by the scacity of peristent ingredients,
  -- e.g. the ingredient, whose inventory allows the minimum quantity of final product produced
  DROP TEMPORARY TABLE IF EXISTS process_bom_final;
  CREATE TEMPORARY TABLE process_bom_final
  ( process_id INT UNSIGNED,
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
  -- peel out unique processes used by the ordered products
  INSERT INTO process_bom_final (process_id)
  SELECT DISTINCT process_id
    FROM product_process_capability;

      
  SELECT id INTO _consume_step_type_id
    FROM step_type
   WHERE name='consume material';

  DROP TEMPORARY TABLE IF EXISTS process_bom_temp;
  CREATE TEMPORARY TABLE process_bom_temp
  ( process_id INT UNSIGNED,
    ingredient_id INT UNSIGNED,
    ingredient_name VARCHAR(255),
    source_type ENUM('product','material'),    
    recipe_quantity DECIMAL(16,4) UNSIGNED,
    uom_id SMALLINT(2) UNSIGNED,
    inventory_quantity DECIMAL(16,4) UNSIGNED,
    final_product_qty DECIMAL(16,4) UNSIGNED -- store how many final product the inventory can support = inventory_quantity / recipe_quantity
    );
    
  -- find persistant ingredients of the processes none sub process steps of the processes
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
         pp.process_id,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- non sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = ps.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id;
      
   -- find persistant ingredients of the processes none sub process steps of the processes     
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )  
   SELECT 
         pp.process_id,
         ing.ingredient_id,
         ing.source_type,
         ing.quantity,
         ing.uom_id
    FROM process_bom_final pp
    JOIN process_step ps  -- sub process steps
      ON ps.process_id = pp.process_id
         AND if_sub_process = 1
    JOIN process_step pss -- sub process only allowed 1 depth
      ON pss.process_id = ps.step_id
         AND pss.if_sub_process = 0
    JOIN step s  -- find consume material steps
      ON s.id = pss.step_id
         AND step_type_id = _consume_step_type_id
    JOIN ingredients ing
      ON ing.recipe_id  = s.recipe_id; 

  -- same ingredient can appear in the same process multiple times. 
  -- combine the same ingredients and calculated the total quantity needed in the process
  DELETE FROM process_bom_final;
    
  INSERT INTO process_bom_final
  (
   process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id
   )
  SELECT 
          process_id,
          ingredient_id,
          source_type,
          sum(recipe_quantity),
          uom_id
    FROM process_bom_temp pb
   GROUP BY process_id, ingredient_id, source_type, uom_id;
  
  -- remove none persistent material
  DELETE pb
    FROM process_bom_final pb
    JOIN material m
      ON m.id = pb.ingredient_id
         AND m.if_persistent = 0
   WHERE pb.source_type = 'material';
  
  -- mysql limit the use of same temporary table in a query to only once. thus, use process_bom_temp and process_bom_final
  -- to shuffle data during quantity calculation
  
  -- use process_bom_temp to temporarily store intermediate data: inventory quantities of each process/ingredient
  DELETE FROM process_bom_temp;
  INSERT INTO process_bom_temp
  (process_id,
   ingredient_id,
   source_type,
   recipe_quantity,
   uom_id,
   inventory_quantity
   )
  SELECT pbf.process_id,
         pbf.ingredient_id,
         pbf.source_type,
         pbf.recipe_quantity,
         pbf.uom_id,
         SUM(IFNULL(CONVERT_QUANTITY(inv.actual_quantity,inv.uom_id, pbf.uom_id),0))
    FROM process_bom_final pbf
    LEFT JOIN inventory inv  -- **** will need to only pull out from designated location
      ON pbf.source_type = inv.source_type
         AND pbf.ingredient_id = inv.pd_or_mt_id
    GROUP BY pbf.process_id,pbf.source_type, pbf.ingredient_id, pbf.recipe_quantity, pbf.uom_id;
   
   -- calculate number of final product capable to produce with inventory in hand
   UPDATE process_bom_temp
      SET final_product_qty = inventory_quantity / recipe_quantity;
    

   -- identify the minimum final product count that inventory can produce
   DELETE FROM process_bom_final;
   INSERT INTO process_bom_final (process_id, final_product_qty)
   SELECT process_id,
          min(final_product_qty)
     FROM process_bom_temp
     GROUP BY process_id;
  
  -- save capability to product vs process table
  UPDATE product_process_capability ppc
    JOIN process_bom_final pbf
      ON pbf.process_id = ppc.process_id
     SET ppc.final_product_qty = pbf.final_product_qty;
      
 -- produce final result, which is one record per ordered detail line with capabilities of multiple process combined into
 -- one text as product_demand_prediction
 SELECT 
  g.id, 
  g.order_type, 
  g.ponumber, 
  g.client_id,
  c.name as ClientName,
  g.priority,
  d.line_num,
  pr.Name as PriName,
  d.source_id, 
  p.name as ProductName,
  d.quantity_requested, 
  d.quantity_made, 
  d.quantity_in_process, 
  d.quantity_shipped, 
  d.uomid,
  u.Name as uom,
  (SELECT max(state_date) FROM order_state_history h WHERE h.order_id = g.id) AS order_date,
  d.output_date, 
  g.expected_deliver_date, 
  d.actual_deliver_date, 
  g.internal_contact,
  CONCAT(e.firstname,' ',e.lastname) as internal_contact_name,
  g.external_contact, 
  d.comment ,
  g.id as order_id,
  (SELECT GROUP_CONCAT(CONCAT(ppc.process_name, ':', ppc.final_product_qty) SEPARATOR '| ') 
          FROM product_process_capability ppc 
          WHERE ppc.product_id = d.source_id
          ORDER BY ppc.process_priority desc) AS product_demand_prediction
  FROM order_general g
  JOIN order_detail d
    ON d.order_id = g.id
       AND d.source_type = 'product'
       AND d.quantity_requested > IFNULL(d.quantity_made, 0) + IFNULL(d.quantity_in_process, 0) + IFNULL(d.quantity_shipped, 0)
  JOIN product p
    ON p.id = d.source_id
  LEFT JOIN `client` c
    ON c.id = g.client_id
  LEFT JOIN uom u 
    ON u.id = d.uomid
  LEFT JOIN employee e
    ON e.id = g.internal_contact
  LEFT JOIN priority pr
    ON pr.id = g.priority
 WHERE g.order_type !='supplier'
   AND g.state NOT IN ('shipped', 'delivered') 
ORDER BY g.expected_deliver_date desc, g.priority desc, d.line_num;

  DROP TEMPORARY TABLE ordered_products;
  DROP TEMPORARY TABLE product_process_capability;
  DROP TEMPORARY TABLE process_bom_temp;
  DROP TEMPORARY TABLE process_bom_final;


END$

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
*    09/10/2018: Xueyan Dong: fixed all typos and bugs
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_product_group`$
CREATE PROCEDURE `modify_product_group`(
  INOUT _product_group_id int(11) unsigned,
  IN _created_by int(11)unsigned,
  IN _name varchar(255),
  IN _if_active tinyint(1) unsigned,
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
        create_time,
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
                '</DESCRIPTION><DEFAULT_LOCATION_ID>', default_location_id,
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
          SELECT now(),
                'product_group',
                id,
                _oldstate,
				IF(if_active = 1, 'production', 'inactive'),
				created_by,
				concat('product group', name, ' is updated'),
				concat('<PRODUCT_GTOUP><ID>',id, '</ID><NAME>', name,'</NAME><IF_ACTIVE>',if_active,
                '</IF_ACTIVE><DESCRIPTION>',IFNULL(description,''),
                '</DESCRIPTION><DEFAULT_LOCATION_ID>', default_location_id,
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
END$
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : insert_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : insert general information for a new order
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    09/25/2018: Xueyan Dong: added check for entries violating unique key					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `insert_order_general`$
CREATE PROCEDURE `insert_order_general`(
  IN _order_type enum('inventory', 'customer', 'supplier'),
  IN _ponumber varchar(40),
  IN _client_id int(10) unsigned,
  IN _priority tinyint(2) unsigned,
  IN _state varchar(10),
  IN _state_date datetime,
  IN _net_total decimal(16,2) unsigned,
  IN _tax_percentage tinyint(2) unsigned,
  IN _tax_amount decimal(14,2) unsigned,
  IN _other_fees decimal(16,2) unsigned,
  IN _total_price decimal(16,2) unsigned,
  IN _expected_deliver_date datetime,
  IN _internal_contact int(10) unsigned,
  IN _external_contact varchar(255),
  IN _recorder_id int(10) unsigned,
  IN _comment text,
  OUT _order_id int(10) unsigned,
  OUT _response varchar(255)
)
BEGIN
  IF _order_type IS NULL OR length(_order_type )< 1
  THEN
    SET _response='Order type is required. Please select an order type.';
  ELSEIF  _state_date is NULL OR length(_state_date) < 1
  THEN 
    SET _response='Date when the state happened is required. Please fill the state date.';
  ELSEIF  _internal_contact is NULL OR length(_internal_contact) < 1
  THEN 
    SET _response='The internal contact is required. Please fill the contact info.';
  ELSEIF _state IS NULL OR _state NOT IN ('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid')
  THEN
    SET _response='The value for state is not valid. Please select one state from following: quoted, POed, scheduled, produced, shipped, delivered, invoiced, paid.';
  ELSEIF EXISTS (SELECT id FROM order_general WHERE order_type = _order_type AND IFNULL(client_id,0) = IFNULL(_client_id,0) AND IFNULL(ponumber,'') = IFNULL(_ponumber, ''))
  THEN
	SET _response = 'There is another order with the same type, PO and client (or missing both). Please correct them';
  ELSE
    INSERT INTO `order_general` (
         order_type,
         ponumber,
         client_id,
         priority,
         state,
         net_total,
         tax_percentage,
         tax_amount,
         other_fees,
         total_price,
         expected_deliver_date,
         internal_contact,
         external_contact,
         comment)
    values (
          _order_type,
          _ponumber,
          _client_id,
          _priority,
          _state,
          _net_total,
          _tax_percentage,
          _tax_amount,
          _other_fees,
          _total_price,
          _expected_deliver_date,
          _internal_contact,
          _external_contact,
          _comment
         );
        SET _order_id = last_insert_id();
        IF _order_id IS NOT NULL
        THEN
          INSERT INTO order_state_history
          (order_id,
          state,
          state_date,
          recorder_id,
          comment
          )
          VALUES
          (
            _order_id,
            _state,
            _state_date,
            _recorder_id,
            _comment
          );
        END IF;
  END IF;
END $


/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : relocate_inventory.sql
*    Created By             : Peiyu Ge
*    Date Created           : 10/16/2018
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*     
*	 				
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS relocate_inventory$
CREATE PROCEDURE relocate_inventory (
  IN _source_type enum('product', 'material'),
  IN _pd_or_mt_id int(10) unsigned,
  IN _supplier_id int(10) unsigned,
  IN _lot_id varchar(20),
  IN _serial_no varchar(20),
  IN _out_order_id varchar(20),
  IN _in_order_id varchar(20),
  IN _original_quantity decimal(16,4) unsigned,
  IN _actual_quantity decimal(16,4) unsigned,
  IN _uom_id smallint(3) unsigned,
  IN _manufacture_date datetime,
  IN _expiration_date datetime,
  IN _arrive_date datetime,
  IN _recorded_by int(10) unsigned,
  IN _contact_employee int(10) unsigned,
  IN _comment text,
  IN _location_id int(11) unsigned,
  IN _inventory_id int(10) unsigned,
  IN _quantity_relocate decimal(16,4) unsigned,
  IN _location_id_relocate int(11) unsigned,
  IN _new_comment text,
  OUT _response varchar(255)
)
BEGIN

	DECLARE ending int(10);
	DECLARE new_serial_no varchar(255);
    DECLARE new_id int(10);

	-- check if user's input of quantity to relocate is valid or not 0
	IF Length(_quantity_relocate)=0 or cast(_quantity_relocate as Decimal(16,4)) = 0.0000
	Then
		SET _response = 'Relocation quantity can not be 0 or null. Please select again.';
	-- check if relocate greater than current acutal quantity
    ELSEIF cast(_quantity_relocate as Decimal(16,4)) > cast(_actual_quantity as Decimal(16,4)) 
    THEN 
        SET _response = 'The quantity to be relocated is greater than acutal quantity. Please select again.';
	-- check if relocation is same as current location
    ELSEIF _location_id_relocate = _location_id
    Then
		SET _response = 'Your selection of location to relocate is the same as the current one. Please select again.';
	
	-- query DB:
		 -- product info matches (source, pd, supplier, lot)
			-- serial_no of parent/descendant-of-itself in record
-- case 1        -- and new location in record -> merge two records
-- case 2        -- but new location not in record -> create a new serial_no and insert as a record (strategy: find the max serial_no of its children, incremente by 1
-- records in DB:
--   source_type   pt_or_mt_id   supplier_id   lot_id     serial_no   location_id   actual_quantity
-- A: "material"		8		    5		  HS000001   HS000001-001     1        100 - 30 = 70 => 70 -10 = 60
-- B: "material"		8			5		  HS000001   HS000001-002     1         95
-- C: "material"		8			5		  HS000001   HS000001-003     1        40
-- D: "material"		8			5		  HS000001   HS000001-001-1   2        0+30 = 30 => 30 + 10 = 40 => 40-5 =35
-- E: "material"		8			5		  HS000001   HS000001-001-1-1 3        0+5 = 5
-- F: "material"		8		    5		  HS000001   HS000001-001-2   4  
-- examples:
   -- three records A, B, C in DB
   -- A relocate 30 to location 2: case 2
   -- Now A, B, C, D in DB
   -- A continue to relocate 10 to location 2: case 1
   -- D relocate 5 to location 3: case 2
   -- Now A, B, C, D, E in DB
   -- if A relocate 20 to location 4, then case 2
   
    -- case 1
    ELSEIF If(Length(_serial_no)=0, Exists (Select * from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and location_id = _location_id_relocate and (serial_no like "%" or serial_no is null)), Exists (Select * from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and location_id = _location_id_relocate and serial_no Like concat(_serial_no, "%")))-- if(serial_no is null, serial_no is null or serial_no Like "%", serial_no Like concat(_serial_no,"%")) 																				--cast(_quantity_relocate as Decimal(16,4)) = cast(_actual_quantity as Decimal(16,4))
	THEN 
		If Length(_serial_no)=0
        Then
			Select id Into new_id
			from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and (serial_no Like "%" or serial_no is null) and location_id = _location_id_relocate Order By serial_no Desc Limit 1;
		Else
            Select id Into new_id
			from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and serial_no Like concat(_serial_no,"%") and location_id = _location_id_relocate Order By serial_no Desc Limit 1;
        End If;

        UPDATE inventory
			SET actual_quantity = actual_quantity + _quantity_relocate
				,comment = CONCAT(comment, ";",_new_comment) -- " Relocated from: " + _serial_no + " ,Quantity: " + quantity_relocate + " ,comment: " + trim(_new_comment)+ ".")
			WHERE id = new_id;
            
        IF _quantity_relocate = _actual_quantity
        Then
            Delete from inventory
            where id = _inventory_id;
		Else
            UPDATE inventory
			SET actual_quantity = actual_quantity - _quantity_relocate
			WHERE id=_inventory_id;
		End IF;
	-- case 2
    ELSEIF If(Length(_serial_no)=0, Exists (Select * from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and (serial_no like "%" or serial_no is null)), Exists (Select * from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and serial_no Like concat(_serial_no, "%"))) -- exists (Select * from inventory where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and (serial_no Like concat(_serial_no,"%") or serial_no Like "%" or serial_no is null))
	Then
	  If Length(_serial_no) = 0
      Then
		  Select Max(CONVERT(substring_index(substring(ifnull(serial_no, ""), 1), "-", 1), UNSIGNED INTEGER)) Into ending
		  from inventory
		  where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and (serial_no Like "%" or serial_no is null);-- serial_no Like concat(_serial_no, "%");
      Else
          Select Max(CONVERT(substring_index(substring(ifnull(serial_no, ""), Length(_serial_no)+ 2), "-", 1), UNSIGNED INTEGER)) Into ending
          from inventory
		  where source_type = _source_type and pd_or_mt_id = _pd_or_mt_id and supplier_id = _supplier_id and lot_id = _lot_id and serial_no Like concat(_serial_no,"%");
      End If;
      SET new_serial_no = if(Length(_serial_no) = 0, concat("", ending+1), concat(_serial_no, "-", ending+1));
      
      IF _quantity_relocate = _actual_quantity
      Then
		  Update inventory
		    Set serial_no = new_serial_no
            , location_id = _location_id_relocate
            , comment = concat(comment, ";", _new_comment)
		  Where id = _inventory_id;
	  Else
          INSERT INTO inventory(
			  source_type,
			  pd_or_mt_id,
			  supplier_id,
			  lot_id,
			  serial_no,
			  out_order_id,
			  in_order_id,
			  original_quantity,
			  actual_quantity,
			  uom_id,
			  manufacture_date,
			  expiration_date,
			  arrive_date,
			  recorded_by,
			  contact_employee,
			  comment,
			  location_id
		  )
		  values (
			  _source_type,
			  _pd_or_mt_id,
			  _supplier_id,
			  _lot_id,
			  new_serial_no,
			  _out_order_id,
			  _in_order_id,
			  _original_quantity,
			  _quantity_relocate,
			  _uom_id,
			  _manufacture_date, 
			  _expiration_date, 
			  _arrive_date, 
			  _recorded_by,
			  _contact_employee,
			  _new_comment,
			  _location_id_relocate
			);
	    -- SET _inventory_id = last_insert_id();
        UPDATE inventory
			SET actual_quantity = actual_quantity - _quantity_relocate
			WHERE id=_inventory_id;
       End IF; 
		
	END IF;	
    
	
END$
/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : duplicate_process.sql
*    Created By             : JunLu
*    Date Created           : 12/15/2018
*    Platform Dependencies  : MySql
*    Description            : 
*    example	              :
        CALL duplicate_process (7, 2, @resp, @new_id);
        SELECT @resp, @new_id;
*    Log                    :
*    12/152018: Junlu Luo: First Created
*/
DELIMITER $ 
DROP PROCEDURE IF EXISTS `duplicate_process`$
CREATE procedure duplicate_process (
  IN _old_process_id int(10) unsigned,
  IN _employee_id int(10) unsigned,
  OUT _response varchar(255),
  OUT _new_process_id int(10) unsigned
) 
BEGIN
  SET _response = "";
  
  -- make sure the name of duplicate process is unique
  SET @name = "";
  SET @prg_id = 0;
  SET @versoin = 0;
  
  SELECT `name`, `version`, `prg_id` INTO @name, @version, @prg_id
  FROM process
  WHERE id = _old_process_id;
  
  SET @count = 1;
  WHILE @count > 0 DO
    SET @name = CONCAT(@name, ' - Copy');
    SELECT COUNT(*) INTO @count
    FROM process
    WHERE `name` = @name AND `prg_id` = @prg_id AND `version` = @version;
  END WHILE;
  
  -- duplicate process
  INSERT INTO process (
    `name`,
    `version`,
    `prg_id`,
    `state`,
    `start_pos_id`,
    `owner_id`,
    `if_default_version`,
    `create_time`,
    `created_by`,
    `state_change_time`,
    `state_changed_by`,
    `usage`,
    `description`,
    `comment`
  )
  SELECT @name,
    `version`,
    `prg_id`,
    `state`,
    `start_pos_id`,
    _employee_id,
    `if_default_version`,
    `create_time`,
    `created_by`,
    `state_change_time`,
    `state_changed_by`,
    `usage`,
    `description`,
    `comment`
  FROM process
  WHERE id = _old_process_id;
  
  -- newly created process id
  SET _new_process_id = last_insert_id();
  
  -- insert an entry to the history
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
    'process',
    id,
    null,
    state,
    created_by,
    concat('process', name , 'is created'),
    concat('<PROCESS><PRG_ID>',prg_id, '</PRG_ID><NAME>', name,
    '</NAME><VERSION>',`version`,'</VERSION><STATE>',state,
      '</STATE><START_POS_ID>', start_pos_id, '</START_POS_ID><OWNER_ID>',owner_id,
      '</OWNER_ID><IF_DEFAULT_VERSION>',if_default_version,'</IF_DEFAULT_VERSION><CREATE_TIME>',create_time,
      '</CREATE_TIME><CREATED_BY>',created_by,
      '</CREATED_BY><STATE_CHANGE_TIME>',IFNULL(state_change_time, ''),
      '</STATE_CHANGE_TIME><STATE_CHANGED_BY>',IFNULL(state_changed_by,''),
      '</STATE_CHANGED_BY><USAGE>', `usage`, 
      '</USAGE><DESCRIPTION>',IFNULL(description,''),
      '</DESCRIPTION><COMMENT>',IFNULL(comment,''),
      '</COMMENT></PROCESS>')
  FROM process
  WHERE id = _new_process_id;

  -- copy steps
  INSERT INTO process_step (
    `process_id`,
    `position_id`,
    `step_id`,
    `prev_step_pos`,
    `next_step_pos`,
    `false_step_pos`,
    `segment_id`,
    `rework_limit`,
    `if_sub_process`,
    `prompt`,
    `if_autostart`,
    `need_approval`,
    `approve_emp_usage`,
    `approve_emp_id`,
    `product_made`
  )
  SELECT 
    _new_process_id,
    `position_id`,
    `step_id`,
    `prev_step_pos`,
    `next_step_pos`,
    `false_step_pos`,
    `segment_id`,
    `rework_limit`,
    `if_sub_process`,
    `prompt`,
    `if_autostart`,
    `need_approval`,
    `approve_emp_usage`,
    `approve_emp_id`,
    `product_made`
  FROM process_step
  WHERE process_id = _old_process_id;
  
END$

/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_location.sql
*    Created By             : Peiyu Ge
*    Date Created           : 12/21/2018
*    Platform Dependencies  : MySql
*    Description            : Insert or update location into the location table
*    example	            : 
*    Log                    : 1/21/2019 fixed the error: can not insert or update when all adjacent locations are null when there exists a different named location with all null ajdacent locations
*/
DELIMITER $

DROP PROCEDURE IF EXISTS `modify_location`$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_location`(
  INOUT _location_id int(10) unsigned,
  IN _name varchar(255),
  IN _parent_loc_id int(11) unsigned,
  IN _adjacent_loc_id1 int(5) unsigned,
  IN _adjacent_loc_id2 int(5) unsigned,
  IN _adjacent_loc_id3 int(5) unsigned,
  IN _adjacent_loc_id4 int(5) unsigned,
  IN _contact_employee int(10) unsigned,
  IN _description varchar(255),
  IN _comment text,
  OUT _response varchar(255))
BEGIN
	DECLARE created_time datetime;
    DECLARE ifexist varchar(255);
    DECLARE ifoccupied varchar(255);
    If _name is Null Or Length(Trim(_name)) = 0 Then
		Set _response = "Location name is missing.";
	Elseif _contact_employee is Null Then
		Set _response = "Contact Employee is missing.";
	Elseif _adjacent_loc_id1 = _adjacent_loc_id2 or _adjacent_loc_id1 = _adjacent_loc_id3 or _adjacent_loc_id1 = _adjacent_loc_id4 or _adjacent_loc_id2 = _adjacent_loc_id3 or _adjacent_loc_id2 = _adjacent_loc_id4 or _adjacent_loc_id3 = _adjacent_loc_id4 Then
		Set _response = "Adjacent locations should be different from each other.";
	Elseif _location_id is Null Then -- new location to be inserted
		-- check if already exists location with the same name and same parent location
        Select name into ifexist
        from location
        where name = _name and if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id);
        
        If ifexist is Null Then -- 
        -- check if the location has been occupied: if adjacent four ids are all null or any one of them is null, then we assume the location's physical location is not defined yet
		-- thus ifoccupied is null(can be put in any place); later, when we have more knowledge about adjacent locations and what are valid combination of four adjacent locations
		-- we need to add check adjacent location combinations are valid.
			If (_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is not null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is not null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is not null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is not null) Then
				Set ifexist = null;
			Else
				Select name into ifoccupied
				From location
				where if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
				and if(_adjacent_loc_id1 is null, adjacent_loc_id1 is null, adjacent_loc_id1 = _adjacent_loc_id1)
				and if(_adjacent_loc_id2 is null, adjacent_loc_id2 is null, adjacent_loc_id2 = _adjacent_loc_id2)
				and if(_adjacent_loc_id3 is null, adjacent_loc_id3 is null, adjacent_loc_id3 = _adjacent_loc_id3)
				and if(_adjacent_loc_id4 is null, adjacent_loc_id4 is null, adjacent_loc_id4 = _adjacent_loc_id4)
				and name != _name;
            End if;
			
			If ifoccupied is Null Then -- insert new location
				INSERT INTO location (
					name,
					parent_loc_id,
					create_time,
					update_time,
					contact_employee,
					adjacent_loc_id1,
					adjacent_loc_id2,
					adjacent_loc_id3,
					adjacent_loc_id4,
					description,
					comment
				  )
				  VALUES (
					_name,
					_parent_loc_id,
					Now(),
					Null,
					_contact_employee,
					_adjacent_loc_id1,
					_adjacent_loc_id2,
					_adjacent_loc_id3,
					_adjacent_loc_id4,
					_description,
					_comment
				  );
				  SET _location_id = last_insert_id();
			Else
				Set _response = Concat("The location you are about to insert into is occupied by ", ifoccupied, " .");
			End If;
		Else
			Set _response = Concat("The location name \"", ifexist, "\" alread exists.");
		End If;
	Elseif _location_id is not Null Then -- update location
		Select name into ifexist
        from location
        where name = _name
        and if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
        and id != _location_id; -- For a same parent location, exists a same named location
        
        If ifexist is Null Then
		
			If (_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is not null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is not null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is not null and _adjacent_loc_id4 is null) or
			(_adjacent_loc_id1 is null and _adjacent_loc_id2 is null and _adjacent_loc_id3 is null and _adjacent_loc_id4 is not null) Then
				Set ifoccupied = null;
			Else
				Select name into ifoccupied
				from location
				where if(_parent_loc_id is null, parent_loc_id is null, parent_loc_id = _parent_loc_id)
				and if(_adjacent_loc_id1 is null, adjacent_loc_id1 is null, adjacent_loc_id1 = _adjacent_loc_id1)
				and if(_adjacent_loc_id2 is null, adjacent_loc_id2 is null, adjacent_loc_id2 = _adjacent_loc_id2)
				and if(_adjacent_loc_id3 is null, adjacent_loc_id3 is null, adjacent_loc_id3 = _adjacent_loc_id3)
				and if(_adjacent_loc_id4 is null, adjacent_loc_id4 is null, adjacent_loc_id4 = _adjacent_loc_id4)
				and id != _location_id; -- check if exists another id that has the same adjacent locations
			End if;
            
            If ifoccupied is Null Then
				Select create_time into created_time
                from location
                where id = _location_id;
                
				Update location
					Set name = _name,
						parent_loc_id = _parent_loc_id,
                        contact_employee = _contact_employee,
                        create_time = created_time,
                        update_time = Now(),
                        adjacent_loc_id1 = _adjacent_loc_id1,
						adjacent_loc_id2 = _adjacent_loc_id2,
						adjacent_loc_id3 = _adjacent_loc_id3,
						adjacent_loc_id4 = _adjacent_loc_id4,
                        description = _description,
                        comment = _comment
					where id = _location_id;
			Else
				Set _response = Concat("The updated location is occupied by ", ifoccupied, " .");
			End if;
		Else
			Set _response = Concat("The updated location name \"", ifexist, "\" alread exists.");           
        End if;
        
	End if;
    
END$

/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : report_order.sql
*    Created By             : Peiyu Ge 
*    Date Created           : 1/13/2019
*    Platform Dependencies  : MySql
*    Description            : Given an order id, list all products in that order if product_id and lot_status are not provide. Otherwise list only specified products.
*    example	            : 
*    Log                    :1/25/19 revised code to account for null selection of product_id, so basicly when product_id is null, display all products in the given order. 					
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `report_order`$
CREATE PROCEDURE `report_order`(
  IN _order_id int(10) unsigned,
  IN _product_id int(10) unsigned,
  IN _lot_status enum('dispatched','in process','in transit','hold','to warehouse','shipped','scrapped', 'done'),
  OUT _response varchar(255)
)
BEGIN
-- given an order id, a product_id and lot_status, shows reports on other information of the given product in the order at the current status
-- 1/13/2019

IF _order_id IS NULL
  THEN
    SET _response = "Order is required. Please select an order.";
ELSEIF _product_id IS NULL OR length(_product_id) = 0 Then
	SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           l.order_line_num as po_linenumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           get_local_time(str_to_date(l.update_timecode, '%Y%m%d%H%i%s0' )) AS last_move_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           IF(h.status='dispatched','',(select name from step s1 where s1.id = lh1.step_id))as pre_step,-- dispatch has no previous step , position 1 without reposition has no prvious step either
           'next' as pre_step,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
            
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
		   FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)
		   Left join lot_history lh1 on lh1.lot_id = h.lot_id and lh1.start_timecode = (SELECT start_timecode from lot_history lh2-- start_timecode from lot_history lh1
                                          WHERE lh2.lot_id=h.lot_id
                                            order by start_timecode desc
                                            limit 1
										    offset 1)
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
           LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h.position_id = 0, 1, h.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
     WHERE l.order_id = _order_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
Else 
	SELECT h.lot_id,
           h.lot_alias,
           -- l.order_id,
           l.order_line_num as po_linenumber,
           -- l.product_id,
           pd.name as product_name,
           -- l.process_id,
           pc.name as process_name,
           l.status as lot_status,
           l.start_quantity,
           l.actual_quantity,
           -- l.uomid,
           u.name as uom,
           get_local_time(l.dispatch_time) AS dispatch_time,
           get_local_time(str_to_date(l.update_timecode, '%Y%m%d%H%i%s0' )) AS last_move_time,
           -- l.dispatcher,
           CONCAT(e.firstname, ' ', e.lastname) AS dispatcher,
           -- l.contact,
           CONCAT(e2.firstname, ' ', e2.lastname) AS contact,
           -- l.priority
           p.name as priority,
           IF(h.status='dispatched', -- dispatch has no previous step , position 1 without reposition has no prvious step either
			'',
		   (select name from step s1, lot_history lh
			Where lh.start_timecode = (select max(start_timecode) from lot_history where start_timecode < (select max(start_timecode) from lot_history where lot_id = h.lot_id)) 
			   and lh.lot_id = h.lot_id
               and s1.id = lh.step_id
			  )
			)as pre_step,
           s.name as step_name,
           if(st.name = 'condition', 
			  if(h.status = 'started', concat((select name from step where id = ps2.step_id), '/', (select name from step where id = ps3.step_id)), if(h.result = 'True', (select name from step where id = ps2.step_id), (select name from step where id = ps3.step_id))),
              if(st.name = 'reposition', (select name from step where id = substring_index(h.result,',',-1)), if(h.position_id = 0, (select name from step where id = ps1.step_id), (select name from step where id = ps2.step_id)))
			 ) as next_step,
            
           IF(h.status='dispatched' , 
                 '', 
                 h.status) as step_status,
           get_local_time(str_to_date(h.start_timecode, '%Y%m%d%H%i%s0' )) as last_step_starttime
		   FROM lot_status l INNER JOIN lot_history h ON l.id = h.lot_id
		   AND h.start_timecode = (SELECT MAX(start_timecode)
									FROM lot_history h2
							  WHERE h2.lot_id=h.lot_id)      
           LEFT JOIN order_general og ON og.id = l.order_id
           LEFT JOIN product pd ON pd.id = l.product_id
           LEFT JOIN process pc ON pc.id = l.process_id
           LEFT JOIN uom u ON u.id = l.uomid
           LEFT JOIN employee e ON e.id = l.dispatcher
           LEFT JOIN employee e2 ON e2.id = l.contact
           LEFT JOIN priority p ON p.id = l.priority
           LEFT JOIN step s ON s.id = h.step_id
           LEFT JOIN step_type st ON st.id = s.step_type_id
           LEFT JOIN process_step ps1 on ps1.process_id = l.process_id and ps1.position_id = if(h.position_id = 0, 1, h.position_id)
           LEFT JOIN process_step ps2 on ps2.process_id = ps1.process_id and ps2.position_id = ps1.next_step_pos
           LEFT JOIN process_step ps3 on ps3.process_id = ps2.process_id and ps3.position_id = ps1.false_step_pos
     WHERE l.order_id = _order_id
       AND l.product_id = _product_id
       AND (_lot_status is null OR _lot_status= l.status)
     ORDER BY l.status;
end if;
END $

