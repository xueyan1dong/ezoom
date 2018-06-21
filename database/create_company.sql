/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_company.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `company`$
CREATE TABLE  `company` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `db_name` varchar(50) NOT NULL,
  `domain_name` varchar(50) NOT NULL,
  `status` enum('inactive','active') NOT NULL,
  `timezone` char(6) NOT NULL,
  `daylightsaving_starttime` datetime DEFAULT NULL,
  `daylightsaving_endtime` datetime DEFAULT NULL,
  `password` varchar(20) NOT NULL,
  `plan` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `state` varchar(60) DEFAULT NULL,
  `country` varchar(60) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` varchar(60) NOT NULL,
  `state_change_time` datetime DEFAULT NULL,
  `state_changed_by` varchar(60) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$