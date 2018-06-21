/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_product.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `product`$
CREATE TABLE  `product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pg_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `version` int(5) unsigned NOT NULL,
  `state` enum('inactive','production','frozen','checkout','checkin','engineer') NOT NULL,
  `lot_size` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(3) unsigned NOT NULL,  
  `lifespan` int(10) unsigned NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` int(10) unsigned DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `pd_un1` (`pg_id`,`name`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$