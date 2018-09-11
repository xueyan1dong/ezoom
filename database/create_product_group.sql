/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_product_group.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : This table host the grouping infor of products
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 
*    09/07/2018: Xueyan Dong: added default_location_id and if_active to the table					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `product_group`$
CREATE TABLE `product_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,  --unique identifier automatcially generated
  `name` varchar(255) NOT NULL,     -- name of the product group
  `prefix` varchar(20) DEFAULT NULL,  -- prefix used in the name of products belonging to the group
  `surfix` varchar(20) DEFAULT NULL,  -- surfix used in the name of products belonging to the group
  `create_time` datetime NOT NULL,  -- time of the group created
  `created_by` int(11) unsigned NOT NULL,  -- user id who created this group
  `description` text,  -- description of the product group
  `comment` text,  -- any comment for the group
  `default_location_id` int(11) DEFAULT NULL,  -- id of default location for the product group
  `if_active` tinyint(1), -- whether the product group is active
  PRIMARY KEY (`id`),
  UNIQUE KEY `pg_un1` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8$
