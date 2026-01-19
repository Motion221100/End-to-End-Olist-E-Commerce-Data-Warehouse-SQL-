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