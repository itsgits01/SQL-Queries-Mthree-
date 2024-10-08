-- Sample Data Setup

create database solve;
use solve;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

INSERT INTO employees VALUES
(1, 'John', 'Doe', 'IT', 75000, '2020-01-15'),
(2, 'Jane', 'Smith', 'HR', 65000, '2019-05-11'),
(3, 'Bob', 'Johnson', 'IT', 80000, '2018-03-23'),
(4, 'Alice', 'Williams', 'Finance', 72000, '2021-09-30'),
(5, 'Charlie', 'Brown', 'IT', 68000, '2022-02-14'),
(6, 'Eva', 'Davis', 'HR', 61000, '2020-11-18'),
(7, 'Frank', 'Miller', 'Finance', 79000, '2017-07-12'),
(8, 'Grace', 'Taylor', 'IT', 77000, '2019-04-22'),
(9, 'Henry', 'Anderson', 'Finance', 71000, '2021-01-05'),
(10, 'Ivy', 'Thomas', 'HR', 63000, '2022-06-30');

select * from employees;

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects VALUES
(1, 'Database Migration', '2023-01-01', '2023-06-30'),
(2, 'New HR System', '2023-03-15', '2023-12-31'),
(3, 'Financial Reporting Tool', '2023-02-01', '2023-11-30'),
(4, 'IT Infrastructure Upgrade', '2023-05-01', '2024-04-30');

CREATE TABLE employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO employee_projects VALUES
(1, 1, 'Project Lead'),
(2, 2, 'Project Manager'),
(3, 1, 'Database Admin'),
(4, 3, 'Financial Analyst'),
(5, 4, 'Network Engineer'),
(6, 2, 'HR Specialist'),
(7, 3, 'Data Analyst'),
(8, 4, 'Systems Architect'),
(1, 4, 'Security Consultant'),
(3, 4, 'Software Developer');

-- Questions

-- 1. Write a query to find the top 3 highest paid employees in each department.
SELECT e1.employee_id, 
       e1.first_name, 
       e1.last_name, 
       e1.department, 
       e1.salary
FROM employees e1
WHERE (
    SELECT COUNT(*) 
    FROM employees e2 
    WHERE e2.department = e1.department 
      AND e2.salary > e1.salary
) < 3
ORDER BY e1.department, e1.salary DESC;


-- 2. Calculate the running total of salaries in each department, ordered by hire date.
SELECT e1.employee_id,
       e1.first_name,
       e1.last_name,
       e1.department,
       e1.salary,
       e1.hire_date,
       (SELECT SUM(e2.salary)
        FROM employees e2
        WHERE e2.department = e1.department
          AND e2.hire_date <= e1.hire_date) AS running_total_salary
FROM employees e1
ORDER BY e1.department, e1.hire_date;


-- 3. Find employees who are working on more than one project, along with the count of projects they're involved in.
WITH dept_max_salaries AS (
    SELECT 
        department,
        MAX(salary) as max_salary
    FROM 
        employees
    GROUP BY 
        department
),
longest_project AS (
    SELECT 
        project_id,
        end_date - start_date as duration
    FROM 
        projects
    ORDER BY 
        duration DESC
    LIMIT 1
)
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       COUNT(ep.project_id) AS project_count
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(ep.project_id) > 1;

-- 4. Identify projects that have team members from all departments.
SELECT ep.project_id, p.project_name
FROM employee_projects ep
JOIN employees e ON ep.employee_id = e.employee_id
JOIN projects p ON ep.project_id = p.project_id
GROUP BY ep.project_id, p.project_name
HAVING COUNT(DISTINCT e.department) = (SELECT COUNT(DISTINCT department) FROM employees);


-- 5. Calculate the average salary for each department, but only include employees hired in the last 3 years.
SELECT department,
       AVG(salary) AS average_salary
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY department;


-- 6. Create a pivot table showing the count of employees in each department, with columns for different salary ranges (e.g., <65000, 65000-75000, >75000).
SELECT department,
       COUNT(CASE WHEN salary < 65000 THEN 1 END) AS salary_below_65000,
       COUNT(CASE WHEN salary BETWEEN 65000 AND 75000 THEN 1 END) AS salary_65000_to_75000,
       COUNT(CASE WHEN salary > 75000 THEN 1 END) AS salary_above_75000
FROM employees
GROUP BY department;


-- 7. Find the employee(s) with the highest salary in their respective departments, who are also working on the longest-running project.
WITH dept_max_salaries AS (
    SELECT 
        department,
        MAX(salary) as max_salary
    FROM 
        employees
    GROUP BY 
        department
),
longest_project AS (
    SELECT 
        project_id,
        end_date - start_date as duration
    FROM 
        projects
    ORDER BY 
        duration DESC
    LIMIT 1
)
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    e.salary,
    p.project_name
FROM 
    employees e
JOIN 
    dept_max_salaries dms ON e.department = dms.department AND e.salary = dms.max_salary
JOIN 
    employee_projects ep ON e.employee_id = ep.employee_id
JOIN 
    projects p ON ep.project_id = p.project_id
JOIN 
    longest_project lp ON p.project_id = lp.project_id;

-- 8. Calculate the percentage of each department's salary compared to the total salary of the company.
SELECT department,
       SUM(salary) AS total_department_salary,
       (SUM(salary) / (SELECT SUM(salary) FROM employees) * 100) AS salary_percentage
FROM employees
GROUP BY department;

-- 9. Identify employees who have a higher salary than their department's average, and show by what percentage their salary exceeds the average.
SELECT e.first_name,
       e.last_name,
       e.salary,
       d.average_salary,
       ROUND((e.salary - d.average_salary) / d.average_salary * 100, 2) AS percentage_exceeding_average
FROM employees e
JOIN (
    SELECT department,
           AVG(salary) AS average_salary
    FROM employees
    GROUP BY department
) d ON e.department = d.department
WHERE e.salary > d.average_salary;

-- 10. Create a query that shows a hierarchical view of employees and their projects, with multiple levels of projects if an employee is in more than one.
SELECT e.employee_id,
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
       p.project_name,
       ep.role
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
ORDER BY e.employee_id, p.project_id;

-- Bonus Challenge:
-- 11. Implement a query to find the "Kevin Bacon Number" equivalent for projects. 
--     (i.e., for each pair of employees, find the shortest connection through shared projects)
SELECT e.employee_id,
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
       p.project_name,
       ep.role
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
ORDER BY e.employee_id, p.project_id;
