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
DROP TABLE IF EXISTS `order`$
CREATE TABLE `order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_type` enum('inventory', 'customer') NOT NULL,
  `ponumber` varchar(40) DEFAULT NULL,
  `client_id` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `product_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(16,4) unsigned NOT NULL,
  `quantity_made` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_in_process` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `quantity_shipped` decimal(16,4) unsigned NOT NULL DEFAULT '0',
  `uomid` smallint(3) unsigned NOT NULL,
  `order_date` datetime NOT NULL,
  `output_date` datetime DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `actual_deliver_date` datetime DEFAULT NULL,
  `internal_contact` int(10) unsigned NOT NULL,
  `external_contact` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$