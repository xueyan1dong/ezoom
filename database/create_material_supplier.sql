DROP TABLE IF EXISTS `material_supplier`;
CREATE TABLE `material_supplier` (
  `material_id` int(10) unsigned NOT NULL,
  `supplier_id` int(10)unsigned NOT NULL,
  `preference` smallint(3) unsigned DEFAULT NULL,
  `mpn` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) unsigned DEFAULT NULL,
  `price_uom_id` smallint(3) unsigned DEFAULT NULL,
  `lead_days` int(5) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`material_id`, `supplier_id`)
) ENGINE=InnoDB;