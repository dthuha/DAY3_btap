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
    gender, tag;

-- 4

