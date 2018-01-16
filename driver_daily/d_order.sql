/*
driver 10027
driver 10028
driver 10029
*/



SELECT 
dri.id,
dri.last_name,
ord.total_sales,
ord.fare,
ord.tip,
ord.fare_online,
ord.fare_offline,
ord.dispatch_count_online,
ord.dispatch_count_offline,
ord.dispatch_cancellation_count
FROM drivers AS dri
LEFT JOIN
	(SELECT driver_id,
			SUM(`fare` + `tips`) AS total_sales,
			SUM(`fare`) AS fare,
			SUM(`tips`) AS tip,
			SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
			SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
			COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
			COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline,
			COUNT(CASE WHEN `cancelled_by` = 'DRIVER' THEN `cancelled_by` ELSE NULL END) AS dispatch_cancellation_count
		FROM orders WHERE '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
	GROUP BY driver_id) AS ord ON dri.id = ord.driver_id;




CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) NOT NULL,
  `request_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  `payment_id` int(11) DEFAULT NULL,
  `vehicle_info` text NOT NULL,
  `accept_location` geometry NOT NULL,
  `source` geometry DEFAULT NULL,
  `destination` geometry DEFAULT NULL,
  `accepted_at` datetime NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `standby_at` datetime DEFAULT NULL,
  `standby_location` geometry DEFAULT NULL,
  `estimated_fare` int(11) NOT NULL,
  `fare` int(11) DEFAULT '0',
  `is_online_payment` tinyint(1) NOT NULL,
  `message` text,
  `tips` int(11) DEFAULT '0',
  `coupon_id` int(11) DEFAULT NULL,
  `status` tinyint(2) NOT NULL COMMENT 'NEW 0 STANDBY 10 ONRIDE 11 ARRIVED 12 CANCELLED 20 COMPLETED 30',
  `cancellation_reason` tinyint(2) DEFAULT NULL,
  `cancelled_by` enum('USER','DRIVER') DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id_idx` (`owner_id`),
  KEY `fk_request_driver_id_request_drivers_idx` (`request_id`),
  KEY `fk_orders_driver_id_drivers_id_idx` (`driver_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `fk_orders_driver_id_drivers_id` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_owner_id_owners_id` FOREIGN KEY (`owner_id`) REFERENCES `owners` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_request_id_requests_id` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4;