USE memory.default;

-- get a list of employees that exceed the amount 1000
SELECT  
    em.employee_id
    , concat(em.first_name, ' ', em.last_name) AS employee_name
    , em.manager_id
    , concat(m.first_name, ' ', m.last_name) AS manager_name
    , sum(ex.unit_price * ex.quantity) AS total_expense_amount
FROM
    EMPLOYEE em
INNER JOIN EXPENSES ex 
    ON em.employee_id = ex.employee_id
LEFT JOIN EMPLOYEE m 
    ON  m.employee_id = em.manager_id
GROUP BY
    em.employee_id
    , concat(em.first_name, ' ', em.last_name)
    , em.manager_id
    , concat(m.first_name, ' ', m.last_name)
HAVING 
    sum(ex.unit_price * ex.quantity) > 1000
ORDER BY 
    sum(ex.unit_price * ex.quantity) DESC;