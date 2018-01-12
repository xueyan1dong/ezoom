DROP TABLE IF EXISTS `dc_data_general`;
CREATE TABLE  `dc_data_general` (
  `data_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `def_id` int(10) unsigned NOT NULL,
  `event_time` datetime NOT NULL,
  `recorder` int(10) unsigned NOT NULL,
  `target` enum('product', 'equipment', 'supply') NOT NULL,
  `target_id` int(10) unsigned NOT NULL,
  `data_table_name` VARCHAR(255) NOT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;