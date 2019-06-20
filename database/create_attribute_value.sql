/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_attribute_value.sql
*    Created By             : Xueyan Dong
*    Date Created           : 06/19/2019
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Xueyan Dong: First Created					
*/
DELIMITER $  
DROP TABLE IF EXISTS `attribute_value`$
CREATE TABLE `attribute_value` (
  `parent_id` int(10) unsigned NOT NULL,  -- the id of the parent object. For example, if parent type is product, then it is a product id
  `attr_id` int(11) unsigned NOT NULL,  -- id of the attribute definition
  `attr_value` text DEFAULT NULL,  -- value of the attribute for the parent object
  `create_date` datetime DEFAULT NULL, -- datetime that the value is created
  `update_date` datetime DEFAULT NULL, -- datetime that the value is updated
  `recorder` int(10) DEFAULT NULL, -- the id of the employee who input the value in ezoom
  `comment` text,  -- any comment regarding the value
  PRIMARY KEY (`parent_id`,`attr_id`)
) ENGINE=InnoDB$
