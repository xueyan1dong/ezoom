/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_client.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `client`$
CREATE TABLE `client` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `type` enum('supplier', 'customer', 'both') NOT NULL,
  `internal_contact_id` int(10) unsigned NOT NULL,
  `company_phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `country` varchar(20) DEFAULT 'USA',
  `address2` varchar(255) DEFAULT NULL,
  `city2` varchar(20) DEFAULT NULL,
  `state2` varchar(20) DEFAULT NULL,
  `zip2` varchar(10) DEFAULT NULL,
  `contact_person1` varchar(20) NOT NULL,
  `contact_person2` varchar(20) DEFAULT NULL,
  `person1_workphone` varchar(20) DEFAULT NULL,
  `person1_cellphone` varchar(20) DEFAULT NULL,
  `person1_email` varchar(40) NOT NULL,
  `person2_workphone` varchar(20) DEFAULT NULL,
  `person2_cellphone` varchar(20) DEFAULT NULL,
  `person2_email` varchar(20) DEFAULT NULL,
  `firstlistdate` date NOT NULL,
  `updateddate` date DEFAULT NULL,
  `ifactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `comment` text,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$