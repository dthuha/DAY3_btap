SELECT * FROM public.sales_dataset_rfm_prj_clean;
--1
SELECT productline, year_id, dealsize,
	SUM(sales) AS REVENUE
FROM public.sales_dataset_rfm_prj_clean
GROUP BY productline, year_id, dealsize;

--2
SELECT month_id,
	SUM(sales) AS REVENUE,
	ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS ORDER_NUMBER
FROM public.sales_dataset_rfm_prj_clean
GROUP BY month_id;

--3
SELECT 
	month_id,
	productline, 
	SUM(sales) AS REVENUE,
	ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS ORDER_NUMBER	
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id = 11
GROUP BY month_id, productline;

--4
SELECT 
	year_id,
	productline,
	SUM(sales) AS REVENUE,
	ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC, year_id) AS RANK
FROM public.sales_dataset_rfm_prj_clean
WHERE country = 'UK'
GROUP BY year_id, productline;

--5
WITH CUSTOMER_RFM AS
(SELECT 
	customername,
	CURRENT_DATE - MAX(orderdate) AS R,
	COUNT(DISTINCT ordernumber) AS F,
	SUM(sales) AS M
FROM public.sales_dataset_rfm_prj_clean
GROUP BY customername)
	,
RFM_SCORE AS
(SELECT 
	customername,
	NTILE(5) OVER(ORDER BY R DESC) AS R_SCORE, 
	NTILE(5) OVER(ORDER BY F) AS F_SCORE,
	NTILE(5) OVER(ORDER BY M) AS M_SCORE	
FROM CUSTOMER_RFM)
	,
RFM_FINAL AS
(SELECT 
	customername,
	CAST(R_SCORE AS VARCHAR)
	||
	CAST(F_SCORE AS VARCHAR)
	||
	CAST(M_SCORE AS VARCHAR)
	AS RFM_SCORE
FROM RFM_SCORE)

SELECT segment, COUNT(*) FROM	
	
	
(SELECT T2.segment, T1.customername
FROM RFM_FINAL AS T1
JOIN public.segment_score AS T2
ON T1.RFM_SCORE=T2.scores) 
	AS A
	
GROUP BY segment
ORDER BY COUNT(*)
