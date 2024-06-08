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
--- Data Science Skills [LinkedIn SQL Interview Question]
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id
--- Average Post Hiatus (Part 1) [Facebook SQL Interview Question]
SELECT user_id,  
DATE(MAX(post_date)) - DATE(MIN(post_date)) as days_between
FROM posts where post_date >= '01/01/2021' and post_date <= '12/31/2021'
GROUP BY user_id
HAVING COUNT(POST_ID) >=2
--- Cards Issued Difference [JPMorgan Chase SQL Interview Question]
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
ORDER BY difference DESC
--- Pharmacy Analytics (Part 2) [CVS Health SQL Interview Question]
SELECT manufacturer, COUNT(drug) as drug_count,
abs(SUM(cogs-total_sales)) as total_loss
FROM pharmacy_sales
where total_sales - cogs <=0
GROUP BY manufacturer
ORDER BY total_loss DESC;
--- Not Boring Movies
select * from cinema
where description != 'boring' and id%2=1
order by rating DESC
--- Number of Unique Subjects Taught by Each Teacher
select teacher_id,
count(distinct subject_id) as cnt
from teacher
group by teacher_id
--- Find Followers Count
select user_id, 
count(distinct follower_id) as followers_count
from followers
group by user_id
--- class no more than 5 students
select class,
count(distinct student)
from courses
group by class
having count(distinct student) >=5
