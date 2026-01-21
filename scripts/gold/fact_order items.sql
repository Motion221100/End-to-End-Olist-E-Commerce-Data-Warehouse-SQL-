CREATE TABLE gold.fact_order_items AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pp.product_category_name,
    oi.shipping_limit_date
FROM silver.ord_order_items oi
LEFT JOIN silver.prod_products pp
    ON oi.product_id = pp.product_id;

CREATE VIEW gold.fact_order_items_view AS
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pp.product_category_name,
    oi.shipping_limit_date
FROM silver.ord_order_items oi
LEFT JOIN silver.prod_products pp
    ON oi.product_id = pp.product_id;