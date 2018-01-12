DROP TABLE IF EXISTS `inventory_consumption`;
CREATE TABLE `inventory_consumption` (
  `lot_id` int(10) unsigned NOT NULL,
  `lot_alias` varchar(20) DEFAULT NULL,
  `start_timecode` char(15) NOT NULL,
  `end_timecode` char(15) DEFAULT NULL,
  `inventory_id` int(10) unsigned NOT NULL,
  `quantity_used` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `sub_process_id` int(10) unsigned DEFAULT NULL,
  `position_id` int(5) unsigned NOT NULL,
  `sub_position_id` int(5) unsigned DEFAULT NULL,
  `step_id` int(10) unsigned NOT NULL,
  `operator_id` int(10) unsigned NOT NULL,
  `equipment_id` int(10) unsigned DEFAULT NULL,
  `device_id` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (lot_id, start_timecode, inventory_id)
) ENGINE=InnoDB;