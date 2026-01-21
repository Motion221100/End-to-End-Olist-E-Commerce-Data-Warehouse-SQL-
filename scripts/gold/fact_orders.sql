CREATE TABLE gold.fact_orders AS
SELECT
    oo.order_id,
    oo.customer_id,
    oo.order_status,
    DATE(oo.order_purchase_timestamp) AS order_date,
    SUM(oi.price) AS total_order_price,
    SUM(oi.freight_value) AS total_order_freight,
    SUM(op.payment_value) AS total_order_paid
FROM silver.ord_orders oo
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    oo.order_id,
    oo.customer_id,
    oo.order_status,
    DATE(oo.order_purchase_timestamp);

CREATE VIEW gold.fact_orders_view AS
SELECT
    oo.order_id,
    oo.customer_id,
    oo.order_status,
    DATE(oo.order_purchase_timestamp) AS order_date,
    SUM(oi.price) AS total_order_price,
    SUM(oi.freight_value) AS total_order_freight,
    SUM(op.payment_value) AS total_order_paid
FROM silver.ord_orders oo
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    oo.order_id,
    oo.customer_id,
    oo.order_status,
    DATE(oo.order_purchase_timestamp);