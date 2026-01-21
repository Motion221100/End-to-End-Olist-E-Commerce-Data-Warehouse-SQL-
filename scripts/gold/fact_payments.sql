CREATE TABLE gold.fact_payments AS
SELECT
    op.order_id,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM silver.ord_order_payments op;

CREATE VIEW gold.fact_payments_view AS
SELECT
    op.order_id,
    op.payment_type,
    op.payment_installments,
    op.payment_value
FROM silver.ord_order_payments op;