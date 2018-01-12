#合計
#with orders

SELECT 
a.`id`,
a.`total_sales`,
a.`fare`,
a.`fare_offline`,
a.`fare_online`,
a.`tip`,
b.`deferred_revenue`,
b.`deferred_revenue_minus`,
b.`deferred_revenue_plus`,
c.`coupon_admin`,
d.`accrude`,
d.`captured_payment`,
d.`card_transaction_income`,
a.`dispatch_count_online`,
a.`dispatch_count_offline`,
a.`dispatch_cancellation_count`,
a.`dispatch_fee`,
a.`dispatch_fee_income`,
(b.`deferred_revenue`-c.`coupon_admin`-d.`accrude`) AS total_deferred,
(a.`fare_online`-b.`deferred_revenue`-c.`coupon_admin`-d.`accrude`) AS captured_payment_calc,
(d.`card_transaction_income` + a.`dispatch_fee_income` + a.`communication_fee` + a.`bank_transfer_fee` -c.`coupon_admin`) AS total_fee,
(a.`fare_online` + b.`deferred_revenue`-c.`coupon_admin`-d.`accrude` - d.`card_transaction_income` + a.`dispatch_fee_income` + a.`communication_fee` + a.`bank_transfer_fee` -c.`coupon_admin`) AS transfer_amount,
d.`captured_fee`,
d.`captured_net`

FROM

#orders
(SELECT
own.id,
own.communication_fee,
own.bank_transfer_fee,
ord.total_sales, 
ord.fare,
ord.tip,
ord.fare_offline,
ord.fare_online,
ord.dispatch_count_online,
ord.dispatch_count_offline,
ord.dispatch_cancellation_count,
own.dispatch_fee,
(ord.dispatch_count_online + ord.dispatch_count_offline + ord.dispatch_cancellation_count) * own.dispatch_fee as dispatch_fee_income
 FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(`fare` + `tips`) AS total_sales,
		SUM(`fare`) AS fare,
		SUM(`tips`) AS tip,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline,
		COUNT(CASE WHEN `cancelled_by` = 'DRIVER' THEN `cancelled_by` ELSE NULL END) AS dispatch_cancellation_count
	FROM orders WHERE '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id) a,

#deferred revenue 調整金
(SELECT own.id,
own.company_name,
deferred_revenue_plus + deferred_revenue_minus AS deferred_revenue,
dr.deferred_revenue_plus,
dr.deferred_revenue_minus
FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_minus,
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_plus
	FROM deferred_revenue 
		WHERE '2017-12-23' = DATE_FORMAT(`date`, '%Y-%m-%d') 
		AND `closing_process_id` = 1
GROUP BY owner_id) AS dr ON own.id = dr.owner_id) b,


#coupon_fee クーポン C
(SELECT
t_own.id,	
SUM(CASE WHEN `amount`> 0 THEN `amount` ELSE 0 END) AS coupon_admin
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	local_platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.owner_id) c,


#payments D
(SELECT
t_own.id,
SUM(CASE WHEN t_payments.`error_code` IS NOT NULL AND t_payments.`payment_method` = 1 THEN `amount` ELSE 0 END) AS accrude,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount` ELSE 0 END) AS captured_payment,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount`*`card_transaction_fee` ELSE 0 END) AS card_transaction_income,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `stripe_fee` ELSE 0 END) AS captured_fee,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `stripe_net` ELSE 0 END) AS captured_net
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id

LEFT JOIN
	local_taxi.payments AS t_payments
	ON t_ord.payment_id = t_payments.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d') 
		AND `closing_process_id` = 1
		GROUP BY t_ord.owner_id) d



WHERE a.`id` = b.`id`
AND a.`id` = c.`id`
AND a.`id` = d.`id`;
