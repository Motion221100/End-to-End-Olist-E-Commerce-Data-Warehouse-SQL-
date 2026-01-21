CREATE TABLE gold.dim_customer AS
SELECT
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_price_spent,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_paid,
    COALESCE(SUM(op.payment_value),0) AS lifetime_net_spent
FROM silver.cust_customers cc
LEFT JOIN silver.ord_orders oo
    ON cc.customer_id = oo.customer_id
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state;

CREATE VIEW gold.dim_customer_view AS
SELECT
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state,
    COUNT(DISTINCT oo.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_price_spent,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_paid,
    COALESCE(SUM(op.payment_value),0) AS lifetime_net_spent
FROM silver.cust_customers cc
LEFT JOIN silver.ord_orders oo
    ON cc.customer_id = oo.customer_id
LEFT JOIN silver.ord_order_items oi
    ON oo.order_id = oi.order_id
LEFT JOIN silver.ord_order_payments op
    ON oo.order_id = op.order_id
GROUP BY
    cc.customer_id,
    cc.customer_unique_id,
    cc.customer_zipcode_prefix,
    cc.customer_city,
    cc.customer_state;