-- assign customer_id as primary key
ALTER TABLE silver.cust_customers
ADD PRIMARY KEY (customer_id);

-- assign seller_id as primary key
ALTER TABLE selr_sellers
ADD PRIMARY KEY (seller_id);

-- assign order_id as primary key and customer_id as foreign key.
ALTER TABLE ord_orders
ADD PRIMARY KEY (order_id),
ADD CONSTRAINT fk_cust_id_1
	FOREIGN KEY (customer_id)
    REFERENCES silver.cust_customers (customer_id);
    
-- assign product_id as primary key
ALTER TABLE silver.prod_products
ADD PRIMARY KEY (product_id);

-- assign both seller_id and product_id as foreign keys.
ALTER TABLE silver.ord_order_items
ADD CONSTRAINT fk_seller_id_1
	FOREIGN KEY (seller_id)
    REFERENCES silver.selr_sellers (seller_id),
ADD CONSTRAINT fk_product_id_1
	FOREIGN KEY (product_id)
    REFERENCES silver.prod_products (product_id),
ADD CONSTRAINT fk_order_id_1
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
    
-- assign order_id as foreign key
ALTER TABLE silver.ord_order_reviews
ADD CONSTRAINT fk_order_id_2
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
    
-- assign order_id as foreign key.
ALTER TABLE silver.ord_order_payments
ADD CONSTRAINT fk_order_id_3
	FOREIGN KEY (order_id)
    REFERENCES silver.ord_orders (order_id);
