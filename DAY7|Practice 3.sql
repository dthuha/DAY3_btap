--- Higher Than 75 Marks
select name
from students where marks >75
order by right(name, 3), ID
--- Fix Names in a Table
  --c1
SELECT user_id, 
concat(Upper(LEFT(NAME,1)), lower(RIGHT(NAME,LENGTH(NAME)-1))) as name
FROM USERS
ORDER BY USER_ID
--c2
SELECT user_id, 
concat(Upper(LEFT(NAME,1)), lower(substring(name,2))) as name
FROM USERS
ORDER BY USER_ID
--- Pharmacy Analytics (Part 3) [CVS Health SQL Interview Question]
SELECT manufacturer,
'$'||round(sum(total_sales)/1000000,0)||' '||'million' as sale --- nếu k chia cho 1000000 thì kqua ở dạng 113777182.55 trg khi đấy bài ycau làm tròn đến million
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY round(sum(total_sales)/1000000,0) DESC, left(manufacturer,1) desc;
--- Average Review Ratings [Amazon SQL Interview Question]
SELECT EXTRACT(month from submit_date) as mth, product_id as product, 
ROUND(avg(stars),2) as avg_stars
FROM reviews
GROUP BY EXTRACT(month from submit_date), product_id
ORDER BY mth
--- Teams Power Users [Microsoft SQL Interview Question]
SELECT SENDER_ID, 
COUNT(MESSAGE_ID) AS message_count
FROM messages
WHERE EXTRACT(month from sent_date) = '8' AND EXTRACT(year from sent_date) = '2022'
GROUP BY SENDER_ID
ORDER BY message_count DESC
LIMIT 2
--- Invalid Tweets
select tweet_id
from tweets where length(content)>15
--- ex7
--- Number of Hires During Specific Time Period
select count(id)
from employees
where extract(month from joining_date) between '1' and '7'
and extract(year from joining_date) = '2022'
--- Positions Of Letter 'a' (câu này anh/chị check giúp em xem có đúm khôm ạ)
select
position('a' in substring('Amitah' from first_name))
from worker;
--- Macedonian Vintages
SELECT SUBSTRING(TITLE, LENGTH(winery)+2, 4)
FROM winemag_p2 WHERE COUNTRY = 'Macedonia'
