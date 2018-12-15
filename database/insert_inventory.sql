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
*	 8/16/2018: Peiyu Ge: added location_id
*	 12/13/20: Peiyu Ge: deleted the constraint "can not be zero" for _original_quantity. Zero is a valid input now.			
*/
DELIMITER $  -- for escaping purpose
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
