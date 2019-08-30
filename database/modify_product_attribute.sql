/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : modify_product_attribute.sql
*    Created By             : JunLu
*    Date Created           : 2019
*    Platform Dependencies  : MySql
*    Description            : if _attr_id is NULL, then it is INSERT otherwise it is UPDATE
*    example	            : 

		CALL modify_product_attribute ('MODIFY', 2, 6, 1, 'Burnish Nicket Mod', 'What is this', @response);
		SELECT @response AS resp;
    
		CALL modify_product_attribute ('INSERT', 2, 6, 1, 'Burnish Nickel 1', 'test comment', @response);
		SELECT @response AS resp;
    
*    Log                    :
  
*/
DELIMITER $  -- for escaping purpose
DROP PROCEDURE IF EXISTS `modify_product_attribute`$
CREATE procedure modify_product_attribute (
	IN _operation VARCHAR(32),
	IN _recorder_id INT,
	IN _product_id INT,
	IN _attr_id INT,
	IN _attr_value VARCHAR(256),
	IN _comment VARCHAR(512),
	OUT _response VARCHAR(256)
)
MOD_PROD_ATTR: BEGIN
	SET @eventtime = NOW();
	SET _response = '';
	
	-- check value
	IF _attr_value IS NULL OR LENGTH(_attr_value) = 0 THEN
		SET _response = 'Attribute value cannot be NULL or empty.';
		LEAVE MOD_PROD_ATTR;
	END IF;
	
	-- retrieve values of the selected attribute 
	SET @attr_parent_type = NULL;
	SET @attr_usage = NULL;
	SET @data_type = NULL;
	SET @decimal_length = NULL;
	SET @description = NULL;
	SET @max_value = '';
	SET @min_value = '';
	SET @enum_values = '';
	SET @key_attr = NULL;
	SET @length = NULL;
	SET @optional = NULL;
	SET @uom_id = NULL;
		
	SELECT attr_name,
		attr_parent_type,
		attr_usage,
		data_type,
		decimal_length,
		description,
		enum_values,
		key_attr,
		length,
		max_value,
		min_value,
		optional,
		uom_id
	INTO @attr_name,
		@attr_parent_type,
		@attr_usage,
		@data_type,
		@decimal_length,
		@description,
		@enum_values,
		@key_attr,
		@length,
		@max_value,
		@min_value,
		@optional,
		@uom_id
	FROM attribute_definition
	WHERE attr_id = _attr_id;
		
	-- check max value
	IF @max_value IS NOT NULL AND _attr_value > @max_value THEN
		SET _response = CONCAT('Attribute''s max value is ', @max_value);
		LEAVE MOD_PROD_ATTR;
	END IF;
			
	-- check min value
	IF @min_value IS NOT NULL AND _attr_value < @min_value THEN
		SET _response = CONCAT('Attribute''s min value is ', @min_value);
		LEAVE MOD_PROD_ATTR;
	END IF;
			
	-- check enum value
	IF @enum_values IS NOT NULL AND INSTR(@enum_values, _attr_value) < 0 THEN
		SET _response = CONCAT('Attribute value can only be one of ', @enum_values);
		LEAVE MOD_PROD_ATTR;
	END IF;
	
	-- check existance of the entry in attribute_value table
	SET @nCount = 0;
	SELECT COUNT(*) INTO @nCount
	FROM attribute_value
	WHERE parent_id=_product_id AND attr_id=_attr_id;

	-- INSERT operation
	IF _operation = 'INSERT' THEN
		-- make sure the entry does not exist
		IF @nCount != 0 THEN
			SET _response = CONCAT(@attr_name, ' is already an attribute of the product.');
			LEAVE MOD_PROD_ATTR;
		END IF;
		
		-- insert operation
		INSERT INTO attribute_value (
			`parent_id`,
			`attr_id`,
			`attr_value`,
			`create_date`,
			`update_date`,
			`recorder`,
			`comment`
		) VALUES (
			_product_id,
			_attr_id,
			_attr_value,
			@eventtime,
			@eventtime,
			_recorder_id,
			_comment
		);
	END IF;

	-- MODIFY operation
	IF _operation = 'MODIFY' THEN
		-- make sure the entry exists
		IF @nCount = 0 THEN
			SET _response = CONCAT(@attr_name, ' is not an attribute of the product.');
			LEAVE MOD_PROD_ATTR;
		END IF;
		
		-- modify operation
		UPDATE attribute_value
		SET `attr_value` = _attr_value,
			`update_date` = @eventtime,
      `recorder`=_recorder_id,
			`comment` = _comment
		WHERE `parent_id`=_product_id AND `attr_id`=_attr_id;
	END IF;

	-- update attribute history
	INSERT INTO attribute_history (
		`uom_id`,
		`parent_type`,
		`parent_id`,
		`optional`,
		`min_value`,
		`max_value`,
		`length`,
		`key_attr`,
		`event_time`,
		`enum_values`,
		`employee_id`,
		`description`,
		`decimal_length`,
		`data_type`,
		-- `data_table_name`,
		`comment`,
		`attr_value`,
		`attr_type`,
		`attr_name`,
		`attr_id`,
		`action`
	) VALUES (
		@uom_id,
		@attr_parent_type,
		_product_id,
		@optional,
		@min_value,
		@max_value,
		@length,
		@key_attr,
		@eventtime,
		@enum_values,
		_recorder_id,
		@description,
		@decimal_length,
		@data_typ,
		_comment,
		_attr_value,
		@attr_usage,
		@attr_name,
		_attr_id,
		_operation		
	);
END$
