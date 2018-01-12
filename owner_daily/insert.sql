INSERT INTO `owner_daily_summary` (
	#`closing_process_id` ,
	`owner_id` ,
	`driver_id` , 
	#`date` ,
	`total_sales`  ,
	`total_fare`  ,
	`fare_offline`  ,
	`fare_online`  ,
	`tip`  ,
	#`deferred_revenue`  ,
	#`deferred_revenue_minus`  ,
	#`deferred_revenue_plus`  ,
	#`coupon_admin`  ,
	#`accrued` ,
	#`total_deferred`  ,
	#`captured_payment_calc`  ,
	#`captured_payment`  ,
	#`card_transaction_fee`  ,
	#`card_transaction_income`  ,
	`dispatch_count_online`  ,
	`dispatch_count_offline`  ,
	`dispatch_cancellation_count`
	#`dispatch_fee`  ,
	#`dispatch_fee_income`  ,
	#`communication_fee_income`  ,
	#`bank_transfer_fee`  ,
	#`total_fee`  ,
	#`transfer_amount`  ,
	#`captured_fee`  ,
	#`captured_net`
	)
VALUES(
	#1,
	10014,
	10009,
	#20170814,
	200000,
	110000,
	70000,
	40000,
	90000,
	#4500,
	#6000,
	#-1500,
	#400,
	#20,
	#600,
	#110000,
	#99980,
	#0.3,
	#33,
	32,
	55,
	12
	#10,
	#200,
	#250,
	#1120,
	#70,
	#110,
	#120,
	#130
	);



//2017-12-23 
INSERT INTO `owner_daily_summary` (
	#`closing_process_id` ,
	`owner_id` ,
	#`driver_id` , 
	#`date` ,
	`total_sales`  ,
	`total_fare`  ,
	`fare_offline`  ,
	`fare_online`  ,
	`tip`  ,
	#`deferred_revenue`  ,
	#`deferred_revenue_minus`  ,
	#`deferred_revenue_plus`  ,
	#`coupon_admin`  ,
	#`accrued` ,
	#`total_deferred`  ,
	#`captured_payment_calc`  ,
	#`captured_payment`  ,
	#`card_transaction_fee`  ,
	#`card_transaction_income`  ,
	`dispatch_count_online`  ,
	`dispatch_count_offline`  ,
	`dispatch_cancellation_count`
	#`dispatch_fee`  ,
	#`dispatch_fee_income`  ,
	#`communication_fee_income`  ,
	#`bank_transfer_fee`  ,
	#`total_fee`  ,
	#`transfer_amount`  ,
	#`captured_fee`  ,
	#`captured_net`
	)
SELECT 
own.id,
ord.tatal_sales, 
ord.total_fare,
ord.fare_offline,
ord.fare_online,
ord.total_tips,
ord.dispatch_count_online,
ord.dispatch_count_offline,
ord.dispatch_cancellation_count
 FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(`fare` + `tips`) AS tatal_sales,
		SUM(`fare`) AS total_fare,
		SUM(`tips`) AS total_tips,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline,
		COUNT(CASE WHEN `cancelled_by` = 'DRIVER' THEN `cancelled_by` ELSE NULL END) AS dispatch_cancellation_count
	FROM orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;

