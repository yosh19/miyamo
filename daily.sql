select SUM(CASE WHEN orders.fare IS NULL THEN 0 ELSE orders.total_fare END)


まずテーブルのみをJOINする
SELECT 
*
 FROM local_taxi.owners AS t_own 
LEFT JOIN 
	local_taxi.orders AS t_ord
	ON t_own.id = t_ord.owner_id
LEFT JOIN
	local_platform.distributed_coupons AS p_dist
	ON t_ord.coupon_id = p_dist.id;



社員マスター　owner_tbl
社員売上実績　order_tbl


[A] select 社員ID, sum(売上) as sales_sum from 社員売上実績 group by 社員ID;

select オーナーID, SUM(運賃)　as total_fare from オーダー_tbl group by オーナーID
SELECT owner_id, SUM(`fare`) AS total_fare FROM orders GROUP BY owner_id;


//運賃合計　orders_tbl
SELECT ow.id, ow.company_name, ord.total_fare FROM owners AS ow 
LEFT JOIN 
	(SELECT owner_id, SUM(`fare`) AS total_fare FROM orders GROUP BY owner_id) AS ord ON ow.id = ord.owner_id;



//id 事業者名　運賃合計　チップ合計 日付指定
SELECT own.id, own.company_name, ord.total_fare,ord.total_tips FROM owners AS own 
LEFT JOIN 
(SELECT owner_id, 
	SUM(`fare`) AS total_fare,
	SUM(`tips`) AS total_tips 
	FROM orders where '2017-12-12' = DATE_FORMAT(`started_at`, '%Y-%m-%d') GROUP BY owner_id) AS ord ON own.id = ord.owner_id;


//idとオンラインの合計 from orders
SELECT owner_id, SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online FROM orders GROUP BY owner_id;



//id 事業者名　運賃合計　チップ合計 オンライン合計　オフライン合計  / 日付指定
SELECT own.id, own.company_name, ord.total_fare,ord.total_tips, fare_offline, fare_online FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(`fare`) AS total_fare,
		SUM(`tips`) AS total_tips,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online
	FROM orders where '2017-12-12' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;


//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計  / 日付指定
SELECT own.id,own.company_name,ord.tatal_sales, ord.total_fare,ord.total_tips, ord.fare_offline, ord.fare_online, ord.dispatch_count_online, ord.dispatch_count_offline FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(`fare` + `tips`) AS tatal_sales,
		SUM(`fare`) AS total_fare,
		SUM(`tips`) AS total_tips,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online
	FROM orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;


//オンライン件数
select COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online from orders; 

//オフライン
select COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline from orders; 




//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計 オンライン件数　オフライン件数 / 日付指定
SELECT own.id,own.company_name,ord.tatal_sales, ord.total_fare,ord.total_tips, ord.fare_offline, ord.fare_online, ord.dispatch_count_online, ord.dispatch_count_offline FROM owners AS own 
LEFT JOIN 
	(SELECT owner_id,
		SUM(`fare` + `tips`) AS tatal_sales,
		SUM(`fare`) AS total_fare,
		SUM(`tips`) AS total_tips,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline 
	FROM orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;



//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計 オンライン件数　オフライン件数 キャンセル回数/ 日付指定
SELECT own.id,
own.company_name,
ord.tatal_sales, 
ord.total_fare,
ord.total_tips,
ord.fare_offline,
ord.fare_online,
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







◎◎◎2018/1/18
//id 事業者名 売上合計　運賃合計　チップ合計 オンライン合計　オフライン合計 オンライン件数　オフライン件数 キャンセル回数 配車手数料(1回) 配車手数料/ 日付指定
SELECT own.id,
own.company_name,
ord.total_sales, 
ord.total_fare,
ord.total_tips,
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
		SUM(`fare`) AS total_fare,
		SUM(`tips`) AS total_tips,
		SUM(CASE WHEN `is_online_payment` = 1 THEN `fare` ELSE 0 END) AS fare_online,
		SUM(CASE WHEN `is_online_payment` = 0 THEN `fare` ELSE 0 END) AS fare_offline,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 1 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_online,
		COUNT(CASE WHEN `status` = 5 AND `is_online_payment`= 0 THEN `is_online_payment` ELSE NULL END) AS dispatch_count_offline,
		COUNT(CASE WHEN `cancelled_by` = 'DRIVER' THEN `cancelled_by` ELSE NULL END) AS dispatch_cancellation_count
	FROM orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;


◎◎◎◎◎
SELECT
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
	FROM orders where '2017-12-23' = DATE_FORMAT(`started_at`, '%Y-%m-%d') 
GROUP BY owner_id) AS ord ON own.id = ord.owner_id;








//日付のみ取得　月初めのインサートで使う
-> DATE_FORMAT(CurDate(),'%m') as month ,


//



INSERT INTO `owner_daily_summary` (
	`closing_process_id` ,
	`owner_id` ,
	`driver_id` , 
	`date` ,
	`total_sales`  ,
	`total_fare`  ,
	`fare_offline`  ,
	`fare_online`  ,
	`tip`  ,
	`deferred_revenue`  ,
	`deferred_revenue_minus`  ,
	`deferred_revenue_plus`  ,
	`coupon_admin`  ,
	`accrued` ,
	`total_deferred`  ,
	`captured_payment_calc`  ,
	`captured_payment`  ,
	`card_transaction_fee`  ,
	`card_transaction_income`  ,
	`dispatch_count_online`  ,
	`dispatch_count_offline`  ,
	`dispatch_cancellation_count`  ,
	`dispatch_fee`  ,
	`dispatch_fee_income`  ,
	`communication_fee_income`  ,
	`bank_transfer_fee`  ,
	`total_fee`  ,
	`transfer_amount`  ,
	`captured_fee`  ,
	`captured_net`)
VALUES(
	1,
	10014,
	10009,
	20170814,
	200000,
	110000,
	70000,
	40000,
	90000,
	4500,
	6000,
	-1500,
	400,
	20,
	600,
	110000,
	99980,
	0.3,
	33,
	22,
	45,
	2,
	10,
	200,
	250,
	1120,
	70,
	110,
	120,
	130);


//`owner_daily_summary`
CREATE TABLE `owner_daily_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `closing_process_id` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `date` int(8) DEFAULT NULL,
  `total_sales` int(11) DEFAULT NULL,
  `total_fare` int(11) DEFAULT NULL,
  `fare_offline` int(11) DEFAULT NULL,
  `fare_online` int(11) DEFAULT NULL,
  `tip` int(11) DEFAULT NULL,
  `deferred_revenue` int(11) DEFAULT NULL,
  `deferred_revenue_minus` int(11) DEFAULT NULL,
  `deferred_revenue_plus` int(11) DEFAULT NULL,
  `coupon_admin` int(11) DEFAULT NULL,
  `accrued` int(11) DEFAULT NULL,
  `total_deferred` int(11) DEFAULT NULL,
  `captured_payment_calc` int(11) DEFAULT NULL,
  `captured_payment` int(11) DEFAULT NULL,
  `card_transaction_fee` int(11) DEFAULT NULL,
  `card_transaction_income` int(11) DEFAULT NULL,
  `dispatch_count_online` int(11) DEFAULT NULL,
  `dispatch_count_offline` int(11) DEFAULT NULL,
  `dispatch_cancellation_count` int(11) DEFAULT NULL,
  `dispatch_fee` int(11) DEFAULT NULL,
  `dispatch_fee_income` int(11) DEFAULT NULL,
  `communication_fee_income` int(11) DEFAULT NULL,
  `bank_transfer_fee` int(11) DEFAULT NULL,
  `total_fee` int(11) DEFAULT NULL,
  `transfer_amount` int(11) DEFAULT NULL,
  `captured_fee` int(11) DEFAULT NULL,
  `captured_net` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)



//`deferred_revenue`

CREATE TABLE `deferred_revenue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) DEFAULT NULL,
  `date` int(8) DEFAULT NULL,
  `type` char(1) DEFAULT NULL,
  `deferred_revenue` int(1) DEFAULT NULL,
  `label` varchar(10) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL,
  `closing_id` int(8) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(8) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int(8) DEFAULT NULL,  
  PRIMARY KEY (`id`)
)

#`distributed_coupons`
CREATE TABLE `distributed_coupons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_id` int(11) DEFAULT NULL,
  `amount` int(8) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(8) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int(8) DEFAULT NULL,  
  PRIMARY KEY (`id`)
)



クーポンをユーザーが指定しました
しかし決済時に50円問題で使えませんでした。
そのとき、ordersに持っているクーポンidはどうなるか？
NULLにしてしまって良い？？？

