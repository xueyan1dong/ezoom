/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_attribute_history.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `attribute_history`$
CREATE TABLE `attribute_history` (
  `event_time` datetime NOT NULL,
  `employee_id` int(10) unsigned NOT NULL,
  `action` enum('insert','modify','delete') NOT NULL,
  `parent_type` enum('product', 'equipment','dc_def_main') NOT NULL,
  `parent_id` int(10) unsigned NOT NULL,
  `attr_id` int(10) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `attr_type` enum('in','out','both') NOT NULL DEFAULT 'both',
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time', 'text', 'mediumtext', 'longtext','enum') DEFAULT NULL,
  `length` tinyint(3) unsigned DEFAULT NULL,
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,
  `data_table_name` varchar(60) DEFAULT NULL,
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '0', 
  `uom_id` smallint(3) unsigned DEFAULT NULL,
  `attr_value` varchar(255) DEFAULT NULL,
  `max_value` varchar(255) DEFAULT NULL,
  `min_value` varchar(255) DEFAULT NULL,
  `enum_values` varchar(255) DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`event_time`,`parent_type`, `parent_id`, `attr_id`)
) ENGINE=InnoDB$
