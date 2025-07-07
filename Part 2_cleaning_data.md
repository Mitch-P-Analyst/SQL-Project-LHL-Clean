# Part 2: Data Cleaning

Through observations of the Ecommerce LHL Dataset, what data validation issues have you noticed and the resulting methods of data cleaning used. 


## Data Validation Issues

What issues will you address by cleaning the data?

### Cleaning Summary Table

| Column            | Issue Identified                              | Cleaning Action 
|-------------------|-----------------------------------------------|------------------------------------------------|
| `city`            | Placeholder values '(not set)'                | Replaced with NULL using `CASE` statement      |
| `timesite`        | Seconds not user-friendly                     | Converted to minutes with type cast + division |
| `country`         | Incorrect naming (e.g. 'New York / Canada')   | Mapped to correct country using `CASE` logic   |
| `product_category`| Inconsistent formatting                       | Extract identifiers using REGEX_MATCH.         |
| `product_name`    | Inconsistent formatting                       | Referenced accurate name via SKU using `JOIN`  |
 
- City Column
	- Removing invalid Text entries
		- producing NULL values for accurate data responses
			``` sql
				CASE
					WHEN city = 'not available in demo dataset' OR city = '(not set)'
					THEN NULL
					ELSE city
				END AS city_cleaned,
			```

		- Alternatively, removing NULL values where desired
			``` sql
				CASE
					WHEN city = 'not available in demo dataset' OR city = '(not set)'
					THEN NULL
					ELSE city
				END AS city_cleaned,
				...
				WHERE city IS NOT NULL
			```

- Timeonsite Column
	- time is not recorded in readable presentation
		- Transform data to minutes
			``` sql
			SELECT
			AVG((timeonsite::REAL)/60)::REAL AS Average_Minutes_On_Site
			FROM all_sessions
			WHERE timeonsite IS NOT NULL
			```

- v2productname Column
	- Irregular formatting
		- JOIN 'All_Sessions' table with 'Products' table via relevant SKUs for correct name formatting
			``` sql
				...
				LOWER(TRIM(p.name)) AS product_name,
				...
				FROM all_sessions AS als
					JOIN products AS p
						ON p.sku = als.productsku
				...
				```
- Product Information
	- columns 'Productquantity' , 'productprice' , 'productrevenue' do not accurately correlate data regarding expected sales
		- Extract information from 'Analytics' table for 'unit_price' and 'units_sold'
			``` sql
				...
				a.unit_price/1000000 AS product_price,
				SUM(a.units_sold) AS units_sold
				FROM all_sessions AS als
					JOIN analytics AS a
					ON als.fullvistorid = a.fullvisitorid 
				...
			```
- Date Column
	- VARCHAR formatt
		``` sql 
			SELECT 
			DATE::DATE
			FROM analytics
		```


