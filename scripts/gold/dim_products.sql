CREATE TABLE gold.dim_product AS
SELECT
    p.product_id,
    p.product_category_name,
    pnt.product_category_name_english AS product_name_translation,
    AVG(oi.price) AS avg_price_sold
FROM silver.prod_products p
LEFT JOIN silver.prod_category_name_translation pnt
    ON p.product_category_name = pnt.product_category_name
LEFT JOIN silver.ord_order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_category_name,
    pnt.product_category_name_english;

CREATE VIEW gold.dim_product_view AS
SELECT
    p.product_id,
    p.product_category_name,
    pnt.product_category_name_english AS product_name_translation,
    AVG(oi.price) AS avg_price_sold
FROM silver.prod_products p
LEFT JOIN silver.prod_category_name_translation pnt
    ON p.product_category_name = pnt.product_category_name
LEFT JOIN silver.ord_order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_category_name,
    pnt.product_category_name_english;