-- EX1: Average Population of Each Continent
SELECT T2.CONTINENT, FLOOR(AVG(T1.POPULATION))
FROM CITY AS T1
INNER JOIN COUNTRY AS T2
ON T1.COUNTRYCODE=T2.CODE
GROUP BY T2.CONTINENT
-- EX2: Signup Activation Rate [TikTok SQL Interview Question]
SELECT
ROUND(CAST(SUM(CASE
WHEN T1.signup_action = 'Confirmed' THEN 1
ELSE 0
END) AS DECIMAL) /COUNT(T1.signup_action), 2) AS activation_rate
FROM TEXTS AS T1
INNER JOIN EMAILS AS T2
ON T1.email_id=T2.email_id
-- EX3: Sending vs. Opening Snaps [Snapchat SQL Interview Question]
SELECT t2.age_bucket,
ROUND(100*
SUM(CASE 
WHEN t1.activity_type = 'send' THEN t1.time_spent
END) :: DECIMAL /
SUM(CASE 
WHEN t1.activity_type in ('open','send') THEN t1.time_spent --- ban đầu mình nghĩ là cần cộng case when của từng open và send lại, nhưng kcan, để in ('open', 'send') như kia
END),2) as send_perc, 
ROUND(100* 
SUM(CASE 
WHEN t1.activity_type = 'open' THEN t1.time_spent
END) :: DECIMAL /
SUM(CASE 
WHEN t1.activity_type in ('open','send') THEN t1.time_spent
END),2) as open_perc
FROM activities AS t1
INNER JOIN age_breakdown AS t2
ON t1.user_id=t2.user_id
GROUP BY t2.age_bucket
-- EX4: Supercloud Customer [Microsoft SQL Interview Question]
SELECT t1.customer_id
FROM customer_contracts AS t1
INNER JOIN products AS t2
ON t1.product_id=t2.product_id
WHERE t2.product_category in ('Analytics', 'Containers', 'Compute')
GROUP BY t1.customer_id
HAVING COUNT(DISTINCT t2.product_category) = 3
--- EX5: The Number of Employees Which Report to Each Employee (XEM KĨ)
SELECT a.employee_id,a.name,
count(b.reports_to) AS reports_count,
round(avg(b.age)) AS average_age
FROM Employees AS a
INNER JOIN Employees AS b
ON a.employee_id = b.reports_to
GROUP BY a.employee_id, a.name
ORDER BY a.employee_id
--- EX6: List the Products Ordered in a Period
SELECT t1.product_name, SUM(t2.unit) as unit
FROM Products AS t1
INNER JOIN Orders AS t2
ON t1. product_id=t2. product_id
WHERE EXTRACT(month from t2.order_date) = '2' AND EXTRACT(year from t2.order_date) = '2020'
GROUP BY t1.product_name
HAVING SUM(t2.unit) >=100
--- EX7: Page With No Likes [Facebook SQL Interview Question]
SELECT t1.page_id
FROM pages AS t1
LEFT JOIN page_likes AS t2
ON t1.page_id=t2.page_id
WHERE t2.liked_date is NULL
ORDER BY t1.page_id
