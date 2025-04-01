USE memory.default;

WITH payments AS (
SELECT
    i.supplier_id
    , s.name AS supplier_name 
    , i.invoice_ammount
    , i.due_date
    , date_diff('month', now(), i.due_date) + 1 AS remaining_months
    , sum(i.invoice_ammount) over (partition by i.supplier_id) AS total_payment
FROM
    INVOICE i
INNER JOIN SUPPLIER s 
    ON s.supplier_id = i.supplier_id
),
payments_per_supplier AS (
SELECT
    supplier_id
	, supplier_name
    , max(remaining_months) AS remaining_months
	,sum(invoice_ammount) AS invoice_ammount 
    , max(total_payment) AS total_payment
FROM payments
GROUP BY supplier_id, supplier_name
),
schedule_payment AS (
SELECT
    ps.supplier_id
    , ps.supplier_name
    , ps.invoice_ammount / ps.remaining_months AS monthly_amount
    , last_day_of_month(date_add('month', months, now())) AS payment_date 
FROM payments_per_supplier ps
CROSS JOIN unnest(sequence(0, ps.remaining_months - 1)) AS t(months)
),
balance AS (
SELECT
    supplier_id
    , payment_date
    , sum(monthly_amount) over (partition by supplier_id order by payment_date) AS balance

FROM schedule_payment
    
)

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
