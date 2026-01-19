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
