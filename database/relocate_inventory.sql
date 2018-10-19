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