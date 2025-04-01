USE memory.default;

-- Creating INVOICE table
CREATE TABLE INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
)
COMMENT 'Invoice table using data from finance/invoices_due folder';

-- Creating SUPPLIER table
CREATE TABLE SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
)
COMMENT 'Supplier table using data from finance/invoices_due folder to retrieve supplier ids';

-- Clean invoice temporary table if exists
DROP TABLE IF EXISTS TempInvoice;

-- Create invoice temporary table
CREATE TABLE TempInvoice (
    company_name VARCHAR,
    invoice_amount DECIMAL(8, 2),
    due_date_in_months INT
)
COMMENT 'Invoice temporary table using data from finance/invoices_due folder';

-- Inserting data from finance/invoices_due folder into temporary table
INSERT INTO TempInvoice VALUES
('Party Animals', 6000.00, 3),
('Catering Plus', 2000.00, 2),
('Catering Plus', 1500.00, 3),
('Dave''s Discos', 500.00, 1),
('Entertainment tonight', 6000.00, 3),
('Ice Ice Baby', 4000.00, 6)
;

-- Inserting supplier name and create a unique id for each unique supplier
INSERT INTO SUPPLIER 
SELECT 
    row_number() over(order by company_name) as supplier_id
    , company_name AS name
    
FROM (SELECT DISTINCT company_name FROM TempInvoice) ;

-- Inserting invoice data for each unique supplier for invoice end of month
INSERT INTO INVOICE 
SELECT 
    s.supplier_id
    , t.invoice_amount
    , last_day_of_month(date_add('month', t.due_date_in_months, now())) due_date
FROM TempInvoice t
INNER JOIN SUPPLIER s 
    ON t.company_name = s.name ;