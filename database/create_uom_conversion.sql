/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_uom_conversion.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `uom_conversion`$
CREATE TABLE `uom_conversion` (
  `from_id` smallint(3) unsigned NOT NULL ,
  `to_id` smallint(3) unsigned NOT NULL ,
  `method` enum('ratio', 'reduction', 'addtion') NOT NULL,
  `constant` decimal(16,4) unsigned NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`from_id`, `to_id`)
) ENGINE=InnoDB$