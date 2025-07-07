What are your risk areas? Identify and describe them.

## Risks & Limitations

- Duplicate Risks | 
    - **Issue**
        - No unique identifier across all orders or customers.
    - **Dectected**
        - No [`Primary Keys`](##Primary-Keys), COUNT() vs COUNT(DISTINCT) 
    - **Outcome**
        - ***Order duplicates*** may result in inaccurate totals of revenue or units orders when summarising by city, country
        

- Irregular Formatting |

    - **Issue**
        - Inconsistent ***Product Names***
    - **Detected**
        - [`Inconsistent Product Names`](##Inconsistent-Product-Name-&-Category-Formatting) with irregular formatting and syntax
    - **Outcome**
        - `LOWER(TRIM())` #1 step to address formatting
        - `JOIN` with product_table via productsku / sku for accurate names
        - `DISTINCT` selections and `VIEW` to estalbish unique products for referencing

    - **Issue**
        - Inconsistent ***Product Categories*** | no regularly structured format. 
    - **Detected**
        - [`Inconsistent Product Categories`](##Inconsistent-Product-Name-&-Category-Formatting) Arrayformula performed to extract listed categorical names for formatting
    - **Outcome**
        - ***Analytical Bias*** may be exhibited from manual assignment of product_categories for products with NULL values. 
            Manual assignment of product_category through `CASE` statements based upon anticpated category. 
        - Alternative method to reference product_names of `SIMILAR TO` structure, extracting relevant product_category.


## Primary Keys
With no primary keys across all tables and CSV files, issues are present for duplication and redunant data. 

    ```sql

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
   
    ```sql

        SELECT
            LOWER(TRIM(p.name)) AS product_name,
        FROM all_sessions AS als
            JOIN products AS p
                ON p.sku = als.productsku
    ```

Product Categories are irregulary formatted in 'All_Sessions' table from an Ecommerce populated source, and no other product_categories source is available in provided datebase.
Therefore, a REGEX Arrayformula was utilised to extract cateogrical names for consitent formatting

    ```sql

        SELECT 
            DISTINCT(LOWER(TRIM(p.name))) AS product_name,
            REGEXP_MATCH(LOWER(TRIM(als.v2productcategory)),'apparel|electronics|accessories|bags|office|kids|lifestyle|drinkware') AS product_category
        FROM all_sessions AS als
            JOIN products AS p
                ON als.productsku = p.sku
    ```

    ```sql

        ...
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
        ...
    ```
