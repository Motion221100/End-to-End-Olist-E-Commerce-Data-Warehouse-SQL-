-- Create procedure for silver layer ingestion.

DROP OR ALTER PROCEDURE IF EXISTS silver.silver_create_tables()
DELIMITER $$
	CREATE PROCEDURE silver.silver_create_tables ()
		BEGIN 
			SET SESSION sql_mode = '';
			CREATE TABLE silver.geo_geolocation AS SELECT * FROM bronze.geo_geolocation;
				ALTER TABLE silver.geo_geolocation DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.cust_customers AS SELECT * FROM bronze.cust_customers;
				ALTER TABLE silver.cust_customers DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.ord_orders AS SELECT * FROM bronze.ord_orders;
				ALTER TABLE silver.ord_orders DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.selr_sellers AS SELECT * FROM bronze.selr_sellers;
				ALTER TABLE silver.selr_sellers DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.ord_order_items AS SELECT * FROM bronze.ord_order_items;
				ALTER TABLE silver.ord_order_items  DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.ord_order_payments AS SELECT * FROM bronze.ord_order_payments;
				ALTER TABLE silver.ord_order_payments DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.ord_order_reviews AS SELECT * FROM bronze.ord_order_reviews;
				ALTER TABLE silver.ord_order_reviews DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.prod_products AS SELECT * FROM bronze.prod_products;
				ALTER TABLE silver.prod_products DROP COLUMN ingestion_timestamp;
                
			CREATE TABLE silver.prod_category_name_translation AS SELECT * FROM bronze.prod_category_name_translation;
				ALTER TABLE silver.prod_category_name_translation DROP COLUMN ingestion_timestamp;
                
        END $$
DELIMITER ;

-- Execute the procedure.
CALL silver.silver_create_tables();