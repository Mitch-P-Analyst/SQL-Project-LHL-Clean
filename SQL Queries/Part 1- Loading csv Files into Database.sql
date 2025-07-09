-- LHL SQL Project Ecommerce

-- Part 1: Loading csv Files into Database


-- Create 'all-sessions' table

CREATE TABLE all_sessions(
	fullvistorid INT,
	channelgrouping VARCHAR,
	time INT,
	country VARCHAR,
	city VARCHAR,
	totaltransactionrevenue NUMERIC,
	transactions INT,
	timeonsite INT,
	pageviews INT,
	sessionqualitydim INT,
	date VARCHAR,
	visitid INT,
	type VARCHAR,
	productrefundamount NUMERIC,
	productquantity INT,
	productprice NUMERIC,
	productrevenue NUMERIC,
	productSKU VARCHAR,
	v2productname VARCHAR,
	v2productcategory VARCHAR,
	productvariant VARCHAR,
	currencycode VARCHAR,
	itemquantity NUMERIC,
	itemrevenue NUMERIC,
	transactionrevenue NUMERIC,
	transactionid INT,
	pagetitle VARCHAR,
	searchkeyword VARCHAR,
	pagepathlevel1 VARCHAR,
	ecommerceaction_type INT,
	ecommerceaction_step INT,
	ecommerceaction_option VARCHAR
)

-- Alter column datatypes to match applicable vaues
ALTER TABLE all_sessions
ALTER COLUMN fullvistorid TYPE NUMERIC,
ALTER COLUMN transactionid TYPE VARCHAR;

-- Insert all_sessions data
COPY all_sessions (
	fullvistorid, 
	channelgrouping,
	time,
	country,
	city,
	totaltransactionrevenue,
	transactions,
	timeonsite,
	pageviews,
	sessionqualitydim,
	date,
	visitid,
	type,
	productrefundamount,
	productquantity,
	productprice,
	productrevenue,
	productSKU,
	v2productname,
	v2productcategory,
	productvariant,
	currencycode,
	itemquantity,
	itemrevenue,
	transactionrevenue,
	transactionid,
	pagetitle,
	searchkeyword,
	pagepathlevel1,
	ecommerceaction_type,
	ecommerceaction_step,
	ecommerceaction_option
) 
	FROM './Projects/SQL-Project-LHL/Data/Raw Data/all_sessions.csv'
	DELIMITER ','
CSV HEADER;

-- Validate data entry

SELECT *
FROM all_sessions

-- Create 'analytics table'

CREATE TABLE analytics (
	visitnumberv INT,
	visitId BIGINT,
	visitstartsime BIGINT,
	date VARCHAR,
	fullvisitorId NUMERIC,
	userid INT,
	channelgrouping VARCHAR,
	socialengagementtype VARCHAR,
	units_sold INT,
	pageviews INT,
	timeonsite INT,
	bounces INT,
	revenue NUMERIC,
	unit_price NUMERIC
)

-- Insert analytics table data

COPY analytics (
	visitnumberv,
	visitId,
	visitstartsime,
	date,
	fullvisitorId,
	userid,
	channelgrouping,
	socialengagementtype,
	units_sold,
	pageviews,
	timeonsite,
	bounces,
	revenue,
	unit_price
)
FROM './Projects/SQL-Project-LHL/Data/Raw Data/analytics.csv'
	DELIMITER ','
CSV HEADER;


--  Validate data entry

SELECT * 
FROM analytics 
LIMIT 100


-- Create products data table

CREATE TABLE products (
	SKU VARCHAR,
	name VARCHAR,
	orderedquantity INT,
	stocklevel INT,
	restockingleadtime INT,
	sentimentscore NUMERIC,
	sentimentmagnitude NUMERIC
)

-- Insert products table data

COPY products (
	SKU,
	name,
	orderedquantity,
	stocklevel,
	restockingleadtime,
	sentimentscore,
	sentimentmagnitude
)
	FROM './Projects/SQL-Project-LHL/Data/Raw Data/products.csv'
	DELIMITER ','
	CSV HEADER;

-- Validate data entry
SELECT * 
FROM products


-- Create sales_by_sku table

CREATE TABLE sales_by_sku (
	productSKU VARCHAR,
	total_ordered INT
)

-- Insert sales_by_sku table data

COPY sales_by_sku(
	productSKU,
	total_ordered
)
FROM './Projects/SQL-Project-LHL/Data/Raw Data/sales_by_sku.csv'
	DELIMITER ','
	CSV HEADER;

-- Validate data entry

SELECT * 
FROM sales_by_sku

-- Create sales_report table

CREATE TABLE sales_report (
	productSKU VARCHAR,
	total_ordered INT,
	name VARCHAR,
	stocklevel INT,
	restockingleadtime INT,
	sentimentscore NUMERIC,
	sentimentmagnitude NUMERIC,
	ratio NUMERIC
)

-- Insert sales_report table data

COPY sales_report (
	productSKU,
	total_ordered,
	name,
	stocklevel,
	restockingleadtime,
	sentimentscore,
	sentimentmagnitude,
	ratio
)
FROM './Projects/SQL-Project-LHL/Data/Raw Data/sales_report.csv'
	DELIMITER ','
	CSV HEADER;

-- Validate data entry

SELECT * 
FROM sales_report