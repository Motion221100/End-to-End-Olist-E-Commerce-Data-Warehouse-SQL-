CREATE TABLE gold.dim_date AS
SELECT DISTINCT
    DATE(order_purchase_timestamp) AS date,
    DAY(order_purchase_timestamp) AS day,
    MONTH(order_purchase_timestamp) AS month,
    QUARTER(order_purchase_timestamp) AS quarter,
    YEAR(order_purchase_timestamp) AS year,
    DAYOFWEEK(order_purchase_timestamp) AS day_of_week
FROM silver.ord_orders;

CREATE VIEW gold.dim_date_view AS
SELECT DISTINCT
    DATE(order_purchase_timestamp) AS date,
    DAY(order_purchase_timestamp) AS day,
    MONTH(order_purchase_timestamp) AS month,
    QUARTER(order_purchase_timestamp) AS quarter,
    YEAR(order_purchase_timestamp) AS year,
    DAYOFWEEK(order_purchase_timestamp) AS day_of_week
FROM silver.ord_orders;