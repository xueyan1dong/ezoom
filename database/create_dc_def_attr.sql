/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : <sqlfilename>
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `dc_def_attr`$
CREATE TABLE  `dc_def_attr` (
  `def_id` int(10) unsigned NOT NULL,
  `attr_id` tinyint(3) unsigned NOT NULL,
  `attr_name` varchar(255) NOT NULL,
  `data_type` enum('decimal','signed integer','unsigned integer','signed big integer','unsigned big integer','varchar','char','date','datetime','time', 'text', 'mediumtext', 'longtext','enum') NOT NULL,
  `length` tinyint(3) unsigned DEFAULT NULL,
  `decimal_length` tinyint(1) unsigned DEFAULT NULL,
  `key_attr` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `optional` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `uom_id` smallint(3) unsigned DEFAULT NULL,
  `attr_value` text DEFAULT NULL,
  `max_value` text DEFAULT NULL,
  `min_value` text DEFAULT NULL,
  `enum_values` text DEFAULT NULL,
  `description` text CHARACTER SET latin1,
  `comment` text CHARACTER SET latin1,
  PRIMARY KEY (`def_id`, `attr_id`)
) ENGINE=InnoDB$