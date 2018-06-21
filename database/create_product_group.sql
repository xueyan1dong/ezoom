/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_product_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `product_group`$
CREATE TABLE `product_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `surfix` varchar(20) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pg_un1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8$
