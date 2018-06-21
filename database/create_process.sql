/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_process.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `process`$
CREATE TABLE `process` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `prg_id` int(10) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin', 'engineer') NOT NULL,
  `start_pos_id` int(5) unsigned,
  `owner_id` int(10) unsigned NOT NULL,
  `if_default_version` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `usage` enum('sub process only','main process only','both') NOT NULL DEFAULT 'both',
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pr_un1` (`name`,`version`,`prg_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$