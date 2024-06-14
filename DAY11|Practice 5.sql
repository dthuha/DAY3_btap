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
--
