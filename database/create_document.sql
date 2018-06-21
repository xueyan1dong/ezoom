/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_document.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : 
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 					
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `document`$
CREATE TABLE  `document` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_table` varchar(50) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `key_words` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `path` varchar(255) NOT NULL,
  `version` varchar(10) DEFAULT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `contact_id` int(10) unsigned NOT NULL,
  `record_time` datetime NOT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY(`id`),
  KEY (`source_table`, `source_id`, `key_words`, `title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$