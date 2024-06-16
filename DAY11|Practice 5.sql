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
-- EX4: 
--- EX5:
SELECT a.employee_id,a.name,
count(b.reports_to) AS reports_count,
round(avg(b.age)) AS average_age
FROM Employees AS a
INNER JOIN Employees AS b
ON a.employee_id = b.reports_to
GROUP BY a.employee_id, a.name
ORDER BY a.employee_id
