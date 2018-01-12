DROP TABLE IF EXISTS `lot_status`;
CREATE TABLE `lot_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(20) DEFAULT NULL,
  `order_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `status` enum('dispatched','in process','in transit', 'hold', 'to warehouse', 'shipped', 'scrapped') NOT NULL,
  `start_quantity` decimal(16,4) unsigned NOT NULL,
  `actual_quantity` decimal(16,4) unsigned DEFAULT NULL,
  `uomid` smallint(5) unsigned NOT NULL,
  `update_timecode` char(15) DEFAULT NULL,  
  `contact` int(10) unsigned DEFAULT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `dispatcher` int(10) unsigned NOT NULL,
  `dispatch_time` datetime NOT NULL,
  `output_time` datetime DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;