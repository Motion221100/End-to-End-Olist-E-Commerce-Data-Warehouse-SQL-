-- cust_customers table cleaning and standardizing
-- CUSTOMER DATASET.
-- Check for duplicates records.
SELECT *
FROM (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY c.customer_zipcode_prefix, customer_id, c.customer_city, c.customer_state, 
    c.customer_unique_id) AS dupl_number
    FROM silver.cust_customers c
) cc
WHERE dupl_number > 1;	-- no duplicate records.


-- Check for duplicate customer ids and NULL or empty spaces in customer id column.
SELECT *
FROM (
	SELECT c.customer_id, ROW_NUMBER() OVER(PARTITION BY c.customer_id) AS dupl_number
    FROM silver.cust_customers c
) cc
WHERE dupl_number > 1 OR (cc.customer_id IS NULL OR cc.customer_id = "") ;	-- no duplicate customer ids, no nulls and no blanks.

-- Search for nulls
SELECT *
FROM silver.cust_customers
WHERE
	customer_id IS NULL
   OR TRIM(customer_id) = ''

   OR customer_unique_id IS NULL
   OR TRIM(customer_unique_id) = ''

   OR customer_zipcode_prefix IS NULL
   OR TRIM(customer_zipcode_prefix) = ''

   OR customer_city IS NULL
   OR TRIM(customer_city) = ''

   OR customer_state IS NULL
   OR TRIM(customer_state) = '';

-- No duplicates found in customers table.
-- customer unique id can have duplicates to represent the same person.
-- No nulls found in the customers table.

-- GEO_GEOLOCATION TABLE.
-- search for duplicate geo_zipcode_prefix
SELECT *
FROM (
	SELECT geo_zipcode_prefix, ROW_NUMBER() OVER(PARTITION BY geo_zipcode_prefix) dupl_number
    FROM silver.geo_geolocation
) dupl_zipcode
WHERE dupl_number > 1;
-- duplicate geozipcode prefixes found for every, but each represent a unique coordinate. longitude and latitude columns are redundant.

-- search for duplicate longitude and latitude.
SELECT *
FROM (
	SELECT geo_latitude, ROW_NUMBER() OVER(PARTITION BY geo_latitude) AS duplicates
    FROM silver.geo_geolocation
    GROUP BY geo_latitude
) dupl_geo_lat
WHERE duplicates > 1;
-- no duplicate latitudes

-- search for duplicate longitudes
SELECT *
FROM (
	SELECT geo_longitude, ROW_NUMBER() OVER(PARTITION BY geo_longitude) AS duplicates
    FROM silver.geo_geolocation
    GROUP BY geo_longitude
) dupl_geo_lat
WHERE duplicates > 1;

-- standardize the geo_city column(genAI generated code)
DELIMITER //
CREATE FUNCTION normalize_city_name(city VARCHAR(255))
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));
    
    -- Remove/replace common Portuguese/Brazilian diacritics
    SET city = REPLACE(city, 'ã', 'a');
    SET city = REPLACE(city, 'á', 'a');
    SET city = REPLACE(city, 'â', 'a');
    SET city = REPLACE(city, 'à', 'a');
    SET city = REPLACE(city, 'ä', 'a');
    SET city = REPLACE(city, 'é', 'e');
    SET city = REPLACE(city, 'ê', 'e');
    SET city = REPLACE(city, 'è', 'e');
    SET city = REPLACE(city, 'ë', 'e');
    SET city = REPLACE(city, 'í', 'i');
    SET city = REPLACE(city, 'î', 'i');
    SET city = REPLACE(city, 'ì', 'i');
    SET city = REPLACE(city, 'ï', 'i');
    SET city = REPLACE(city, 'õ', 'o');
    SET city = REPLACE(city, 'ó', 'o');
    SET city = REPLACE(city, 'ô', 'o');
    SET city = REPLACE(city, 'ò', 'o');
    SET city = REPLACE(city, 'ö', 'o');
    SET city = REPLACE(city, 'ú', 'u');
    SET city = REPLACE(city, 'û', 'u');
    SET city = REPLACE(city, 'ù', 'u');
    SET city = REPLACE(city, 'ü', 'u');
    SET city = REPLACE(city, 'ç', 'c');
    SET city = REPLACE(city, 'ñ', 'n');
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
   
SELECT 
    geo_city
FROM silver.geo_geolocation
GROUP BY geo_city
ORDER BY geo_city asc;

-- ORDER ITEMS DATASET
-- check correct datetime/timestamp format.
WITH check_timestamp_format AS (
	SELECT shipping_lim_date,
       CASE
           WHEN STR_TO_DATE(shipping_lim_date, '%Y-%m-%d %H:%i:%s') IS NOT NULL THEN 'Correct date format'
           ELSE 'Incorrect date format'
       END AS determine_date
FROM silver.ord_order_items
)

SELECT *
FROM check_timestamp_format
WHERE determine_date != 'Correct date format';
-- All dates in shipping_lim_date column have correct datetime formats

-- check if price + freight price = payment_value(from ord_order_payments)
SELECT 
    oi.order_id,
    SUM(oi.price + oi.freight_value) AS total_order_items,   -- total expected per order
    SUM(op.payment_value) AS total_payment_received          -- total actually paid
FROM silver.ord_order_items oi
LEFT JOIN silver.ord_order_payments op
    ON oi.order_id = op.order_id
GROUP BY oi.order_id
HAVING total_payment_received != total_order_items  ;        -- filter: only orders underpaid

-- Update the incorrect data.
UPDATE silver.ord_order_payments op
JOIN (
    SELECT 
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS total_order_items
    FROM silver.ord_order_items oi
    GROUP BY oi.order_id
) AS totals
ON op.order_id = totals.order_id
SET op.payment_value = totals.total_order_items
WHERE op.payment_value != totals.total_order_items;

-- found numerous records where price + freight != payment value
-- Conclusion, not enough data to conclude sales and discounts.

-- check for payment type errors.
SELECT payment_type
FROM silver.ord_order_payments
GROUP BY payment_type;

-- check for nulls and blanks
SELECT *
FROM silver.ord_order_payments
WHERE
    order_id IS NULL
 OR payment_sequential IS NULL
 OR payment_type IS NULL
 OR TRIM(payment_type) = ''
 OR payment_installments IS NULL
 OR payment_value IS NULL;

-- ORDER REVIEWS DATASET
-- check for null or blank review score(all reviews must have a score)
SELECT review_score
FROM silver.ord_order_reviews
WHERE review_score IS NULL;
-- no nulls found.

-- check correct timestamp formats in review creation data and review answer date.
SELECT *
FROM silver.ord_order_reviews
WHERE DATE(review_creation_date) != DATE_FORMAT(review_creation_date, '%Y-%m-%d') OR 
	TIME(review_creation_date) != TIME_FORMAT(review_creation_date, '%H:%i:%s') OR
    DATE(review_answer_timestamp) != DATE_FORMAT(review_answer_timestamp, '%Y-%m-%d') OR 
	TIME(review_answer_timestamp) != TIME_FORMAT(review_answer_timestamp, '%H:%i:%s');
-- all datetime/timestamps have the correct format.

-- check if review answer date is greater than review creation date.
SELECT *
FROM (
	SELECT *, CASE 
	WHEN datediff(review_answer_timestamp, review_creation_date) >=0 OR
		YEAR(timediff(review_answer_timestamp, review_creation_date)) >=0 OR
        MONTH(timediff(review_answer_timestamp, review_creation_date)) >=0 OR
        DAY(timediff(review_answer_timestamp, review_creation_date)) >=0 THEN 'correct'
        ELSE 'incorrect'
END AS date_interval
FROM silver.ord_order_reviews
) determine_table
WHERE date_interval != 'correct';

-- clean irrelevant dates(0000-00)
UPDATE silver.ord_order_reviews
SET review_creation_date = NULL, review_answer_timestamp = NULL
WHERE 0 IN (MONTH(review_creation_date), DAY(review_creation_date), YEAR(review_creation_date),
	MONTH(review_answer_timestamp), DAY(review_answer_timestamp), YEAR(review_answer_timestamp));
    
-- ORD ORDERS DATASET