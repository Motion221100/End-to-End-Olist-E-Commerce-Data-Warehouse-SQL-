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
 
 -- Update the incorrect data.
 -- continuation of order items dataset cleaning
 --
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