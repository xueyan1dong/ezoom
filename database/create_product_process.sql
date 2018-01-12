DROP TABLE IF EXISTS `product_process`;
CREATE TABLE `product_process` (
  `product_id` int(10) unsigned NOT NULL,
  `process_id` int(10) unsigned NOT NULL,
  `priority` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `recorder` int(10) unsigned NOT NULL,
  `comment` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;