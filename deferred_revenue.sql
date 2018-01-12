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



◎◎◎◎◎
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
