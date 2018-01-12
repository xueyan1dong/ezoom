DROP TABLE IF EXISTS `ingredients`;
CREATE TABLE `ingredients` (
  `recipe_id` int(10) unsigned NOT NULL,
  `source_type` enum('product', 'material') NOT NULL,
  `ingredient_id` int(10) unsigned NOT NULL,
  `quantity` decimal(16,4) unsigned NOT NULL,
  `uom_id` smallint(3) unsigned NOT NULL,
  `order` tinyint(3) unsigned DEFAULT NULL,
  `mintime` int(10) unsigned DEFAULT NULL,
  `maxtime` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`recipe_id`,`source_type`,`ingredient_id`,`order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;