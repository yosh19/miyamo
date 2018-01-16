SELECT driver_id,
		SUM(`fare` + `tips`) AS total_sales,
		SUM(`fare`) AS fare,
		SUM(`tips`) AS tip,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline,
		COUNT(CASE WHEN `cancelled_by` = 'DRIVER' THEN `cancelled_by` ELSE NULL END) AS dispatch_cancellation_count
	FROM orders WHERE '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY driver_id;