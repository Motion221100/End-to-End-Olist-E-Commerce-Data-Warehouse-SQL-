CREATE TABLE gold.fact_payments AS
SELECT
    op.order_id,
    op.payment_type,
    op.payment_installments,
    op.payment_value,
    op.payment_sequential,
    CASE 
        WHEN op.payment_sequential > 1 THEN 'Split Payment'
        ELSE 'Single Payment'
    END AS payment_method_category,
    CASE 
        WHEN op.payment_installments = 0 THEN 'No Installments'
        WHEN op.payment_installments = 1 THEN 'Single Payment'
        ELSE 'Installment Payment'
    END AS installment_type,
    ROUND(op.payment_value / NULLIF(op.payment_installments, 0), 2) AS installment_amount,
    CASE 
        WHEN op.payment_value > 1000 THEN 'Large Payment'
        WHEN op.payment_value BETWEEN 100 AND 1000 THEN 'Medium Payment'
        ELSE 'Small Payment'
    END AS payment_size_category,
    CASE 
        WHEN op.payment_type IN ('credit_card', 'debit_card') THEN 'Card Payment'
        WHEN op.payment_type = 'voucher' THEN 'Voucher Payment'
        WHEN op.payment_type = 'boleto' THEN 'Bank Slip'
        ELSE 'Other Payment'
    END AS payment_group
FROM silver.ord_order_payments op;

CREATE VIEW gold.fact_payments_view AS
SELECT
    op.order_id,
    op.payment_type,
    op.payment_installments,
    op.payment_value,
    op.payment_sequential,
    CASE 
        WHEN op.payment_sequential > 1 THEN 'Split Payment'
        ELSE 'Single Payment'
    END AS payment_method_category,
    CASE 
        WHEN op.payment_installments = 0 THEN 'No Installments'
        WHEN op.payment_installments = 1 THEN 'Single Payment'
        ELSE 'Installment Payment'
    END AS installment_type,
    ROUND(op.payment_value / NULLIF(op.payment_installments, 0), 2) AS installment_amount,
    CASE 
        WHEN op.payment_value > 1000 THEN 'Large Payment'
        WHEN op.payment_value BETWEEN 100 AND 1000 THEN 'Medium Payment'
        ELSE 'Small Payment'
    END AS payment_size_category,
    CASE 
        WHEN op.payment_type IN ('credit_card', 'debit_card') THEN 'Card Payment'
        WHEN op.payment_type = 'voucher' THEN 'Voucher Payment'
        WHEN op.payment_type = 'boleto' THEN 'Bank Slip'
        ELSE 'Other Payment'
    END AS payment_group
FROM silver.ord_order_payments op;
