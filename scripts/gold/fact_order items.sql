CREATE TABLE gold.fact_order_items AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pp.product_category_name,
    oi.shipping_limit_date,
    oi.price + oi.freight_value AS total_item_value,
    oi.price / NULLIF((oi.price + oi.freight_value), 0) * 100 AS price_percentage,
    oi.freight_value / NULLIF((oi.price + oi.freight_value), 0) * 100 AS freight_percentage,
    CASE 
        WHEN oi.price > 1000 THEN 'Premium Item'
        WHEN oi.price BETWEEN 100 AND 1000 THEN 'Mid-range Item'
        ELSE 'Budget Item'
    END AS price_category,
    CASE 
        WHEN oi.freight_value > 50 THEN 'High Freight'
        WHEN oi.freight_value BETWEEN 10 AND 50 THEN 'Medium Freight'
        ELSE 'Low Freight'
    END AS freight_category,
    DATEDIFF(oi.shipping_limit_date, oo.order_purchase_timestamp) AS days_to_ship_limit
FROM silver.ord_order_items oi
LEFT JOIN silver.prod_products pp
    ON oi.product_id = pp.product_id
LEFT JOIN silver.ord_orders oo
    ON oi.order_id = oo.order_id;

CREATE VIEW gold.fact_order_items_view AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pp.product_category_name,
    oi.shipping_limit_date,
    oi.price + oi.freight_value AS total_item_value,
    oi.price / NULLIF((oi.price + oi.freight_value), 0) * 100 AS price_percentage,
    oi.freight_value / NULLIF((oi.price + oi.freight_value), 0) * 100 AS freight_percentage,
    CASE 
        WHEN oi.price > 1000 THEN 'Premium Item'
        WHEN oi.price BETWEEN 100 AND 1000 THEN 'Mid-range Item'
        ELSE 'Budget Item'
    END AS price_category,
    CASE 
        WHEN oi.freight_value > 50 THEN 'High Freight'
        WHEN oi.freight_value BETWEEN 10 AND 50 THEN 'Medium Freight'
        ELSE 'Low Freight'
    END AS freight_category,
    DATEDIFF(oi.shipping_limit_date, oo.order_purchase_timestamp) AS days_to_ship_limit
FROM silver.ord_order_items oi
LEFT JOIN silver.prod_products pp
    ON oi.product_id = pp.product_id
LEFT JOIN silver.ord_orders oo
    ON oi.order_id = oo.order_id;
