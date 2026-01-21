-- update 0 values in the products database.
UPDATE silver.prod_products
SET
    product_name_length = NULLIF(product_name_length, 0),
    product_photos_qty = NULLIF(product_photos_qty, 0),
    product_description_length = NULLIF(product_description_length, 0),
    product_weight_g = NULLIF(product_weight_g, 0),
    product_length_cm = NULLIF(product_length_cm, 0),
    product_height_cm = NULLIF(product_height_cm, 0),
    product_width_cm = NULLIF(product_width_cm, 0)
WHERE
    product_name_length = 0
    OR product_photos_qty = 0
    OR product_description_length = 0
    OR product_weight_g = 0
    OR product_length_cm = 0
    OR product_height_cm = 0
    OR product_width_cm = 0;