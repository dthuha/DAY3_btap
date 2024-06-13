--- Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
SELECT
SUM(CASE
WHEN device_type = 'laptop' THEN 1
ELSE 0
END) laptop_views,
SUM(CASE
WHEN device_type IN ('tablet', 'phone') THEN 1
ELSE 0
END) mobile_views
FROM viewership;
--- Triangle Judgement
SELECT x,y,z,
CASE
WHEN x+y>z AND x+z>y AND y+z>x THEN 'Yes' --- dùng dc AND (thể hiện 3 điều kiện đồng thời xảy ra)
ELSE 'No'
END triangle
FROM TRIANGLE
--- Patient Support Analysis (Part 2) [UnitedHealth SQL Interview Question]
SELECT
ROUND(CAST(SUM(
CASE
WHEN call_category = 'n/a' or call_category is null THEN 1
ELSE 0
END) AS DECIMAL) -- bdau kqua ra 0 => nghĩ đến vc dùng CAST AS DECIMAL
/ COUNT(case_id)*100,1) AS uncategorised_call_pct
FROM callers
--- Find Customer Referee
select name from customer where referee_id !=2 or referee_id is null
--- Make a report showing the number of survivors and non-survivors by passenger class
select survived,
SUM(CASE
WHEN pclass = '1' THEN 1
ELSE 0
END) first_class,
SUM(CASE
WHEN pclass = '2' THEN 1
ELSE 0
END) second_classs,
SUM(CASE
WHEN pclass = '3' THEN 1
ELSE 0
END) third_class
from titanic
GROUP BY SURVIVED
