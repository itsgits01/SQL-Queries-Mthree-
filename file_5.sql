use info;

create table employees(employee_id int primary key, first_name varchar(50),last_name varchar(50), manager_id int); 

INSERT INTO employees (employee_id, first_name, last_name, manager_id) VALUES
(1, 'John', 'Doe', NULL),  -- CEO
(2, 'Jane', 'Smith', 1),   -- Reports to John
(3, 'Bob', 'Johnson', 1),  -- Reports to John
(4, 'Alice', 'Williams', 2), -- Reports to Jane
(5, 'Charlie', 'Brown', 2),  -- Reports to Jane
(6, 'David', 'Lee', 3),      -- Reports to Bob
(7, 'Eva', 'Garcia', 3),     -- Reports to Bob
(8, 'Frank', 'Lopez', 4),    -- Reports to Alice
(9, 'Grace', 'Kim', 6),      -- Reports to David
(10, 'Henry', 'Chen', 7);    -- Reports to Eva

-- with recursive employee_hierarchy as (
-- select employee_id, first_name,last_name , manager_id,0 as level
-- from employees
-- where manager_id is NULL
-- union all
-- select e.employee_id, e.first_name,e.last_name,e.manager_id, 1
-- from employees e 
-- join employees eh on eh.manager_id =eh.employee_id
-- )
-- select 
-- employee_id,
-- concat(first_name, ' ', last_name) as employee_name,
-- level
-- from employee_hierarchy
-- order by level , employee_id

WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Select the top-level employee (CEO)
    SELECT employee_id, first_name, last_name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Join employees with their manager
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, eh.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    level
FROM employee_hierarchy
ORDER BY level, employee_id;


