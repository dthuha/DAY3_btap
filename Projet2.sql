-- 1
-- 2
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
