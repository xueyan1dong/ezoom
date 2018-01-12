DROP TABLE IF EXISTS `config_history`;
CREATE TABLE `config_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_time` datetime NOT NULL,
  `source_table` varchar(20) NOT NULL,
  `source_id` int(10) unsigned NOT NULL,
  `old_state` enum('inactive','production','frozen','checkout','checkin','engineer'),
  `new_state` enum('inactive','production','frozen','checkout','checkin','engineer','deleted') NOT NULL,
  `employee` int(10) unsigned NOT NULL,
  `comment` text,
  `new_record` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;