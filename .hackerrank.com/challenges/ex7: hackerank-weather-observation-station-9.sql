-- ex1
select name from city where population >120000 and countrycode = 'USA'
-- ex2
-- ex3
-- ex4
-- ex5
-- ex6
-- ex7
select distinct city from station where left(city,1) not in ('a', 'u', 'i', 'e', 'o')
