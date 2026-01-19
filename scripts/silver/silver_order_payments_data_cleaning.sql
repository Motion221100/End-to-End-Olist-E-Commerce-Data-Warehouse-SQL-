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