CREATE TABLE gold.dim_seller AS
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COALESCE(SUM(oi.price),0) AS lifetime_revenue,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_revenue,
    COUNT(DISTINCT oi.product_id) AS unique_products_sold,
    COUNT(DISTINCT oo.customer_id) AS unique_customers,
    AVG(oi.price) AS avg_product_price,
    COALESCE(AVG(oi.freight_value),0) AS avg_freight_value,
    CASE 
        WHEN COUNT(DISTINCT oi.order_id) > 50 THEN 'High Volume Seller'
        WHEN COUNT(DISTINCT oi.order_id) BETWEEN 10 AND 50 THEN 'Medium Volume Seller'
        ELSE 'Low Volume Seller'
    END AS seller_volume_category,
    COALESCE(SUM(oi.price)/NULLIF(COUNT(DISTINCT oi.order_id),0),0) AS revenue_per_order
FROM silver.selr_sellers s
LEFT JOIN silver.ord_order_items oi
    ON s.seller_id = oi.seller_id
LEFT JOIN silver.ord_orders oo
    ON oi.order_id = oo.order_id
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
    COALESCE(SUM(oi.price),0) AS lifetime_revenue,
    COALESCE(SUM(oi.freight_value),0) AS lifetime_freight_revenue,
    COUNT(DISTINCT oi.product_id) AS unique_products_sold,
    COUNT(DISTINCT oo.customer_id) AS unique_customers,
    AVG(oi.price) AS avg_product_price,
    COALESCE(AVG(oi.freight_value),0) AS avg_freight_value,
    CASE 
        WHEN COUNT(DISTINCT oi.order_id) > 50 THEN 'High Volume Seller'
        WHEN COUNT(DISTINCT oi.order_id) BETWEEN 10 AND 50 THEN 'Medium Volume Seller'
        ELSE 'Low Volume Seller'
    END AS seller_volume_category,
    COALESCE(SUM(oi.price)/NULLIF(COUNT(DISTINCT oi.order_id),0),0) AS revenue_per_order
FROM silver.selr_sellers s
LEFT JOIN silver.ord_order_items oi
    ON s.seller_id = oi.seller_id
LEFT JOIN silver.ord_orders oo
    ON oi.order_id = oo.order_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state;
