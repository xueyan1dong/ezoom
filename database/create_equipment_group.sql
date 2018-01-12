DROP TABLE IF EXISTS `equipment_group`;
CREATE TABLE  `equipment_group` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `prefix` varchar(20) DEFAULT NULL,
  `location_id` int(5) unsigned DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `description` text,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `eg_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
