USE memory.default;

CREATE TABLE EXPENSES (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
)
COMMENT 'Expenses table using data from finance/receipts_from_last_night folder mapped with Employee identifier';

DROP TABLE IF EXISTS TempExpenses;

CREATE TABLE TempExpenses (
    employee_full_name VARCHAR,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
)
COMMENT 'Expenses temporary table using data from finance/receipts_from_last_night folder';

INSERT INTO TempExpenses VALUES
    ('Alex Jacobson', 6.50, 14),
    ('Alex Jacobson', 11.00, 20),
    ('Alex Jacobson', 22.00, 18),
    ('Alex Jacobson', 13.00, 75),
    ('Andrea Ghibaudi', 300, 1),
    ('Darren Poynton', 40.00, 9),
    ('Umberto Torrielli', 17.50, 4)
;


INSERT INTO EXPENSES 
SELECT 
    e.employee_id
    , t.unit_price
    , t.quantity
    
FROM TempExpenses t
INNER JOIN EMPLOYEE e 
    ON t.employee_full_name = concat(e.first_name, ' ', e.last_name)
;