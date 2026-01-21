CREATE TABLE gold.dim_payment AS
SELECT
    payment_type,
    payment_installments,
    COUNT(*) AS total_transactions,
    SUM(payment_value) AS total_amount_paid,
    AVG(payment_value) AS avg_payment_value,
    MAX(payment_value) AS max_payment_value,
    MIN(payment_value) AS min_payment_value,
    CASE 
        WHEN payment_installments = 1 THEN 'Single Payment'
        WHEN payment_installments BETWEEN 2 AND 6 THEN 'Short-term Installment'
        ELSE 'Long-term Installment'
    END AS installment_category,
    ROUND(AVG(payment_value/payment_installments),2) AS avg_installment_value
FROM silver.ord_order_payments
GROUP BY
    payment_type,
    payment_installments;

CREATE VIEW gold.dim_payment_view AS
SELECT
    payment_type,
    payment_installments,
    COUNT(*) AS total_transactions,
    SUM(payment_value) AS total_amount_paid,
    AVG(payment_value) AS avg_payment_value,
    MAX(payment_value) AS max_payment_value,
    MIN(payment_value) AS min_payment_value,
    CASE 
        WHEN payment_installments = 1 THEN 'Single Payment'
        WHEN payment_installments BETWEEN 2 AND 6 THEN 'Short-term Installment'
        ELSE 'Long-term Installment'
    END AS installment_category,
    ROUND(AVG(payment_value/payment_installments),2) AS avg_installment_value
FROM silver.ord_order_payments
GROUP BY
    payment_type,
    payment_installments;
