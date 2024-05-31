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
-- ex7
select distinct city from station where left(city,1) not in ('a', 'u', 'i', 'e', 'o')
