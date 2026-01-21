CREATE TABLE gold.dim_payment AS
SELECT DISTINCT
    payment_type,
    payment_installments
FROM silver.ord_order_payments;

CREATE VIEW gold.dim_payment_view AS
SELECT DISTINCT
    payment_type,
    payment_installments
FROM silver.ord_order_payments;