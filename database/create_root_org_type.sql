/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_root_org_type.sql
*    Created By             : Shelby Simpson
*    Date Created           : 12/2/2019
*    Platform Dependencies  : MySql
*    Description            : This table is used for storing available root organization types.
*							  There is no foreign key from the organization table to this one but 
							  root_org_type attribute (in organization table) must be restricted to
							  one of the types in this table.
*    example	            : 
*    Log                    :
*      12/04/2019:Xueyan Dong:Added value set up to the table script
*/
DELIMITER $ 
DROP TABLE IF EXISTS `root_org_type`$
CREATE TABLE `root_org_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- auto generated id in ezoom 
  `name` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB$

INSERT INTO `root_org_type` (`name`)
VALUES ('host'), ('client')
$