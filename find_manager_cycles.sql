USE memory.default;

WITH RECURSIVE MANAGERS (manager_id, employee_id, employee_ids_list) AS (
    -- base case, selecting manager-employee link
    SELECT 
        manager_id
        , employee_id
        , cast(employee_id as VARCHAR) AS employee_ids_list
    FROM EMPLOYEE

    UNION ALL
    --recursive case, for a specific manager get all employees
    SELECT 
        m.manager_id
        , e.employee_id
        , concat(m.employee_ids_list, ', ', cast(e.employee_id as VARCHAR)) AS employee_ids_list
    FROM EMPLOYEE e 
        INNER JOIN MANAGERS m
            ON m.employee_id = e.manager_id
    WHERE
        position(cast(e.employee_id as VARCHAR) in m.employee_ids_list) = 0 -- in case the employee already was identified, it skips

)

-- returns a list of employees under a manager
SELECT
    manager_id
    , max(employee_ids_list) AS employee_ids_list
FROM MANAGERS
    WHERE
        position(cast(manager_id as VARCHAR) in employee_ids_list) > 0 -- it considers only employees that arent already in the list
GROUP BY 
    manager_id
ORDER BY 
    manager_id;