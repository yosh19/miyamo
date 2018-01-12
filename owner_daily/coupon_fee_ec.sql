◎◎◎◎◎
SELECT
t_own.id,	
SUM(CASE WHEN `amount`> 0 THEN `amount` ELSE 0 END) AS coupon_admin
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	local_platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id
		where '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.owner_id;

◎◎◎
SELECT 
t_own.id,
t_own.company_name,
SUM(CASE WHEN `amount`> 0 THEN `amount` ELSE 0 END) AS coupon_admin
FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	local_platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id
		where '2017-12-23' = DATE_FORMAT(t_ord.`started_at`, '%Y-%m-%d')
		GROUP BY t_ord.owner_id;




taxi.orders.coupon_id

platform.distributed_coupons.coupon_id


ownerとorders
ordersとdistributed


t_ord.id, t_ord.coupon_id, p_dist.


売上調整額/合計
売上調整額/プラス
売上調整額/マイナス


オーナー / id = オーダー / owner_id
オーダー / 配布済みクーポンID = 配布済みクーポン / id


#owner orderのcoupon_id
SELECT own.id,
own.company_name,
ord.total_coupon
 FROM local_taxi.owners AS t_own 
LEFT JOIN 
	FROM local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	FROM local_platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id;






#order と　deferred_coupon 
SELECT t_ord.id, p_dist.amount FROM local_taxi.orders AS t_ord 
LEFT JOIN
(SELECT  FROM local_platform.distributed_coupons) AS p_dist ON t_ord.coupon_id = p_dist.id;



SELECT *
FROM local_taxi.owners AS t_own
LEFT JOIN
(SELECT owner_id, started_at FROM local_taxi.orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d')) AS t_ord ON t_own.id = t_ord.owner_id;



#ordersとownerでJOIN オーナーIDでひもづけ　 /日付
SELECT t_own.id, t_ord.coupon_id
FROM local_taxi.owners AS t_own
LEFT JOIN
(SELECT * FROM local_taxi.orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d')) AS t_ord ON t_own.id = t_ord.owner_id;

#3つテーブルJOIN
SELECT *
FROM local_taxi.owners AS t_own
LEFT JOIN
local_taxi.orders AS t_ord  ON t_own.id = t_ord.owner_id
LEFT JOIN
 local_platform.distributed_coupons AS p_dist ON t_ord.coupon_id = p_dist.coupon_id ;



#orders_idとdistributed_couponのid
SELECT * FROM local_taxi.orders AS t_ord 
LEFT JOIN
(SELECT * FROM local_platform.distributed_coupons) AS p_dist ON t_ord.coupon_id = p_dist.coupon_id;




#３つJOIN 
SELECT *
FROM local_taxi.owners AS t_own
LEFT JOIN
(SELECT * FROM local_taxi.orders) AS t_ord ON t_own.id = t_ord.id 
LEFT JOIN
(SELECT * FROM local_platform.distributed_coupons) AS p_dist ON t_ord.coupon_id = p_dist.coupon_id;



#2つJOIN
SELECT t_ord.driver_id, p_dist.amount
FROM local_taxi.orders AS t_ord
LEFT JOIN
(SELECT * FROM local_platform.distributed_coupons)
AS p_dist ON t_ord.coupon_id = p_dist.coupon_id;



SELECT one.id AS one_id, two.id AS two_id, three.id AS three_id 

FROM one JOIN two ON (one.id=two.id) 
LEFT JOIN three ON (two.id=three.id);


table0 + ((table1 + table2) + table3)
select c.name, a.url, k.word, r.created, r.rank 
from companies as c 
left join ((key as k left join ali_spec as a on k.id = a.keyword_id) 

left join records as r on k.id = r.keyword_id) on c.id = k.company_id;

((table1 + table2) + table3)



select * from tb0 
left join tb1 on tb0.id = tb1.id 
left join tb2 on tb0.id = tb2.id;





