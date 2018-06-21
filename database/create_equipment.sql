/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_equipment.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `equipment`$
CREATE TABLE  `equipment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eg_id` int(10) unsigned zerofill DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `state` enum('inactive','up','down','qual','checkout','checkin') NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `manufacture_date` date DEFAULT NULL,
  `manufacturer` varchar(255) DEFAULT NULL,
  `manufacturer_phone` varchar(50) DEFAULT NULL,
  `online_date` date DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `eq_un1` (`eg_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$