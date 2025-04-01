USE memory.default;

WITH payments AS (
-- calculate remaining months per invoice and total balance
SELECT
    i.supplier_id
    , s.name AS supplier_name 
    , i.invoice_amount
    , i.due_date
    , date_diff('month', now(), i.due_date) + 1 AS remaining_months
    , sum(i.invoice_amount) over (partition by i.supplier_id) AS total_payment
FROM
    INVOICE i
INNER JOIN SUPPLIER s 
    ON s.supplier_id = i.supplier_id
),
payments_per_supplier AS (
-- calculate total amount, remaining months and invoice amount per supplier
SELECT
    supplier_id
	, supplier_name
    , max(remaining_months) AS remaining_months
	,sum(invoice_amount) AS invoice_amount 
    , max(total_payment) AS total_payment
FROM payments
GROUP BY supplier_id, supplier_name
),
schedule_payment AS (
-- calculate invoice amount per month due
SELECT
    ps.supplier_id
    , ps.supplier_name
    , ps.invoice_amount / ps.remaining_months AS monthly_amount
    , last_day_of_month(date_add('month', months, now())) AS payment_date 
FROM payments_per_supplier ps
CROSS JOIN unnest(sequence(0, ps.remaining_months - 1)) AS t(months)
),
balance AS (
-- calculate monthly balance to pay per supplier
SELECT
    supplier_id
    , payment_date
    , sum(monthly_amount) over (partition by supplier_id order by payment_date) AS balance

FROM schedule_payment
    
)
-- calculate the balance outstanding per month and supplier
SELECT
    s.supplier_id
    , s.supplier_name
    , s.monthly_amount AS payment_amount
    , p.total_payment - b.balance AS balance_outstanding
    , s.payment_date
FROM schedule_payment s
INNER JOIN payments_per_supplier p 
    ON p.supplier_id = s.supplier_id
INNER JOIN balance b 
    ON b.supplier_id = s.supplier_id
    AND b.payment_date = s.payment_date 
ORDER BY 
    supplier_id
    , supplier_name;
