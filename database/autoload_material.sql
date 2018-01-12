DROP PROCEDURE IF EXISTS `autoload_material`;

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
END;
