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
DROP TABLE IF EXISTS `dc_def_main`$
CREATE TABLE  `dc_def_main` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `contact_emp` int(10) unsigned DEFAULT NULL,
  `target` enum('product', 'equipment', 'supply') NOT NULL,
  `data_table_name` varchar(60) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `description` text DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$