-- Create departments table if it doesn't exist

use testdb;
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location_id INT
);

-- Create locations table if it doesn't exist
CREATE TABLE IF NOT EXISTS locations (
    location_id INT PRIMARY KEY,
    city VARCHAR(50)
);

-- Create employees table if it doesn't exist
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create customers table if it doesn't exist
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100)
);

-- Create orders table if it doesn't exist
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create products table if it doesn't exist
CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Multi-row INSERT statements

-- Insert multiple rows into departments
INSERT INTO departments (department_id, department_name, location_id) VALUES
(10, 'Administration', 1),
(20, 'Marketing', 2),
(30, 'Purchasing', 1),
(40, 'Human Resources', 2),
(50, 'Shipping', 3);

-- Insert multiple rows into locations
INSERT INTO locations (location_id, city) VALUES
(1, 'New York'),
(2, 'Los Angeles'),
(3, 'Chicago'),
(4, 'Houston'),
(5, 'Phoenix');

-- Insert multiple rows into employees
INSERT INTO employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, department_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '515.123.4567', '2019-06-17', 'AD_PRES', 24000.00, 10),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '515.123.4568', '2020-02-20', 'AD_VP', 17000.00, 10),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com', '515.123.4569', '2020-08-11', 'MK_MAN', 9000.00, 20),
(4, 'Bob', 'Brown', 'bob.brown@example.com', '515.123.4560', '2021-03-05', 'HR_REP', 6000.00, 40),
(5, 'Charlie', 'Davis', 'charlie.davis@example.com', '515.123.4561', '2021-11-30', 'SH_CLERK', 3000.00, 50);

-- Insert multiple rows into customers
INSERT INTO customers (customer_id, customer_name, email) VALUES
(1, 'Acme Corp', 'contact@acmecorp.com'),
(2, 'GlobalTech', 'info@globaltech.com'),
(3, 'Local Shop', 'owner@localshop.com'),
(4, 'Big Industries', 'sales@bigindustries.com'),
(5, 'Small Startup', 'hello@smallstartup.com');

-- Insert multiple rows into orders
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-01-15'),
(2, 1, '2023-02-20'),
(3, 2, '2023-02-22'),
(4, 3, '2023-03-01'),
(5, 2, '2023-03-15');

-- Insert multiple rows into products
INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Desk Chair', 'Furniture', 199.99),
(4, 'Coffee Maker', 'Appliances', 79.99),
(5, 'Wireless Mouse', 'Electronics', 29.99);

select e.first_name, e.last_name, d.department_name
from employees e
inner join departments d 
on e.department_id= d.department_id;


select c.customer_name , o.order_id
from customers c
left join orders o on c.customer_id =o.customer_id;

select c.customer_name , o.order_id
from customers c
right join orders o on c.customer_id =o.customer_id;


select first_name,last_name, salary
from employees 
where salary >(select avg(salary) from employees);

select department_id , avg(salary) as avgsalary
from employees 
group by department_id
having avgsalary >10000;

select * from employees;
select * from departments;
select * from customers;
select * from orders;
select * from products;

-- finding out emploess whose avg salary is greater than that of dept
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;



select 
d.department_name,
e.first_name,
e.last_name,
e.salary,
(select avg(salary) from employees where department_id = e.department_id) as dept_avg_salary
from 
employees e
inner join
departments d
on e.department_id =d.department_id
where e.salary > (select avg(salary) from employees )
order by d.department_name , e.salary desc;

select c.customer_name,
count(o.order_id) as order_count,
coalesce(sum(p.price),0) as total_order_value
from 
customers c
left join 
orders o on c.customer_id =o.customer_id
left join 
products p on p.product_id in (select product_id from orders where order_id = o.order_id )
group by
c.customer_id,c.customer_name
having 
count(o.order_id)> 0
order by 
total_order_value desc;

select c.customer_name,
count(o.order_id) as order_count,
coalesce(sum(p.price),0) as total_order_value
from 
customers c
left join 
orders o on c.customer_id =o.customer_id
left join 
products p on p.product_id = (select product_id from orders where order_id = o.order_id limit 1)
group by
c.customer_id,c.customer_name
having 
count(o.order_id)> 0
order by 
total_order_value desc;


select * from employees;

select e1.first_name as employee1_first_name,
e1.last_name as employee1_last_name,
e2.first_name as employee2_first_name,
e2.last_name as employee2_last_name,
e1.job_id
from 
employees e1
inner join 
employees e2
on e1.department_id =e2.department_id -- and e1.employee_id<e2.employee_id;

select d.department_name,
e.first_name,
e.last_name,
e.salary,
avg(e.salary) over (partition by d.department_id) as dept_avg_slary,
rank() over (partition by d.department_id order by e.salary desc) as salary_rank
from departments d
left outer join 
employees e on
d.department_id =e.department_id
order by d.department_name,e.salary desc;


select * from orders;
select product_id from orders;

select c.customer_name,
o.order_date,
case 
  when DAYOFWEEK(o.order_date) in (1,7) Then 'Weekend'
  else 'Weekday'
end as order_day_type,
p.product_name,
p.price,
case
  when p.price<100 then 'Budget'
  when p.price between 100 and 500 then 'mid range'
  else 'premium'
end as price_category
from customers c
inner join 
orders o on  c.customer_id =o.customer_id
inner join products p on p.product_id in (select product_id from orders where order_id =o.order_id)
where 
o.order_date <= DATE_SUB(CURDATE(),INTERVAL 1 YEAR)
order by 
o.order_date desc;

select * from products;
select * from customers;