
DROP OR ALTER PROCEDURE IF EXISTS silver.silver_create_tables()
-- Create procedure for silver layer tables.
DELIMITER $$
	CREATE PROCEDURE silver.silver_create_tables ()
		BEGIN 
			SET SESSION sql_mode = '';
			CREATE TABLE silver.geo_geolocation AS SELECT * FROM bronze.geo_geolocation;
			CREATE TABLE silver.cust_customers AS SELECT * FROM bronze.cust_customers;
			CREATE TABLE silver.ord_orders AS SELECT * FROM bronze.ord_orders;
			CREATE TABLE silver.selr_sellers AS SELECT * FROM bronze.selr_sellers;
			CREATE TABLE silver.ord_order_items AS SELECT * FROM bronze.ord_order_items;
			CREATE TABLE silver.ord_order_payments AS SELECT * FROM bronze.ord_order_payments;
			CREATE TABLE silver.ord_order_reviews AS SELECT * FROM bronze.ord_order_reviews;
			CREATE TABLE silver.prod_products AS SELECT * FROM bronze.prod_products;
			CREATE TABLE silver.prod_category_name_translation AS SELECT * FROM bronze.prod_category_name_translation;
        END $$
DELIMITER ;

-- Execute the procedure.
CALL silver.silver_create_tables();