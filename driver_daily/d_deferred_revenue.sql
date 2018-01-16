
SELECT
		t_dri.id,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_minus,
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_plus,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) + 
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue
FROM taxi.drivers AS t_dri
LEFT JOIN 
	taxi.orders AS t_ord
	ON t_ord.driver_id = t_dri.id
LEFT JOIN
	taxi.deferred_revenue AS t_dr
	ON t_dr.order_id = t_ord.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		AND `closing_process_id` = 1 GROUP BY t_dri.id