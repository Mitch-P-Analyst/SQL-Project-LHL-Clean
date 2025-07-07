What are your risk areas? Identify and describe them.

## Primary Keys
With no primary keys across all tables and CSV files, issues are present for duplication and redunant data. 

    ``` sql
        -- Retrieve distinct visitorid for relavent of unique visitors & customers
        SELECT 
            COUNT(DISTINCT fullvistorid),
            COUNT(fullvistorid)
        FROM all_sessions

        -- Same issue arises in analytics table
        SELECT
            COUNT(DISCINT fullvisitorid),
            COUNT(fullvisitorid)
        FROM analytics

    ```

## Inconsistent Product Name & Category Formatting
Product names from 'All_Sessions' table are irregularly formatted and could prevent accurate grouping.
Addressed by identifying unique SKU code and extracting data from 'Products' table
   
    ``` sql
        SELECT
            LOWER(TRIM(p.name)) AS product_name,
        FROM all_sessions AS als
            JOIN products AS p
                ON p.sku = als.productsku
    ```

Product Categories are irregulary formatted in 'All_Sessions' table from an Ecommerce populated source, and no other product_categories source is available in provided datebase.
Therefore, a REGEX Arrayformula was utilised to extract cateogrical names for consitent formatting

    ``` sql
        SELECT 
            DISTINCT(LOWER(TRIM(p.name))) AS product_name,
            REGEXP_MATCH(LOWER(TRIM(als.v2productcategory)),'apparel|electronics|accessories|bags|office|kids|lifestyle|drinkware') AS product_category
        FROM all_sessions AS als
            JOIN products AS p
                ON als.productsku = p.sku
    ```

QA Process:
Describe your QA process and include the SQL queries used to execute it.
