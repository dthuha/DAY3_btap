-- 1, LÀM SẠCH DỮ LIỆU
SELECT * FROM public.sales_dataset_rfm_prj;

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN priceeach 
TYPE NUMERIC USING (trim(priceeach)::NUMERIC);

SET datestyle = 'iso,mdy';  
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN orderdate TYPE date USING (orderdate):: date;
	
ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN ordernumber
TYPE INT USING (trim(ordernumber)::INT);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN quantityordered
TYPE INT USING (trim(quantityordered)::INT);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN orderlinenumber
TYPE INT USING (trim(orderlinenumber)::INT);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN sales
TYPE NUMERIC USING (trim(sales)::NUMERIC);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN status
TYPE CHAR(50) USING (trim(status)::CHAR(50));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN productline
TYPE CHAR(50) USING (trim(productline)::CHAR(50));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN msrp
TYPE INT USING (trim(msrp)::INT);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN productcode
TYPE VARCHAR USING (trim(productcode)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN customername
TYPE CHAR(100) USING (trim(customername)::CHAR(100));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN phone
TYPE VARCHAR USING (trim(phone)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN addressline1
TYPE VARCHAR USING (trim(addressline1)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN addressline2
TYPE VARCHAR USING (trim(addressline2)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN city
TYPE CHAR(50) USING (trim(city)::CHAR(50));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN state
TYPE CHAR(50) USING (trim(state)::CHAR(50));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN postalcode
TYPE VARCHAR USING (trim(postalcode)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN country
TYPE CHAR(50) USING (country)::CHAR(50);

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN territory
TYPE CHAR(50) USING (trim(territory)::CHAR(50));

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN contactfullname
TYPE VARCHAR USING (trim(contactfullname)::VARCHAR); -- kcan thiết

ALTER TABLE public.sales_dataset_rfm_prj ALTER COLUMN dealsize
TYPE CHAR(50) USING (trim(dealsize)::CHAR(50));


-- 2, CHECK NULL/BLANK
SELECT * FROM public.sales_dataset_rfm_prj
WHERE ORDERNUMBER IS NULL
  OR QUANTITYORDERED IS NULL 
  OR PRICEEACH IS NULL 
  OR ORDERLINENUMBER IS NULL 
  OR SALES IS NULL 
  OR ORDERDATE IS NULL ;


-- 3, first, last name
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN CONTACTLASTNAME VARCHAR(50);

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN CONTACTFIRSTNAME VARCHAR(50);

--- 3.1, CÁCH 1
UPDATE public.sales_dataset_rfm_prj
SET contactlastname = INITCAP(split_part(contactfullname, '-', 1)),  -- Lấy phần tử đầu tiên là HỌ
    contactfirstname = INITCAP(split_part(contactfullname, '-', 2)); -- Lấy phần tử thứ hai là TÊN

--- 3.2, CÁCH 2
/*draft*/
SELECT 
	contactfullname,
	POSITION('-' IN contactfullname),
	SUBSTRING(contactfullname, 10) AS T_1,
	SUBSTRING(contactfullname, 11) AS T_2,
	INITCAP(SUBSTRING(contactfullname, POSITION('-' IN contactfullname)+1)) AS thu_nghiem_1,
	INITCAP(SUBSTRING(contactfullname, 1, POSITION('-' IN contactfullname)-1)) AS thu_nghiem_2
FROM public.sales_dataset_rfm_prj;

/*bài hoàn chỉnh*/
UPDATE public.sales_dataset_rfm_prj
SET contactlastname = INITCAP(SUBSTRING(contactfullname, POSITION('-' IN contactfullname)+1)),
	contactfirstname = INITCAP(SUBSTRING(contactfullname, 1, POSITION('-' IN contactfullname)-1));


-- 4, Quý, tháng, năm
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID NUMERIC;

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN MONTH_ID NUMERIC;

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN YEAR_ID NUMERIC;


UPDATE public.sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM orderdate),
	YEAR_ID = EXTRACT(YEAR FROM orderdate),
	QTR_ID =
CASE
WHEN MONTH_ID BETWEEN 1 AND 3 THEN 1
WHEN MONTH_ID BETWEEN 4 AND 6 THEN 2
WHEN MONTH_ID BETWEEN 7 AND 9 THEN 3
WHEN MONTH_ID BETWEEN 10 AND 12 THEN 4
END
;

UPDATE public.sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM orderdate),
	YEAR_ID = EXTRACT(YEAR FROM orderdate),
	QTR_ID = EXTRACT(QUARTER FROM orderdate)
;

-- 5, OUTLIER
--- 5.1, CÁCH 1: BOXPLOT
WITH TWT_MIN_MAX_VALUE AS 
(SELECT
	Q1 - 1.5*IQR AS MIN_VALUE,
	Q3 + 1.5*IQR AS MAX_VALUE
FROM
(
SELECT 
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS Q1,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) AS Q3,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) AS IQR
FROM public.sales_dataset_rfm_prj
) AS A)

SELECT * FROM public.sales_dataset_rfm_prj
WHERE quantityordered < (SELECT MIN_VALUE FROM TWT_MIN_MAX_VALUE)
OR quantityordered > (SELECT MAX_VALUE FROM TWT_MIN_MAX_VALUE);

--- 5.1, CÁCH 2: Z SCORE
SELECT 
	AVG(quantityordered),
	STDDEV(quantityordered)
FROM public.sales_dataset_rfm_prj;

WITH CTE AS
(SELECT
	ordernumber, quantityordered,
(SELECT 
	AVG(quantityordered)
FROM public.sales_dataset_rfm_prj) AS AVG_1,
(SELECT 
	STDDEV(quantityordered)
FROM public.sales_dataset_rfm_prj) AS STDDEV_1
FROM public.sales_dataset_rfm_prj),
	
	TWT_OUTLIER AS
(SELECT ordernumber, quantityordered,
	(quantityordered - AVG_1)/STDDEV_1 AS Z_SCORE
FROM CTE
WHERE ABS((quantityordered - AVG_1)/STDDEV_1) >3)

-- xoá outliers
DELETE FROM public.sales_dataset_rfm_prj
WHERE quantityordered IN(SELECT quantityordered FROM TWT_OUTLIER)


-- 6, ĐỔI TÊN BẢNG
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
SELECT *
FROM public.sales_dataset_rfm_prj;
