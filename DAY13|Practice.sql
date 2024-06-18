-- EX 1:
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

