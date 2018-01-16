SELECT
t_dri.id,	
SUM(CASE WHEN `amount`> 0 THEN `amount` ELSE 0 END) AS coupon_admin
FROM taxi.drivers AS t_dri 
LEFT JOIN 
	taxi.orders AS t_ord
	ON t_dri.id = t_ord.driver_id
LEFT JOIN
	platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.driver_id