◎◎◎◎◎
SELECT
t_own.id,
SUM(CASE WHEN t_payments.`error_code` IS NOT NULL AND t_payments.`payment_method` = 1 THEN `amount` ELSE 0 END) AS accrude,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount` ELSE 0 END) AS captured_payment,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount`*`card_transaction_fee` ELSE 0 END) AS card_transaction_income
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id

LEFT JOIN
	local_taxi.payments AS t_payments
	ON t_ord.payment_id = t_payments.id
		where '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.owner_id;

◎◎◎1/10
SELECT 
t_own.id,
t_own.company_name,
SUM(CASE WHEN t_payments.`error_code` IS NOT NULL AND t_payments.`payment_method` = 1 THEN `amount` ELSE 0 END) AS accrude,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount` ELSE 0 END) AS total_captured_amount,
SUM(CASE WHEN t_payments.`error_code` IS NULL AND t_payments.`payment_method` = 1  THEN `amount`*`card_transaction_fee` ELSE 0 END) AS total_card_transaction_fee
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id

LEFT JOIN
	local_taxi.payments AS t_payments
	ON t_ord.payment_id = t_payments.id
		where '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.owner_id;


