-- Check for redundant dates.
UPDATE silver.ord_order_reviews
SET
    order_purch_timestamp = CASE
        WHEN 0 IN (YEAR(order_purch_timestamp), MONTH(order_purch_timestamp), DAY(order_purch_timestamp))
        THEN NULL ELSE order_purch_timestamp END,

    order_appr_at = CASE
        WHEN 0 IN (YEAR(order_appr_at), MONTH(order_appr_at), DAY(order_appr_at))
        THEN NULL ELSE order_appr_at END,

    del_carrier_date = CASE
        WHEN 0 IN (YEAR(del_carrier_date), MONTH(del_carrier_date), DAY(del_carrier_date))
        THEN NULL ELSE del_carrier_date END,

    del_customer_date = CASE
        WHEN 0 IN (YEAR(del_customer_date), MONTH(del_customer_date), DAY(del_customer_date))
        THEN NULL ELSE del_customer_date END,

    estim_delivery_date = CASE
        WHEN 0 IN (YEAR(estim_delivery_date), MONTH(estim_delivery_date), DAY(estim_delivery_date))
        THEN NULL ELSE estim_delivery_date END
WHERE
    0 IN (
        YEAR(order_purch_timestamp), MONTH(order_purch_timestamp), DAY(order_purch_timestamp),
        YEAR(order_appr_at),        MONTH(order_appr_at),        DAY(order_appr_at),
        YEAR(del_carrier_date),     MONTH(del_carrier_date),     DAY(del_carrier_date),
        YEAR(del_customer_date),    MONTH(del_customer_date),    DAY(del_customer_date),
        YEAR(estim_delivery_date),  MONTH(estim_delivery_date),  DAY(estim_delivery_date)
    );

-- order approved at must be greater than order purchased timestamp.
SELECT * 
FROM silver.ord_orders
WHERE DATEDIFF(order_appr_at, order_purch_timestamp) < 0 OR HOUR(TIMEDIFF(order_appr_at, order_purch_timestamp)) < 0 OR
	MINUTE(TIMEDIFF(order_appr_at, order_purch_timestamp)) < 0 OR SECOND(TIMEDIFF(order_appr_at, order_purch_timestamp)) < 0;
-- correct timestamps.

-- update 0 values in the products database.
UPDATE silver.prod_products
SET
    prod_name_length = NULLIF(prod_name_length, 0),
    prod__photos_qty = NULLIF(prod__photos_qty, 0),
    prod_description_length = NULLIF(prod_description_length, 0),
    prod_weight_g = NULLIF(prod_weight_g, 0),
    prod_length_cm = NULLIF(prod_length_cm, 0),
    prod_height_cm = NULLIF(prod_height_cm, 0),
    prod_width_cm = NULLIF(prod_width_cm, 0)
WHERE
    prod_name_length = 0
 OR prod__photos_qty = 0
 OR prod_description_length = 0
 OR prod_weight_g = 0
 OR prod_length_cm = 0
 OR prod_height_cm = 0
 OR prod_width_cm = 0;
 