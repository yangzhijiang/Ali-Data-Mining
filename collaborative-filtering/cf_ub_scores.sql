##############用户&品牌分析
简化计算
  lastday + last_3_day_click_times 
+ last_3_day_buy_times   + last_7_day_click_times 
+ last_7_day_buy_times + last_15_day_click_times
+ total_click_times  +  total_collect_times
#############

SELECT 
a.user_id,
a.brand_id,
lastday,
last_3_day_click_times,
last_3_day_buy_times,
last_7_day_click_times,
last_7_day_buy_times,
last_15_day_click_times,
total_click_times,
total_buy_times,
total_collect_times,
buy_times
FROM 
 (SELECT user_id,brand_id,DATEDIFF("2014-07-15",MAX(visit_datetime))
AS lastday 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-07-15"
GROUP BY user_id,brand_id)
AS a 
LEFT JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_3_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_3_day_buy_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-07-15"
AND visit_datetime > "2014-07-11"
GROUP BY user_id,brand_id )
AS b 
ON a.user_id = b.user_id AND a.brand_id = b.brand_id
LEFT  JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_7_day_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS last_7_day_buy_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-07-15"
AND visit_datetime > "2014-07-07"
GROUP BY user_id,brand_id )
AS c
ON a.user_id = c.user_id AND a.brand_id = c.brand_id
LEFT JOIN
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS last_15_day_click_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-07-15"
AND visit_datetime > "2014-06-30"
GROUP BY user_id,brand_id )
AS d 
ON a.user_id = d.user_id AND a.brand_id = d.brand_id
LEFT JOIN 
(SELECT user_id,brand_id,
COUNT(CASE WHEN TYPE = 0 THEN 1  END) AS total_click_times ,
COUNT(CASE WHEN TYPE = 1 THEN 1  END) AS total_buy_times ,
COUNT(CASE WHEN TYPE = 2 THEN 1  END) AS total_collect_times ,
COUNT(CASE WHEN TYPE = 3 THEN 1  END) AS total_cart_times 
FROM t_alibaba_data 
WHERE visit_datetime < "2014-07-15"
GROUP BY user_id,brand_id )
AS f 
ON a.user_id = f.user_id AND a.brand_id = f.brand_id
LEFT JOIN 
(SELECT user_id,brand_id,
COUNT(1) AS buy_times 
FROM t_alibaba_data 
WHERE visit_datetime >= "2014-07-15"
AND visit_datetime < "2014-08-15"
AND TYPE = 1
GROUP BY user_id,brand_id)
AS g 
ON a.user_id = g.user_id AND a.brand_id = g.brand_id


