# Final-Project-Transforming-and-Analyzing-Data-with-SQL

## Project/Goals

This project covers the Lighthouse Labs 'Week 2 SQL Project', utilsing raw data from an Ecommerce website. The objective of this project is to understand the stories available within the data to answer applicable questions in Parts 1 - 5 of the project overview. 

The project exhibits use of SQL in extracting, transforming, loading and analysing raw datasets


## Process

### Part 1 - Loading CSV Files into Database
Follow SQL Quries and commented instructions to load Raw-CSV files into PGAdmin

- Part 1- Loading csv Files into Database.sql 

.CSV Files
    Raw Data:
        https://drive.google.com/drive/folders/1efDA4oc9w-bTbAvrESdOJpg9u-gEUBhJ?usp=drive_link
    - all_sessions.csv
    - analytics.csv
    - products.csv
    - sales_by_sku.csv
    - sales_report.csv


### Part 2 - Cleaning Data

Preparation of column datatypes, null values and text-formatting across tables for information necessary to continuation.

### Part 3 - Questions & Answers

Creation of a View 'product_categories', numerous CTE's such as 'visitor_units' and a Temporary Table 'top_city_products' produced viable SQL Query Syntax for analysis on question objectives

#### Objectves
- Cities and countries with the highest transaction revenues
- Average quantity of products ordered
- Patterns or trends in product categories for purchases
- Top-selling products
- Revenue from each city/country

### Part 4 - Starting With Data / Personal Questions

#### Objectives
- Average time spent on site
- Percentage of products have not sold at least 1 unit
- Longest and shortest restocking time

### Part 5 - Quality Assurance

- Inconsistent data formatting
- No viable Primary Keys
- Removing Null Values
- Identifying SKUs

## Results
- 33.77% of products have not sold any units.
- USA is the largest country consumer
- No trends in individual product purchases, however, several isolated purchases in large quantity of indivdual products
- Apparel & Lifestyle product categories are present among isolated large orders
- Large city consumers = Mountain View USA, San Bruno USA, New York USA, Chicago USA, Sunnyvale USA

## Challenges 

Producing data to meet quality assurance for valid analysis. 
    Database is highly disregulated, containing irregular formatting, poorly organised structures and large quantties of null values. Cleaning process was performed as necessary to answer objectives.

Producing viable and trustworthy insights from data of low quality.

## Future Goals
Reformat all data into normalised structure, identifying key attributes of viable information, removing columns of insignifcance and null values.
