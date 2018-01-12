DROP TABLE IF EXISTS `order_state_history`;
CREATE TABLE `order_state_history` (
  `order_id` int(10) unsigned NOT NULL,
  `state` enum('quoted', 'POed', 'scheduled', 'produced', 'shipped', 'delivered', 'invoiced', 'paid') NOT NULL,
  `state_date` datetime NOT NULL,
  `recorder_id` int(10) unsigned NOT NULL,
  `comment` text,
  PRIMARY KEY (`order_id`, `state`, `state_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;