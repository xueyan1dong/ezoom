/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_employee.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `employee`$
CREATE TABLE  `employee` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company_id` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `status` enum('active','inactive','removed') NOT NULL DEFAULT 'active',
  `or_id` int(10) unsigned NOT NULL,
  `eg_id` int(10) unsigned DEFAULT NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) NOT NULL,
  `middlename` varchar(20) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `report_to` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `em_un1` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$