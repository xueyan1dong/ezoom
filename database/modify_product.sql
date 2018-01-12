DROP PROCEDURE IF EXISTS `modify_product`;
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
END;
