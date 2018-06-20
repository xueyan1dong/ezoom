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
DROP TABLE IF EXISTS `order_general`$
CREATE TABLE `order_general` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_type` enum('inventory', 'customer','supplier') NOT NULL,
  `ponumber` varchar(40) DEFAULT NULL,
  `client_id` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `net_total` decimal(16,2) unsigned DEFAULT NULL,
  `tax_percentage` tinyint(2) unsigned DEFAULT NULL,
  `tax_amount` decimal(14,2) unsigned DEFAULT NULL,
  `other_fees` decimal(16,2) unsigned DEFAULT NULL,
  `total_price` decimal(16,2) unsigned DEFAULT NULL,
  `expected_deliver_date` datetime DEFAULT NULL,  
  `internal_contact` int(10) unsigned NOT NULL,
  `external_contact` varchar(255) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$