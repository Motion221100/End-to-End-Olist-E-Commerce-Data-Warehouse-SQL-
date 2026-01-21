CREATE TABLE gold.dim_seller AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_revenue
FROM silver.selr_sellers s
LEFT JOIN silver.ord_order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state;

CREATE VIEW gold.dim_seller_view AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_revenue
FROM silver.selr_sellers s
LEFT JOIN silver.ord_order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state;