/*
*    Copyright 2009 ~ Current  IT Helps LLC
*    Source File            : create_order_general.sql
*    Created By             : Xueyan Dong
*    Date Created           : 2009
*    Platform Dependencies  : MySql
*    Description            : Stores general header information of orders.
*    example	            : 
*    Log                    :
*    6/19/2018: Peiyu Ge: added header info. 	
*    09/25/2018: Xueyan Dong: removed id from the defined key, so that orders have to have unique po number within the same 
*                             type, client
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
  KEY `order_in01` (`order_type`,`client_id`,`ponumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$