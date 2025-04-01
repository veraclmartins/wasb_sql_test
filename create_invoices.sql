USE memory.default;

CREATE TABLE INVOICE (
    supplier_id TINYINT,
    invoice_ammount DECIMAL(8, 2),
    due_date DATE
)
COMMENT 'Invoice table using data from finance/invoices_due folder';


CREATE TABLE SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
)
COMMENT 'Supplier table using data from finance/invoices_due folder to retrieve supplier ids';


DROP TABLE IF EXISTS TempInvoice;

CREATE TABLE TempInvoice (
    company_name VARCHAR,
    invoice_ammount DECIMAL(8, 2),
    due_date_in_months INT
)
COMMENT 'Invoice temporary table using data from finance/invoices_due folder';

INSERT INTO TempInvoice VALUES
('Party Animals', 6000.00, 3),
('Catering Plus', 2000.00, 2),
('Catering Plus', 1500.00, 3),
('Dave''s Discos', 500.00, 1),
('Entertainment tonight', 6000.00, 3),
('Ice Ice Baby', 4000.00, 6)
;

INSERT INTO SUPPLIER 
SELECT 
    row_number() over(order by company_name) as supplier_id
    , company_name AS name
    
FROM (SELECT DISTINCT company_name FROM TempInvoice) ;


INSERT INTO INVOICE 
SELECT 
    s.supplier_id
    , t.invoice_ammount
    , last_day_of_month(date_add('month', t.due_date_in_months, now())) due_date
FROM TempInvoice t
INNER JOIN SUPPLIER s 
    ON t.company_name = s.name ;