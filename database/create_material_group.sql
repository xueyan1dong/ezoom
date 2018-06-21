/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_material_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `material_group`$
CREATE TABLE `material_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$
