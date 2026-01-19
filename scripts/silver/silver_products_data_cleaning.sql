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
 