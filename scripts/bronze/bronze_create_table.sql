CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

DROP PROCEDURE IF EXISTS bronze.create_tables;

DELIMITER $$

CREATE PROCEDURE bronze.create_tables()
BEGIN
    CREATE TABLE IF NOT EXISTS bronze.geo_geolocation (
        geo_zipcode_prefix      INT,
        geo_latitude            DECIMAL(15, 8),
        geo_longitude           DECIMAL(15, 8),
        geo_city                VARCHAR(100),
        geo_state               VARCHAR(2),
        ingestion_timestamp     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        INDEX idx_zipcode (geo_zipcode_prefix),
        INDEX idx_city_state (geo_city, geo_state)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.cust_customers (
        customer_id             VARCHAR(100),
        customer_unique_id      VARCHAR(100),
        customer_zipcode_prefix INT,
        customer_city           VARCHAR(100),
        customer_state          VARCHAR(2),
        ingestion_timestamp     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        INDEX idx_customer_id (customer_id),
        INDEX idx_unique_id (customer_unique_id),
        INDEX idx_customer_zip (customer_zipcode_prefix)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.ord_orders (
        order_id                        VARCHAR(100),
        customer_id                     VARCHAR(100),
        order_status                    VARCHAR(100),
        order_purchase_timestamp        TIMESTAMP,
        order_approved_at               TIMESTAMP,
        order_delivered_carrier_date    TIMESTAMP,
        order_delivered_customer_date   TIMESTAMP,
        order_estimated_delivery_date   TIMESTAMP,
        ingestion_timestamp             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        PRIMARY KEY (order_id),
        INDEX idx_customer_id (customer_id),
        INDEX idx_order_status (order_status),
        INDEX idx_purchase_date (order_purchase_timestamp)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.selr_sellers (
        seller_id               VARCHAR(100),
        seller_zipcode_prefix   VARCHAR(100),
        seller_city             VARCHAR(100),
        seller_state            VARCHAR(2),
        ingestion_timestamp     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        PRIMARY KEY (seller_id),
        INDEX idx_seller_zip (seller_zipcode_prefix)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.ord_order_items (
        order_id                VARCHAR(100),
        order_item_id           INT,
        product_id              VARCHAR(100),
        seller_id               VARCHAR(100),
        shipping_limit_date     TIMESTAMP,
        price                   DECIMAL(10, 2),
        freight_value           DECIMAL(5, 2),
        ingestion_timestamp     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        INDEX idx_order_id (order_id),
        INDEX idx_product_id (product_id),
        INDEX idx_seller_id (seller_id)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.ord_order_payments (
        order_id                VARCHAR(100),
        payment_sequential      INT,
        payment_type            VARCHAR(25),
        payment_installments    INT,
        payment_value           DECIMAL(10, 2),
        ingestion_timestamp     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        INDEX idx_order_id (order_id),
        INDEX idx_payment_type (payment_type)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.ord_order_reviews (
        review_id                   VARCHAR(100),
        order_id                    VARCHAR(100),
        review_score                INT,
        review_comment_title        VARCHAR(100),
        review_comment_message      VARCHAR(100),
        review_creation_date        TIMESTAMP,
        review_answer_timestamp     TIMESTAMP,
        ingestion_timestamp         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        PRIMARY KEY (review_id),
        INDEX idx_order_id (order_id),
        INDEX idx_review_score (review_score)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.prod_products (
        product_id                   VARCHAR(100),
        product_category_name        VARCHAR(100),
        product_name_length          INT,
        product_description_length   INT,
        product_photos_qty           INT,
        product_weight_g             INT,
        product_length_cm            INT,
        product_height_cm            INT,
        product_width_cm             INT,
        ingestion_timestamp          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        PRIMARY KEY (product_id),
        INDEX idx_category (product_category_name)
    );
    
    CREATE TABLE IF NOT EXISTS bronze.prod_category_name_translation (
        product_category_name        VARCHAR(100),
        product_category_name_english VARCHAR(100),
        ingestion_timestamp          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        INDEX idx_category_name (product_category_name),
        INDEX idx_category_english (product_category_name_english)
    );
    
END $$

DELIMITER ;

CALL bronze.create_tables;