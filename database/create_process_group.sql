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
DROP TABLE IF EXISTS `process_group`$
CREATE TABLE `process_group` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `description` text NOT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prg_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$
