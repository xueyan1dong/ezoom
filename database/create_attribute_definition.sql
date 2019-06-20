/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_attribute_definition.sql
*    Created By             : Xueyan Dong
*    Date Created           : 06/19/2019
*    Platform Dependencies  : MySql
*    Description            : This table stores attribute defintions. Attribute can be for materials or for products or potentially for any objects in eZOOM'
*                             this table describes the defintion of these attributes. Actual values will be stored in the attribute value table. Attributes are
*                             for storing charateristics of object instances that may not be rudimentary for the software, but needed for actual operation.alter
*                             Each object may have values of different attributes.
*    example	            : 
*    Log                    :
*    6/19/2018: Xueyan Dong: First Created. 					
*/
DELIMITER $ 
DROP TABLE IF EXISTS `attribute_definition`$
CREATE TABLE `attribute_definition` (
  `attr_id` int(11) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- unique id of the attribute
  `attr_name` nvarchar(255) NOT NULL,  -- name of the attribute
  `attr_usage` enum('in','out','both') NOT NULL DEFAULT 'both', -- used as input or output or both
  -- the object type that the attribute belongs to. for example product attributes, material attributes or employeeattributes
  `attr_parent_type` enum('product', 'material','employee'), 
  -- data type of the attribute. 
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time', 'text', 'mediumtext', 'longtext','enum') NOT NULL,
  `length` smallint(5) unsigned DEFAULT NULL,  -- max length of the value. For decimal, the max length of the integral part
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,  -- max length of the decimal part of the value
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether the attribute is key attribute, which requires value by the parent object
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0', -- whether the attribute is optional, which the parent object may not set up value
  `uom_id` smallint(3) unsigned DEFAULT NULL,  -- unit of measure of the attribute value if data_type is numerical measurement
  `max_value` text DEFAULT NULL,  -- max value of the attribute value can have
  `min_value` text DEFAULT NULL,  -- min value of the attribute value can have
  `enum_values` text DEFAULT NULL,  -- all possible enumeration values of the attribute can have
  `description` text DEFAULT NULL,  -- description of the attribute definition
  `comment` text DEFAULT NULL, -- extra comment for the attribute, if any
  `create_date` datetime DEFAULT NULL,  -- datetime that the attribute definitoin is created here
  `update_date` datetime DEFAULT NULL -- datetime that the attribute defintion is updated
) ENGINE=InnoDB$


