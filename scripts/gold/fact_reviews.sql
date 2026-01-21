CREATE TABLE gold.fact_reviews AS
SELECT
    orr.order_id,
    orr.review_score,
    orr.review_comment_message,
    orr.review_creation_date,
    orr.review_answer_timestamp,
    DATE(oo.order_purchase_timestamp) AS order_date
FROM silver.ord_order_reviews orr
LEFT JOIN silver.ord_orders oo
    ON orr.order_id = oo.order_id;

CREATE VIEW gold.fact_reviews_view AS
SELECT
    orr.order_id,
    orr.review_score,
    orr.review_comment_message,
    orr.review_creation_date,
    orr.review_answer_timestamp,
    DATE(oo.order_purchase_timestamp) AS order_date
FROM silver.ord_order_reviews orr
LEFT JOIN silver.ord_orders oo
    ON orr.order_id = oo.order_id;