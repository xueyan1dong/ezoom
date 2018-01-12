DROP TABLE IF EXISTS `recipe`;
CREATE TABLE `recipe` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `exec_method` enum('ordered','random') NOT NULL DEFAULT 'random',
  `contact_employee` int(10) unsigned DEFAULT NULL,
  `instruction` text DEFAULT NULL,
  `diagram_filename` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `updated_by` int(10) unsigned DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;