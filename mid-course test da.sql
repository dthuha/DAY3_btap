-- MID-COURSE TEST DA by Julie
-- Dao_Thu_Ha

-- B1
SELECT MIN(DISTINCT replacement_cost) FROM FILM;

-- B2
SELECT
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
END category,
COUNT
(CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1
	ELSE 0
END)
FROM FILM
GROUP BY category;

-- B3
-- nháp
SELECT * FROM public.film;
SELECT * FROM public.film_category;
SELECT * FROM public.category;

-- bài làm
SELECT 
	t1.title, 
	t1.length, 
	t2.category_id, 
	t3.name
	
FROM public.film AS t1
JOIN public.film_category AS t2
ON t1.film_id=t2.film_id
JOIN public.category AS t3
ON t2.category_id=t3.category_id
	
WHERE t3.name ='Drama' OR t3.name ='Sports'
ORDER BY t1.length DESC;

-- B4
SELECT 
	t3.name,
	COUNT(t1.title) AS count_title
	
FROM public.film AS t1
JOIN public.film_category AS t2
ON t1.film_id=t2.film_id
JOIN public.category AS t3
ON t2.category_id=t3.category_id
	
GROUP BY t3.name
ORDER BY COUNT(t1.title) DESC;

-- B5
-- nháp
SELECT * FROM public.actor;
SELECT * FROM public.film_actor;
SELECT * FROM public.film;

-- bài làm
SELECT
	UPPER(LEFT(LOWER(t1.first_name),1))||LOWER(substring(t1.first_name, 2))||' '||
	UPPER(LEFT(LOWER(t1.last_name),1))||LOWER(substring(t1.last_name, 2)) AS full_name,
	COUNT(film_id)
	
FROM public.actor AS t1
JOIN public.film_actor AS t2
ON t1.actor_id=t2.actor_id
	
GROUP BY full_name
ORDER BY COUNT(film_id) DESC;

-- B6
-- phần 1
SELECT 
	t1.address, 
	t1.address_id, 
	t2.customer_id
	
FROM public.address AS t1
LEFT JOIN public.customer AS t2
ON t1.address_id=t2.address_id
	
WHERE t2.customer_id is null;

-- phần 2
SELECT 
	t1.address, 
	t1.address_id, 
	t2.customer_id,
	COUNT(*)
FROM public.address AS t1
LEFT JOIN public.customer AS t2
ON t1.address_id=t2.address_id
	
WHERE t2.customer_id is null;

-- B7
-- nháp
SELECT * FROM public.address;
SELECT * FROM public.city WHERE city = 'Cape Coral';
SELECT * FROM public.payment;
SELECT * FROM public.staff; -- CUSTOMER kphai staff

-- bài làm
SELECT 
	T4.city, 
	SUM(T1.amount)
	
FROM public.payment AS T1
FULL JOIN public.customer AS T2
ON T1.customer_id=T2.customer_id
FULL JOIN public.address AS T3
ON T2.address_id=T3.address_id
FULL JOIN public.city AS T4
ON T3.city_id=T4.city_id
	
GROUP BY T4.city
ORDER BY SUM(T1.amount) DESC;

-- B8
-- nháp
SELECT * FROM public.address;
SELECT * FROM public.city;
SELECT * FROM public.payment;
SELECT * FROM public.customer;
SELECT * FROM public.country WHERE country = 'United States';

-- bài làm
SELECT 
	T5.country||','||' '||T4.city AS full_name,
	SUM(T1.amount)
	
FROM public.payment AS T1
JOIN public.customer AS T2
ON T1.customer_id=T2.customer_id
JOIN public.address AS T3
ON T2.address_id=T3.address_id
JOIN public.city AS T4
ON T3.city_id=T4.city_id
JOIN public.country AS T5
ON T4.country_id=T5.country_id

GROUP BY full_name
ORDER BY SUM(T1.amount) DESC;
