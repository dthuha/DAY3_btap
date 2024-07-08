--- PART 1
-- 1
SELECT
FORMAT_DATE('%Y-%m', B.delivered_at) AS month,
COUNT(B.order_id) AS total_order,
COUNT(B.user_id) AS  total_user
FROM bigquery-public-data.thelook_ecommerce.order_items AS A
JOIN bigquery-public-data.thelook_ecommerce.orders AS B
ON A.order_id=B.order_id
JOIN bigquery-public-data.thelook_ecommerce.users AS C
ON A.id=C.id
WHERE B.status = 'Complete' AND
B.created_at >= '2019-01-01' AND B.created_at <= '2022-04-30'
GROUP BY FORMAT_DATE('%Y-%m', B.delivered_at)
ORDER BY month
        
-- 2
SELECT
FORMAT_DATE('%Y-%m', B.delivered_at) AS month,
COUNT(DISTINCT C.id) AS  distinct_users,
SUM(A.inventory_item_id * A.sale_price) / COUNT(DISTINCT A.inventory_item_id) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items AS A
JOIN bigquery-public-data.thelook_ecommerce.orders AS B
ON A.order_id=B.order_id
JOIN bigquery-public-data.thelook_ecommerce.users AS C
ON A.id=C.id
WHERE B.status = 'Complete' AND
B.created_at >= '2019-01-01' AND B.created_at <= '2022-04-30'
GROUP BY FORMAT_DATE('%Y-%m', B.delivered_at)
ORDER BY month

-- 3
WITH ABC AS 
(SELECT
        first_name,
        last_name,
        gender,
        age,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY age) AS youngest_rank,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY age DESC) AS oldest_rank
    FROM
        bigquery-public-data.thelook_ecommerce.users
    WHERE
        age IS NOT NULL
        AND created_at <= '2022-04-30'
        AND created_at >= '2019-01-01')
  
SELECT
    first_name,
    last_name,
    gender,
    age,
    CASE
        WHEN youngest_rank = 1 THEN 'youngest'
        WHEN oldest_rank = 1 THEN 'oldest'
        ELSE NULL
    END AS tag
FROM
    ABC
WHERE
    youngest_rank = 1 OR oldest_rank = 1
ORDER BY
    gender, tag

-- 4
Select * from 
(With monthly_profit as
(Select 
  CAST(FORMAT_DATE('%Y-%m', t1.delivered_at) AS STRING) as month_year,
  t1.product_id as product_id,
  t2.name as product_name,
  round(sum(t1.sale_price),2) as sales,
  round(sum(t2.cost),2) as cost,
  round(sum(t1.sale_price)-sum(t2.cost),2)  as profit
from bigquery-public-data.thelook_ecommerce.order_items as t1
Join bigquery-public-data.thelook_ecommerce.products as t2 
on t1.product_id=t2.id
Where t1.status='Complete'
Group by 
month_year,
t1.product_id, 
t2.name)


Select * ,
dense_rank() OVER ( PARTITION BY month_year ORDER BY month_year,profit) as rank from onthly_profit) as rank_table
Where rank_table.rank <= 5
order by rank_table.month_year

-- 5
SELECT
    DATE(A.created_at) AS dates,
    C.category AS product_categories,
    ROUND(SUM(B.sale_price)) AS revenue
FROM
    bigquery-public-data.thelook_ecommerce.orders AS A
JOIN
    bigquery-public-data.thelook_ecommerce.order_items AS B 
    ON A.order_id = B.order_id
JOIN
    bigquery-public-data.thelook_ecommerce.products AS C 
    ON B.id = C.id
WHERE
    A.status = 'Complete'
    AND A.created_at >= '2022-01-15'
    AND A.created_at <= '2022-04-15'
GROUP BY
    DATE(A.created_at),
    C.category
ORDER BY
    revenue DESC







-- PART 2
-- 1
WITH ABC AS
(SELECT
FORMAT_DATE('%m', B.delivered_at) AS month,
FORMAT_DATE('%Y', B.delivered_at) AS year,
C.category AS Product_category,
SUM(A.sale_price) AS TPV,
COUNT(DISTINCT A.order_id) AS TPO,
SUM(C.cost) AS Total_cost,
SUM(A.sale_price) - SUM(C.cost) AS Total_profit,
(SUM(A.sale_price) - SUM(C.cost))/SUM(C.cost) AS Profit_to_cost_ratio
FROM bigquery-public-data.thelook_ecommerce.order_items AS A
JOIN bigquery-public-data.thelook_ecommerce.orders AS B
ON A.order_id= B.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS C
ON A.id=C.id
GROUP BY FORMAT_DATE('%m', B.delivered_at),
FORMAT_DATE('%Y', B.delivered_at),
C.category
ORDER BY year, month)
        
SELECT 
*,

ROUND((ABC.TPV - LAG(ABC.TPV) OVER(PARTITION BY ABC.Product_category ORDER BY ABC.month, ABC.year))
/LAG(ABC.TPV) OVER(PARTITION BY ABC.Product_category ORDER BY ABC.month, ABC.year), 2)||'%' AS Revenue_growth,

ROUND((ABC.TPO - LAG(ABC.TPO) OVER(PARTITION BY ABC.Product_category ORDER BY ABC.month, ABC.year))
/LAG(ABC.TPO) OVER(PARTITION BY ABC.Product_category ORDER BY ABC.month, ABC.year), 2) ||'%' AS Order_growth
FROM ABC
WHERE ABC.month is not null and ABC.year is not null

-- 2
	WITH ONLINE_RETAIL_INDEX AS
(SELECT 
customer_id, 
amount,
FORMAT_DATE('%Y-%m', first_purchase_date) AS cohort_date,
date,
(EXTRACT(YEAR FROM date) - EXTRACT(YEAR FROM first_purchase_date))*12
+ 
(EXTRACT(MONTH FROM date) - EXTRACT(MONTH FROM first_purchase_date))
+ 1 AS INDEX
FROM
(SELECT 
A.user_id AS customer_id, 
A.created_at AS date,
SUM(B.sale_price) OVER(PARTITION BY A.user_id) AS amount,
MIN(A.created_at) OVER(PARTITION BY A.user_id) AS first_purchase_date
FROM bigquery-public-data.thelook_ecommerce.orders AS A
JOIN bigquery-public-data.thelook_ecommerce.order_items AS B
ON A.order_id=B.order_id) A),
ABC AS
(SELECT 
cohort_date, 
index,
COUNT(DISTINCT customer_id) AS cnt,
SUM(amount) AS revenue 
FROM ONLINE_RETAIL_INDEX
GROUP BY cohort_date, index
)

,

CUSTOMER_COHORT AS
(SELECT cohort_date,
  SUM((CASE WHEN INDEX = 1 THEN CNT ELSE 0 END)) AS M_1,
	SUM((CASE WHEN INDEX = 2 THEN CNT ELSE 0 END)) AS M_2,
	SUM((CASE WHEN INDEX = 3 THEN CNT ELSE 0 END)) AS M_3,
	SUM((CASE WHEN INDEX = 4 THEN CNT ELSE 0 END)) AS M_4,
	SUM((CASE WHEN INDEX = 5 THEN CNT ELSE 0 END)) AS M_5,
	SUM((CASE WHEN INDEX = 6 THEN CNT ELSE 0 END)) AS M_6,
	SUM((CASE WHEN INDEX = 7 THEN CNT ELSE 0 END)) AS M_7,
	SUM((CASE WHEN INDEX = 8 THEN CNT ELSE 0 END)) AS M_8,
	SUM((CASE WHEN INDEX = 9 THEN CNT ELSE 0 END)) AS M_9,
	SUM((CASE WHEN INDEX = 10 THEN CNT ELSE 0 END)) AS M_10,
	SUM((CASE WHEN INDEX = 11 THEN CNT ELSE 0 END)) AS M_11,
	SUM((CASE WHEN INDEX = 12 THEN CNT ELSE 0 END)) AS M_12,
	SUM((CASE WHEN INDEX = 13 THEN CNT ELSE 0 END)) AS M_13
FROM ABC
GROUP BY COHORT_DATE
ORDER BY cohort_date)

SELECT
	COHORT_DATE,
	ROUND(100.00 * M_1/M_1, 2) || '%' AS M_1,
	ROUND(100.00 * M_2/M_1, 2) || '%' AS M_2,
	ROUND(100.00 * M_3/M_1, 2) || '%' AS M_3,
	ROUND(100.00 * M_4/M_1, 2) || '%' AS M_4,
	ROUND(100.00 * M_5/M_1, 2) || '%' AS M_5,
	ROUND(100.00 * M_6/M_1, 2) || '%' AS M_6,
	ROUND(100.00 * M_7/M_1, 2) || '%' AS M_7,
	ROUND(100.00 * M_8/M_1, 2) || '%' AS M_8,
	ROUND(100.00 * M_9/M_1, 2) || '%' AS M_9,
	ROUND(100.00 * M_10/M_1, 2) || '%' AS M_10,
	ROUND(100.00 * M_11/M_1, 2) || '%' AS M_11,
	ROUND(100.00 * M_12/M_1, 2) || '%' AS M_12,
	ROUND(100.00 * M_13/M_1, 2) || '%' AS M_13	
FROM CUSTOMER_COHORT

