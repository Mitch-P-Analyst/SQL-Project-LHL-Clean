Question 1: 

What is the average time spent on site?

SQL Queries:
``` sql

SELECT
	AVG((timeonsite::REAL)/60)::REAL AS Average_Minutes_On_Site
FROM all_sessions
WHERE timeonsite IS NOT NULL

```

Answer: 
Average amount of time spent on site is 3.75 minutes


Question 2: 

What percentage of products have not sold at least 1 unit?

SQL Queries:
``` sql
WITH Units_Sold_CTE AS (SELECT 
	(total_ordered >=1)::BOOLEAN AS Units_Have_Sold
FROM sales_by_sku)

SELECT
	((SELECT COUNT(Units_Have_Sold)
		FROM Units_Sold_CTE 
		WHERE Units_Have_Sold = FALSE)
		/
	COUNT(Units_Have_Sold)::REAL)*100 AS Percent_Of_Products_With_0_Sales
FROM Units_Sold_CTE

```
Answer:
33.77% of products, as referenced in the 'sales_by_sku' table, have not sold any units.


Question 3: 

What products have the longest and shortest restocking time?

SQL Queries:
``` sql

WITH products_restocking AS(
SELECT 
	name,
	restockingleadtime
FROM sales_report
),
restocking_stats AS(
SELECT 
	MAX(restockingleadtime) AS  MAX_restocking_time,
	MIN(restockingleadtime) AS  MIN_restocking_time
FROM sales_report
)

SELECT pr.*
FROM products_restocking AS pr
	CROSS JOIN restocking_stats AS rs
WHERE pr.restockingleadtime = rs.MAX_restocking_time
	OR pr.restockingleadtime = rs.MIN_restocking_time


```
Answer:

<!-- Time variable not estalbished -->

| Product Name 						| Rank Of Restocking Time | Time |
|-----------------------------------|-------------------------|------|
| Cam Indoor Security Camera - USA  | Longest				  | 42   |
| Satin Black Ballpoint Pen			| Shortest 				  | 2    |
| Twill Cap							| Shortest 				  | 2    |
| Badge Holder						| Shortest 				  | 2    |
| 22 oz Water Bottle 				| Shortest 				  | 2    |
|-----------------------------------|-------------------------|------|

