# Olise-E-Commerce-Data Warehouse Project

End-to-end SQL data warehouse project implementing the medallion architecture(ETL pipeline) data pipeline for e-commerce analytics using MySQL. The pipeline processes raw Brazilian e-commerce data through bronze, silver, and gold layers to create a comprehensive analytical data warehouse.

# Architecture
### Bronze Layer
- Purpose: Table creation and data ingestions.
- Tables: 9 tables created. 
- Features: Schema validation and creation, raw data preservation.

### Silver Layer
- Purpose: Data Cleansing, Standardization and Validation
- Process:  Checking for duplicate records,
            Null value handling,
            Geographic data normalization,
            Data type standardization.
  
### Gold Layer
- Purpose: Business ready analytic, KPIs and Key metrics.
- Deliverables: Facts and Dimension scripts for analytics and KPIs.

## Project Structure
```text
End-to-End-Olist-E-Commerce-Data-Warehouse-SQL/
├── README.md
├── Scripts/
│   ├── Bronze/
│   │   ├── bronze_create_tables.sql
│   │   └── bulk_ingestion.sql
│   ├── Silver/
│   │   ├── pk_fk_assignments.sql
│   │   ├── silver_create_tables.sql
│   │   ├── silver_customers_data_cleaning.sql
│   │   ├── silver_geolocation_data_cleaning.sql
│   │   ├── silver_order_items_data_cleaning.sql
│   │   ├── silver_order_payments_data_cleaning.sql
│   │   ├── silver_order_reviews_data_cleaning.sql
│   │   ├── silver_orders_data_cleaning.sql
│   │   ├── silver_products_data_cleaning.sql
│   │   └── silver_sellers_data_cleaning.sql
│   └── Gold/
│       ├── dim_customers.sql
│       ├── dim_date.sql
│       ├── dim_payments.sql
│       ├── dim_products.sql
│       ├── dim_sellers.sql
│       ├── fact_order_items.sql
│       ├── fact_orders.sql
│       ├── fact_payments.sql
│       └── fact_reviews.sql
└── Deliverables/
    ├── dataset_uml.jpeg
    ├── dataset_uml.pdf
    ├── dataset_uml.drawio
    └── integrate_uml.pdf	
```
## Database Schema
### Bronze Layer (Raw Tables)
- `customers`
- `sellers`
- `products`
- `orders`
- `order_items`
- `order_payments`
- `order_reviews`

### Silver Layer (Cleansed / Standardized)
- `silver_customers`  
- `silver_sellers`  
- `silver_products`  
- `silver_orders`  
- `silver_order_items`  
- `silver_order_payments`  
- `silver_order_reviews`  
- `silver_geolocation`  

> Includes PK & FK assignments, data cleaning, and standardization.

### Gold Layer (Fact & Dimension Tables – Star Schema)

#### Dimension Tables
- `dim_customers`  
- `dim_sellers`  
- `dim_products`  
- `dim_payments`  
- `dim_date`  

#### Fact Tables
- `fact_orders`  
- `fact_order_items`  
- `fact_payments`  
- `fact_reviews`

## Prerequisites
- `MySQL 8.0+`
- `6GB RAM+ for faster processing`
- `Olist E-Commerce Datasets`

## How to use
- Move CSV files from the dataset to a secure folder(C:\ProgramData\MySQL\MySQL Server 8.0\)
- Turn local infile ON in MysQL Workbench to allow LOAD DATA LOCAL INFILE to work for bulk ingestion()
```sql
SHOW GLOBAL VARIABLES LIKE 'local_infile';  

--if variable is off, use the following code to turn it on.
SET GLOBAL VARIABLE local_infile = 1;
```
- Open the scripts in order(bronze -> silver -> gold).
- Run the scripts.

## Sample Queries
### 1. Customer Dimensions and KPIs
```sql

CREATE TABLE gold.dim_customer AS
SELECT
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_price_spent,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_paid,
    COALESCE(SUM(op.payment_value),0) AS lifetime_net_spent,
    AVG(oi.price) AS avg_order_value,
    COUNT(DISTINCT oi.product_id) AS unique_products_purchased,
    COUNT(DISTINCT oi.seller_id) AS unique_sellers_purchased_from,
    COALESCE(AVG(op.payment_installments),0) AS avg_payment_installments,
    CASE WHEN COUNT(DISTINCT oo.order_id) > 1 THEN 'Repeat' ELSE 'One-time' END AS customer_type
FROM silver.cust_customers cc
LEFT JOIN silver.ord_orders oo
    ON cc.customer_id = oo.customer_id
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state;

CREATE VIEW gold.dim_customer_view AS
SELECT
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_price_spent,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_paid,
    COALESCE(SUM(op.payment_value),0) AS lifetime_net_spent,
    AVG(oi.price) AS avg_order_value,
    COUNT(DISTINCT oi.product_id) AS unique_products_purchased,
    COUNT(DISTINCT oi.seller_id) AS unique_sellers_purchased_from,
    COALESCE(AVG(op.payment_installments),0) AS avg_payment_installments,
    CASE WHEN COUNT(DISTINCT oo.order_id) > 1 THEN 'Repeat' ELSE 'One-time' END AS customer_type
FROM silver.cust_customers cc
LEFT JOIN silver.ord_orders oo
    ON cc.customer_id = oo.customer_id
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state;

```
### 2. Standardizing city names function and Updating city names
```sql
-- standardize the geo_city column
DELIMITER //
CREATE FUNCTION normalize_city_name(city VARCHAR(255))
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));
    SET city = REPLACE(city, '...', '');
    SET city = REPLACE(city, '*', '');
    SET city = REPLACE(city, '´t', 't');
    SET city = REPLACE(city, '4º', '');
    SET city = REPLACE(city, '4o.', '');
    -- Clean up multiple spaces (very rare but safe)
    WHILE LOCATE('  ', city) > 0 DO
        SET city = REPLACE(city, '  ', ' ');
    END WHILE;
    RETURN city;
END //
DELIMITER ;

UPDATE silver.geo_geolocation
SET geo_city = TRIM(normalize_city_name(geo_city));

SELECT DISTINCT geo_city
FROM silver.geo_geolocation
WHERE geo_city REGEXP '[A-ZÀÁÂÃÄÇÉÊÈËÍÎÌÏÕÓÔÒÖÚÛÙÜÑ]'
   OR geo_city != LOWER(geo_city)
   OR geo_city REGEXP '[ãáâàäéêèëíîìïõóôòöúûùüçñ]';
```
### 3. Primary and Foreign key assignments(Foreign key constraints)
```sql

-- assign customer_id as primary key
ALTER TABLE silver.cust_customers
ADD PRIMARY KEY (customer_id) ;

-- assign seller_id as primary key
ALTER TABLE silver.selr_sellers
ADD PRIMARY KEY (seller_id);

-- assign order_id as primary key and customer_id as foreign key.
ALTER TABLE silver.ord_orders
ADD PRIMARY KEY (order_id),
ADD CONSTRAINT fk_cust_id_1
	FOREIGN KEY (customer_id)
    REFERENCES silver.cust_customers (customer_id);
    
-- assign product_id as primary key
ALTER TABLE silver.prod_products
ADD PRIMARY KEY (product_id);

-- assign both seller_id and product_id as foreign keys.
ALTER TABLE silver.ord_order_items
ADD CONSTRAINT fk_seller_id_1
	FOREIGN KEY (seller_id)
    REFERENCES silver.selr_sellers (seller_id),
ADD CONSTRAINT fk_product_id_1
	FOREIGN KEY (product_id)
    REFERENCES silver.prod_products (product_id),
ADD CONSTRAINT fk_order_id_1
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
    
-- assign order_id as foreign key
ALTER TABLE silver.ord_order_reviews
ADD CONSTRAINT fk_order_id_2
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
    
-- assign order_id as foreign key.
ALTER TABLE silver.ord_order_payments
ADD CONSTRAINT fk_order_id_3
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
```
## Contributing 
- Fork the repository
- Create a feature branch
- Commit your changes
- Push to the branch
- Create a Pull Request

## Acknowledgements
- Kaggle for providing the e-commerce dataset
- Inspired by modern data engineering practices
- Built for educational and analytical purposes
