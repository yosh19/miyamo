SELECT
t_dri.id,
SUM(CASE WHEN t_payments.`error_code` IS NOT NULL AND t_payments.`payment_method` = 1 THEN `amount` ELSE 0 END) AS accrude,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount` ELSE 0 END) AS captured_payment,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount`*`card_transaction_fee` ELSE 0 END) AS card_transaction_income,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `stripe_fee` ELSE 0 END) AS captured_fee,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `stripe_net` ELSE 0 END) AS captured_net
FROM taxi.drivers AS t_dri
LEFT JOIN 
	taxi.owners AS t_own
	ON t_dri.owner_id = t_own.id
LEFT JOIN 
	taxi.orders AS t_ord
	ON t_dri.id = t_ord.driver_id

LEFT JOIN
	taxi.payments AS t_payments
	ON t_ord.payment_id = t_payments.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d') 
		AND `closing_process_id` = 1
		GROUP BY t_ord.driver_id




