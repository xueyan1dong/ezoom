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
DROP TABLE IF EXISTS `material`$
CREATE TABLE `material` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mg_id` int(10) unsigned NOT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `alert_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `lot_size` decimal(16,4) unsigned DEFAULT NULL,
  `material_form` enum('solid','liquid','gas') NOT NULL,
  `status` enum('inactive','production','frozen') NOT NULL,
  `enlist_time` datetime NOT NULL,
  `enlisted_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_un1` (`name`,`alias`,`mg_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$