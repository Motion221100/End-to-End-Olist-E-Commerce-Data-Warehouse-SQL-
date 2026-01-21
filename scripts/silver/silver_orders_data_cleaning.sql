-- Check for redundant dates.
UPDATE silver.ord_orders
SET
    order_purchase_timestamp = CASE
        WHEN 0 IN (YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), DAY(order_purchase_timestamp))
        THEN NULL ELSE order_purchase_timestamp END,
    order_approved_at = CASE
        WHEN 0 IN (YEAR(order_approved_at), MONTH(order_approved_at), DAY(order_approved_at))
        THEN NULL ELSE order_approved_at END,
    order_delivered_carrier_date = CASE
        WHEN 0 IN (YEAR(order_delivered_carrier_date), MONTH(order_delivered_carrier_date), DAY(order_delivered_carrier_date))
        THEN NULL ELSE order_delivered_carrier_date END,
    order_delivered_customer_date = CASE
        WHEN 0 IN (YEAR(order_delivered_customer_date), MONTH(order_delivered_customer_date), DAY(order_delivered_customer_date))
        THEN NULL ELSE order_delivered_customer_date END,
    order_estimated_delivery_date = CASE
        WHEN 0 IN (YEAR(order_estimated_delivery_date), MONTH(order_estimated_delivery_date), DAY(order_estimated_delivery_date))
        THEN NULL ELSE order_estimated_delivery_date END
WHERE
    0 IN (
        YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), DAY(order_purchase_timestamp),
        YEAR(order_approved_at), MONTH(order_approved_at), DAY(order_approved_at),
        YEAR(order_delivered_carrier_date), MONTH(order_delivered_carrier_date), DAY(order_delivered_carrier_date),
        YEAR(order_delivered_customer_date), MONTH(order_delivered_customer_date), DAY(order_delivered_customer_date),
        YEAR(order_estimated_delivery_date), MONTH(order_estimated_delivery_date), DAY(order_estimated_delivery_date)
    );

-- order approved at must be greater than order purchased timestamp.
SELECT * 
FROM silver.ord_orders
WHERE DATEDIFF(order_approved_at, order_purchase_timestamp) < 0 OR HOUR(TIMEDIFF(order_approved_at, order_purchase_timestamp)) < 0 OR
    MINUTE(TIMEDIFF(order_approved_at, order_purchase_timestamp)) < 0 OR SECOND(TIMEDIFF(order_approved_at, order_purchase_timestamp)) < 0;