//id 事業者名 
SELECT own.id,
own.company_name,

 FROM owners AS own 
LEFT JOIN
	(SELECT owner_id,



		)

◎◎◎1/10

//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計 オンライン件数　オフライン件数 キャンセル回数/ 日付指定
SELECT
deferred_revenue_plus + deferred_revenue_minus AS deferred_revenue,
dr.deferred_revenue_plus,
dr.deferred_revenue_minus
FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_minus,
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_plus
	FROM deferred_revenue where '2017-12-23' = DATE_FORMAT(`date`, '%Y-%m-%d') 
GROUP BY owner_id) AS dr ON own.id = dr.owner_id;



◎◎◎◎
//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計 オンライン件数　オフライン件数 キャンセル回数/ 日付指定
SELECT
deferred_revenue_plus + deferred_revenue_minus AS deferred_revenue,
dr.deferred_revenue_plus,
dr.deferred_revenue_minus
FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_minus,
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_plus
	FROM deferred_revenue where '2017-12-23' = DATE_FORMAT(`date`, '%Y-%m-%d') 
GROUP BY owner_id) AS dr ON own.id = dr.owner_id;


◎◎◎◎1/13 deferred_revenueにowner_id が無くなった対応 order_idをキーにする　
SELECT
		t_own.id,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_minus,
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue_plus,
		SUM(CASE WHEN `deferred_revenue` < 0 THEN `deferred_revenue` ELSE 0 END) + 
		SUM(CASE WHEN `deferred_revenue` > 0 THEN `deferred_revenue` ELSE 0 END) AS deferred_revenue
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	local_taxi.deferred_revenue AS t_dr
	ON t_dr.order_id = t_ord.id
		WHERE '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		AND `closing_process_id` = 1 GROUP BY t_own.id;