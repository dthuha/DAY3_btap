-- EX1: Y-on-Y Growth Rate [Wayfair SQL Interview Question]
-- tốc độ tăng trưởng hàng năm cho từng chi tiêu của từng sp, nhóm theo id sp
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
spend AS curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id, EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend,
ROUND((spend - LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id, EXTRACT(YEAR FROM transaction_date))) --- WINDOW FUNCTION đi dc với EXTRACT
LAG(spend) OVER (PARTITION BY product_id ORDER BY product_id, EXTRACT(YEAR FROM transaction_date))
*100, 2) AS yoy_rate
FROM user_transactions

-- EX2: Card Launch Success [JPMorgan Chase SQL Interview Question]
WITH ABC AS
(SELECT
card_name,
issued_amount,
issue_month||'/'||issue_year AS date,
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) as first_amount
FROM monthly_cards_issued)
SELECT DISTINCT(card_name), first_amount
FROM ABC
ORDER BY first_amount DESC
  
-- EX3: User's Third Transaction [Uber SQL Interview Question]
WITH ABC AS
(SELECT
user_id,
spend,
transaction_date,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS row_num
FROM transactions)
SELECT
user_id,
spend,
transaction_date
FROM ABC

-- EX4: Histogram of Users and Purchases [Walmart SQL Interview Question]
  -- ngày giao dịch gần nhất, id user, slg sp
WITH ABC AS
(SELECT
*,
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS STT
FROM user_transactions)
SELECT transaction_date, user_id, 
COUNT(spend) AS purchase_count
FROM ABC
WHERE STT =1
GROUP BY transaction_date, user_id
WHERE row_num = 3

-- EX5: Tweets' Rolling Averages [Twitter SQL Interview Question]
/*số lượng tweet trung bình luân phiên trong 3 ngày của mỗi người dùng. 
Xuất ID người dùng, ngày tweet và giá trị trung bình luân phiên được làm tròn đến 2 chữ số*/
WITH ABC AS
(SELECT    
user_id,    
tweet_date,
tweet_count,
AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM tweets)
SELECT user_id, tweet_date,
ROUND(rolling_avg, 2) AS rolling_avg_3d
FROM ABC

-- EX 6: Repeated Payments [Stripe SQL Interview Question]
WITH ABC AS 
(SELECT 
merchant_id,
credit_card_id,
amount,
transaction_timestamp,
EXTRACT(hour FROM transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount))* 60 
  + 
EXTRACT(minute FROM transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount)) 
AS TIME
FROM transactions)
  
SELECT COUNT(*) AS payment_count
FROM ABC
WHERE TIME BETWEEN 0 AND 10

-- EX7: Highest-Grossing Items [Amazon SQL Interview Question]
--2SP CÓ DOANH THU CAO NHẤT trong mỗi category trong 2022
WITH ABC_2 AS
(WITH ABC AS
(SELECT
product, category,
SUM(spend) AS total_spend
FROM product_spend 
WHERE EXTRACT(year from transaction_date) = '2022'
GROUP BY product, category
ORDER BY category)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_spend DESC) AS STT
FROM ABC)
SELECT category, product, total_spend
FROM ABC_2
WHERE STT IN (1,2)

-- EX8: Top 5 Artists [Spotify SQL Interview Question]
WITH ABC AS 
(SELECT T1.artist_name,
COUNT(*),
DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS dense_rank
FROM artists AS T1
JOIN songs AS T2
ON T1.artist_id=T2.artist_id
JOIN global_song_rank AS T3
ON T2.song_id=T3.song_id
WHERE T3.rank <=10
GROUP BY T1.artist_name)
SELECT artist_name, dense_rank FROM ABC
LIMIT 7
