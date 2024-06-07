--- hackerrank
--- Weather Observation Station 3
select distinct city from station
where id%2=0
--- Weather Observation Station 4
select count(city) - count(distinct city)
from station
--- Compressed Mean [Alibaba SQL Interview Question]
SELECT
round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) 
as mean
FROM items_per_order
---
