DROP TABLE IF EXISTS `uom_conversion`;
CREATE TABLE `uom_conversion` (
  `from_id` smallint(3) unsigned NOT NULL ,
  `to_id` smallint(3) unsigned NOT NULL ,
  `method` enum('ratio', 'reduction', 'addtion') NOT NULL,
  `constant` decimal(16,4) unsigned NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`from_id`, `to_id`)
) ENGINE=InnoDB;