-- EX 1: Duplicate Job Listings [Linkedin SQL Interview Question]
WITH abc AS 
(SELECT 
  company_id, 
  title, 
  description, 
  COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description)

SELECT COUNT(company_id)
FROM abc
WHERE job_count >1

-- EX2: Highest-Grossing Items [Amazon SQL Interview Question]
WITH appliance AS
(SELECT category, product,
SUM(spend) as total_spend
FROM product_spend
WHERE category = 'appliance' AND
EXTRACT(year from transaction_date) = '2022'
GROUP BY category, product
ORDER BY SUM(spend) DESC
LIMIT 2),

electronics AS
(SELECT category, product,
SUM(spend) as total_spend
FROM product_spend
WHERE category = 'electronics' AND
EXTRACT(year from transaction_date) = '2022'
GROUP BY category, product
ORDER BY SUM(spend) DESC
LIMIT 2)

SELECT category, product, total_spend FROM appliance
UNION ALL 
SELECT category, product, total_spend FROM electronics

-- EX3: Patient Support Analysis (Part 1) [UnitedHealth SQL Interview Question]
SELECT COUNT(policy_holder_id) AS policy_holder_count 
FROM
(SELECT policy_holder_id,
COUNT(case_id) AS so_luong
FROM callers
GROUP BY policy_holder_id) AS new_table
WHERE so_luong >=3

-- EX4: Page With No Likes [Facebook SQL Interview Question]
SELECT t1.page_id
FROM pages AS t1
LEFT JOIN page_likes AS t2
ON t1.page_id=t2.page_id
WHERE t2.liked_date is NULL
ORDER BY t1.page_id

-- EX5:
  
-- EX6: Monthly Transactions I
select  
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country, 
count(*) as  trans_count ,
sum(case when state ='approved 'then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state ='approved 'then amount else 0 end) as approved_total_amount 
from Transactions
group by month, country

-- EX7: Product Sales Analysis III
-- ID, NĂM, CHẤT LG, GIÁ trong năm đầu tiên (= năm MIN) của mỗi sp dc bán
SELECT 
product_id, 
year AS first_year, 
quantity,
price
FROM sales
WHERE (product_id,year) IN 
(SELECT 
  product_id,
  MIN(year) --- đừng quên MIN, MAX
FROM sales
GROUP BY product_id)

-- EX8: Customers Who Bought All Products
SELECT customer_id FROM customer 
GROUP BY customer_id
HAVING COUNT(distinct product_key) = 
(SELECT COUNT(product_key ) 
FROM product)

-- EX 9: Employees Whose Manager Left the Company
SELECT employee_id
FROM Employees as a
WHERE manager_id not in (SELECT employee_id FROM employees) and salary < 30000
ORDER BY employee_id ASC

-- EX 11: Movie Rating
(SELECT name AS results 
FROM Users
JOIN MovieRating
ON Users.user_id=MovieRating.user_id
GROUP BY Users.user_id
ORDER BY COUNT(*) DESC, name ASC
LIMIT 1)

UNION ALL
(SELECT results FROM
(SELECT 
title AS results,
AVG(MovieRating.rating) AS trom_via
FROM Movies
JOIN MovieRating
ON Movies.movie_id=MovieRating.movie_id
WHERE EXTRACT(month from created_at) = 2 AND EXTRACT(year from created_at) = 2020
GROUP BY (Movies.movie_id)) AS abc

ORDER BY trom_via DESC, results ASC 
LIMIT 1)

-- EX 12: (bai nay hay) Friend Requests II: Who Has the Most Friends
WITH ABC AS
(SELECT requester_id , accepter_id
FROM RequestAccepted
UNION ALL
SELECT accepter_id , requester_id
FROM RequestAccepted)
SELECT requester_id AS id,
COUNT(accepter_id) AS num
FROM ABC
GROUP BY requester_id
ORDER BY num DESC
LIMIT 1
