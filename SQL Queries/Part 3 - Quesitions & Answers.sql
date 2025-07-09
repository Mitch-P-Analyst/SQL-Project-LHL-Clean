--  Part 3: Starting With Questions

-- Question 1: 
-- Which cities and countries have the highest level of transaction revenues on the site?


-- Each countries' total transaction revenue query
SELECT
	country,
	SUM(transactions) AS num_transactions,
	ROUND((SUM(transactionrevenue)/1000000),2) AS transaction_revenue,
	ROUND((SUM(totaltransactionrevenue)/1000000),2) AS total_transaction_revenue
FROM all_sessions
-- WHERE transactions >= 1
GROUP BY country
HAVING SUM(totaltransactionrevenue) >= 1 OR SUM(transactionrevenue) >= 1
ORDER BY total_transaction_revenue DESC


-- Each city's total transaction revenue query

SELECT
	CASE
  		WHEN city = 'New York' THEN 'United States'
  		ELSE country
	END AS country_cleaned,
	CASE
		WHEN city = 'not available in demo dataset' OR city = '(not set)'
			THEN NULL
		ELSE city
	END AS city_cleaned,
	SUM(transactions) AS num_transactions,
	ROUND((SUM(transactionrevenue)/1000000),2) AS transaction_revenue,
	ROUND((SUM(totaltransactionrevenue)/1000000),2) AS total_transaction_revenue
FROM all_sessions
GROUP BY country_cleaned, city_cleaned
HAVING SUM(totaltransactionrevenue) >= 1 OR SUM(transactionrevenue) >= 1
ORDER BY total_transaction_revenue DESC

-- Question 2: 
-- What is the average number of products ordered from visitors in each city and country?

-- Units sold acquired from Analytics

SELECT *
FROM analytics
WHERE units_sold IS NOT NULL

-- Visitor ids when units are sold

SELECT COUNT(fullvisitorid) AS all_vistor_ids,
	COUNT (DISTINCT(fullvisitorid)) AS distinct_vistor_ids
FROM analytics
WHERE units_sold IS NOT NULL

-- Join w/ all_session tables to acquire customer details 

-- Avg Units Per Country

WITH visitor_units AS( 
	SELECT
		CASE
  		WHEN als.city = 'New York' THEN 'United States'
  		ELSE als.country
	END AS country_cleaned,
	-- als.fullvistorid AS session_visitorids,
	-- a.fullvisitorid AS analytics_vistiorids,
	ROUND(AVG(a.units_sold),2) AS Avg_Units_Ordered
FROM all_sessions AS als
	JOIN analytics AS a
		ON als.fullvistorid = a.fullvisitorid 
WHERE a.units_sold IS NOT NULL
GROUP BY country_cleaned
)

SELECT *
FROM visitor_units
ORDER BY Avg_Units_Ordered DESC;



-- Avg Units Per City & Country


WITH visitor_units AS( 
	SELECT
		CASE
  		WHEN als.city = 'New York' THEN 'United States'
  		ELSE als.country
	END AS country_cleaned,
	CASE
		WHEN als.city = 'not available in demo dataset' OR als.city = '(not set)'
			THEN NULL
		ELSE als.city
	END AS city_cleaned,
	-- als.fullvistorid AS session_visitorids,
	-- a.fullvisitorid AS analytics_vistiorids,
	ROUND(AVG(a.units_sold),2) AS Avg_Units_Ordered
FROM all_sessions AS als
	JOIN analytics AS a
		ON als.fullvistorid = a.fullvisitorid 
WHERE a.units_sold IS NOT NULL
GROUP BY country_cleaned, city_cleaned
)

SELECT *
FROM visitor_units
ORDER BY Avg_Units_Ordered DESC;


-- Question 3: 
-- Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?


-- Identify all relavent product categories and categorize v2productnames accordingly


CREATE VIEW product_categories AS (
-- Identify present categories via Arrayformula 
WITH 
categories AS (
	SELECT 
	DISTINCT(LOWER(TRIM(p.name))) AS product_name,
		REGEXP_MATCH(LOWER(TRIM(als.v2productcategory)),'apparel|electronics|accessories|bags|office|kids|lifestyle|drinkware') AS product_category
	FROM all_sessions AS als
		JOIN products AS p
			ON als.productsku = p.sku
	
	),
-- Assigned categorises to NULL values by key identifiers
populated_categories AS (
	SELECT
		DISTINCT(product_name),
		CASE
			-- Office Item Identifiers
			WHEN product_name ILIKE '%Pen%' 
			OR 	 product_name ILIKE '%Journal%' 
			OR 	 product_name ILIKE '%Suitcase%'
			OR 	 product_name ILIKE '%Notebook%' 
			OR 	 product_name ILIKE '%mouse pad%' 
				THEN '{office}'

			-- Accessory Item Identifiers
			WHEN product_name ILIKE '%sticker%' 
			OR 	 product_name ILIKE '%essentials baby set%' 
			OR 	 product_name ILIKE '%sanitizer%'
			OR 	 product_name ILIKE '%luggage%' 
			OR 	 product_name ILIKE '%accessories%' 
			OR 	 product_name ILIKE '%screen cleaning%'
			OR 	 product_name ILIKE '%gift card%'
			OR 	 product_name ILIKE '%device stand%'
			OR 	 product_name ILIKE '%decal%'
			OR 	 product_name ILIKE '%windup%'
				THEN '{accessories}'

			-- Apparel Item Identifiers
			WHEN product_name ILIKE '%Men%' 
			OR 	 product_name ILIKE '%Women%'  
			OR 	 product_name ILIKE '%Hat%'
			OR 	 product_name ILIKE '%Cap%'
			OR 	 product_name ILIKE '%Tee%'
			OR 	 product_name ILIKE '%Shirt%'
			OR 	 product_name ILIKE '%sleeve%'
			OR 	 product_name ILIKE '%socks%'
				THEN '{apparel}'

			-- Lifestyle Item Identifiers
			WHEN product_name ILIKE '%Yoga%' 
			OR 	 product_name ILIKE '%Frisbee%'
			OR 	 product_name ILIKE '%Lunch%'
			OR 	 product_name ILIKE '%Selfie%'
			OR 	 product_name ILIKE '%Dog%'
			OR 	 product_name ILIKE '%games%'
			OR 	 product_name ILIKE '%pet%'
			OR 	 product_name ILIKE '%sunglasses%'
				THEN '{lifestyle}'

			-- Kids Item Identifiers
			WHEN product_name ILIKE '%Toddler%'
			OR 	 product_name ILIKE '%Infant%'
			OR 	 product_name ILIKE '%Onesie%'
			OR 	 product_name ILIKE '%Youth%'
			OR 	 product_name ILIKE '%Bib%'
				THEN '{kids}'

			-- Drinkware Item Identifiers
			WHEN product_name ILIKE '%Bottle%'
			OR 	 product_name ILIKE '%Tumbler%'
			OR 	 product_name ILIKE '%Mug%'
				THEN '{drinkware}'
				
			-- Electronic Item Identifiers
			WHEN product_name ILIKE '%Bluetooth%' 
			OR 	 product_name ILIKE '%Charger%' 
			OR 	 product_name ILIKE '%Flashlight%' 
			OR 	 product_name ILIKE '%Speaker%' 
			OR 	 product_name ILIKE '%electronics%' 
			OR 	 product_name ILIKE '%power bank%'
			OR 	 product_name ILIKE '%thermostat%'
			OR 	 product_name ILIKE '%alarm%'
			OR 	 product_name ILIKE '%camera%'
				THEN '{electronics}'

			-- Bags Item Identifiers
			WHEN product_name ILIKE '%Rucksack%' 
			OR 	 product_name ILIKE '%Bag%' 
			OR 	 product_name ILIKE '%Backpack%' 
				THEN '{bags}'

			ELSE product_category
			
		END AS populated_category
	FROM categories
)
SELECT *
FROM populated_categories
)

-- View created
SELECT *
FROM product_categories
ORDER BY product_name

-- Isolate all_session table records by Units_Ordered associated with vistorid

-- CTE Isolating vistor sessions by country, city and units sold
WITH visitor_units_CTE AS( 
	SELECT
		CASE
  			WHEN als.city = 'New York' THEN 'United States'
  			ELSE als.country
		END AS country_cleaned,
	CASE
		WHEN als.city = 'not available in demo dataset' OR als.city = '(not set)'
			THEN NULL
		ELSE als.city
	END AS city_cleaned,
	LOWER(TRIM(p.name)) AS product_name,
	a.units_sold AS units_sold
FROM all_sessions AS als
	JOIN analytics AS a
		ON als.fullvistorid = a.fullvisitorid 
	JOIN products AS p
		ON p.sku = als.productsku
WHERE a.units_sold IS NOT NULL
)
-- attempted a Window, but instead doing numerous group bys to view quantities of units sold by product_category by city & country
SELECT 
	vu.country_cleaned,
	vu.city_cleaned,
	pc.populated_category AS product_category,
	SUM(vu.units_sold) AS total_units_sold
FROM visitor_units_CTE AS vu
	JOIN product_categories AS pc
		ON vu.product_name = pc.product_name
GROUP BY vu.country_cleaned,vu.city_cleaned, pc.populated_category
HAVING vu.city_cleaned IS NOT NULL
ORDER BY vu.country_cleaned,vu.city_cleaned, total_units_sold DESC

-- Question 4: 
-- What is the top-selling product from each city/country?
-- Can we find any pattern worthy of noting in the products sold?


-- Using the similar methodolgy and 'Product_Cateogries' View from the previous question
-- Joining tables 'products' to secure accurate product names and 'analytics' to secure units_ordered, with primary table 'all_sessions'
-- isolate and group by country and city


-- Create Temporary Table to reference for analytical insights

CREATE TEMP TABLE top_city_products AS(

-- CTE acquring all required data (Country, City, Product Name, Units Sold
WITH country_city_product AS( 
	SELECT
		CASE
  			WHEN als.city = 'New York' THEN 'United States'
  			ELSE als.country
		END AS country_cleaned,
		CASE
			WHEN als.city = 'not available in demo dataset' OR als.city = '(not set)'
				THEN NULL
			ELSE als.city
		END AS city_cleaned,
		LOWER(TRIM(p.name)) AS productname,
		SUM(a.units_sold) AS units_sold
FROM all_sessions AS als
	JOIN analytics AS a
		ON als.fullvistorid = a.fullvisitorid 
	JOIN products AS p
		ON als.productsku = p.sku
WHERE a.units_sold IS NOT NULL
GROUP BY country_cleaned,city_cleaned,productname
),

-- CTE Ranking units_sold by country,city
top_country_city_product AS(
SELECT 
	country_cleaned,
	city_cleaned,
	productname,
	SUM(units_sold) AS total_units_sold,
	RANK() OVER(PARTITION BY country_cleaned,city_cleaned ORDER BY SUM(units_sold) DESC )
		AS product_rank
FROM country_city_product
GROUP BY country_cleaned,city_cleaned,productname
)

-- Main query, filtering Ranked Window by 1 output for country,city
SELECT 
	country_cleaned,
	city_cleaned,
	productname,
	pc.populated_category,
	total_units_sold,
	product_rank
FROM top_country_city_product AS tccp
	JOIN product_categories AS pc
		ON pc.product_name = tccp.productname
WHERE product_rank = 1
	AND city_cleaned IS NOT NULL

-- End Temporary Table
)

-- Validate entry of Temporary Table of Top Products Per City
SELECT *
FROM top_city_products
ORDER BY country_cleaned, city_cleaned



-- Find any relavent trends in 'top_city_products' TEMP TABLE



-- There are 64 records for 62 cities, resulting from two cities with two #1_Ranked product
SELECT DISTINCT country_cleaned,city_cleaned
FROM top_city_products
-- From 62 city/countries, there are 55 distinct products ranked 1
SELECT 
COUNT(DISTINCT productname) 
FROM top_city_products



-- Counting the quantity each product is ranked as the #1 product.

SELECT 
	DISTINCT productname,
	populated_category,
	COUNT(productname) AS cities_with_top_product
FROM top_city_products
GROUP BY productname,populated_category
ORDER BY cities_with_top_product DESC

-- No pattern worthy of noting





--Question 5: 
-- Can we summarize the impact of revenue generated from each city/country?

-- Value of revenue acquired from 'Analytics' table, with columns 'units_sold' and 'unit_price'
-- JOIN with 'All_Sessions' table to analyze grouped revenue by city, country

-- Using previously established CTE for city, country
-- Additional data of unit_price from 'Analytics Table'

WITH country_city_product AS( 
	SELECT
		CASE
  			WHEN als.city = 'New York' THEN 'United States'
  			ELSE als.country
		END AS country_cleaned,
		CASE
			WHEN als.city = 'not available in demo dataset' OR als.city = '(not set)'
				THEN NULL
			ELSE als.city
		END AS city_cleaned,
		LOWER(TRIM(p.name)) AS productname,
		a.unit_price/1000000 AS product_price,
		SUM(a.units_sold) AS units_sold
FROM all_sessions AS als
	JOIN analytics AS a
		ON als.fullvistorid = a.fullvisitorid 
	JOIN products AS p
		ON als.productsku = p.sku
WHERE a.units_sold IS NOT NULL
GROUP BY country_cleaned,city_cleaned,productname,product_price
)
-- Summarising total revenue of prices for each product, grouped by country and city
SELECT 
	country_cleaned,
	city_cleaned,
	ROUND(SUM((product_price * units_sold)),2) As total_revenue
FROM country_city_product
WHERE city_cleaned IS NOT NULL
GROUP BY country_cleaned, city_cleaned
ORDER BY total_revenue DESC



