/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_step.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `step`$
CREATE TABLE `step` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `step_type_id` int(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') CHARACTER SET latin1 DEFAULT NULL,
  `eq_usage` enum('eq group','equipment')  DEFAULT NULL,
  `eq_id` int(10) unsigned DEFAULT NULL,
  `emp_usage` enum('employee group','employee')  DEFAULT NULL,
  `emp_id` int(10) unsigned DEFAULT NULL,
  `recipe_id` int(10) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `para_count` tinyint(3) DEFAULT NULL,
  `description` text ,
  `comment` text ,  
  `para1` text,
  `para2` text,
  `para3` text,
  `para4` text,
  `para5` text,
  `para6` text,
  `para7` text,
  `para8` text,
  `para9` text,
  `para10` text,  
  PRIMARY KEY (`id`),
  UNIQUE KEY `st_un1` (`name`,`version`)
) ENGINE=InnoDB$
