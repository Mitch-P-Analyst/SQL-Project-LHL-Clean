-- Question 1: 

-- What is the average time spent on site?
SELECT
	AVG((timeonsite::REAL)/60)::REAL AS Average_Minutes_On_Site
FROM all_sessions
WHERE timeonsite IS NOT NULL



-- Question 2: 

-- What percentage of products have not sold at least 1 unit?


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


-- Question 3: 

-- What products have the longest and shortest restocking time?


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
