-- hackerrank
-- ex1
select name from city where population >120000 and countrycode = 'USA'
-- ex2
select * from city where countrycode = 'JPN'
-- ex3
select city state from station
-- ex4
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'
-- ex5
SELECT distinct city FROM STATION WHERE CITY like '%a' or CITY like '%e' or CITY like '%i' or CITY like '%o' or CITY like '%u'
-- ex6
SELECT distinct city FROM STATION WHERE left(city, 1) in ('a', 'e', 'i', 'o', 'u') and right(city, 1) in ('a', 'e', 'i', 'o', 'u')
  -- Weather Observation Station 09
select distinct city from station where left(city,1) not in ('a', 'u', 'i', 'e', 'o')
-- Weather Observation Station 10
select distinct city from station where right (city,1) not in ('a', 'e', 'i', 'o', 'u')
  -- Weather Observation Station 11
select distinct city from station where NOT (left (city,1) in ('a', 'e', 'i', 'o', 'u')  AND right (city,1) in ('a', 'e', 'i', 'o', 'u'))
  -- Weather Observation Station 12
SELECT DISTINCT CITY FROM STATION WHERE NOT (LEFT (CITY,1) IN ('A', 'E', 'I', 'O', 'U') OR RIGHT (CITY,1) IN ('A', 'E', 'I', 'O', 'U'))
  -- Employee Names
select name from employee ORDER BY name
  -- Employee Salaries
select name from employee where salary >2000 and months <10 order by employee_id

-- leetcode
-- recyclable and low fat products
select product_id from  Products where low_fats = 'Y' AND recyclable = 'Y'
-- find customer id
select name from customer where referee_id !=2 or referee_id is null
-- big countries
select name, population, area from world where area >=3000000 or population >=25000000
-- acticles views I
select distinct author_id as id from views where viewer_id = author_id order by author_id

-- datalemur
-- tesla unfinished parts
SELECT part, assembly_step FROM parts_assembly where finish_date is null
-- lyft driver
SELECT * FROM lyft_drivers WHERE yearly_salary <= 30000 OR yearly_salary >= 70000
-- advertising channel
select advertising_channel from uber_advertising where money_spent >100000 and year = '2019'
