# Olise-E-Commerce-Data Warehouse Project

End-to-end SQL data warehouse project implementing the medallion architecture data pipeline for e-commerce analytics using MySQL. The pipeline processes raw Brazilian e-commerce data through bronze, silver, and gold layers to create a comprehensive analytical data warehouse.

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
    └── dataset_uml.drawio
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
