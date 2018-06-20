/*
	5/30/2018:sdong:added new step_type: disassemble for disassemble a product into multiple components
*/
DELIMITER $  -- for escaping purpose
DROP TABLE IF EXISTS `step_type`$
CREATE TABLE `step_type` (
  `id` int(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `max_para_count` tinyint(3) NOT NULL DEFAULT '10',
  `min_para_count` tinyint(3) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `update_time` datetime DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sc_un1` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8$

