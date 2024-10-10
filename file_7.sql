create database newDB;

create table customers(
customer_id int primary key,
name varchar(100),
email varchar(100),
registration date);

select * from customers;

select * from orders;

create index idx_customer_reg_Date on customers(registration);
update customers set registration='2024-0-20'

set session join_buffer_size=4194304;
select o.orderId,o.orderDate,o.TotalAmount,c.Name
from orders o
join customers c  use index(idx_customer_reg_Date) on o.customer_id =c.customer_id
where c.registration>= DATE_SUB(CURDATE(),INTERVAL 30 day);



-- Populate Customers table
INSERT INTO Customers (Customer_ID, Name, Email, registration)
VALUES 
(1, 'John Doe', 'john.doe@email.com', '2024-09-15'),
(2, 'Jane Smith', 'jane.smith@email.com', '2024-09-20'),
(3, 'Bob Johnson', 'bob.johnson@email.com', '2024-09-25'),
(4, 'Alice Brown', 'alice.brown@email.com', '2024-09-30'),
(5, 'Charlie Davis', 'charlie.davis@email.com', '2024-10-01'),
(6, 'Eva Wilson', 'eva.wilson@email.com', '2024-10-02'),
(7, 'Frank Miller', 'frank.miller@email.com', '2024-10-03'),
(8, 'Grace Lee', 'grace.lee@email.com', '2024-10-04'),
(9, 'Henry Taylor', 'henry.taylor@email.com', '2024-10-05'),
(10, 'Ivy Clark', 'ivy.clark@email.com', '2024-10-06');

-- Insert 90 more customers with registration dates spread over the last 60 days
INSERT INTO Customers (Customer_ID, Name, Email, registration)
SELECT 
  10 + num,
  CONCAT('Customer', num),
  CONCAT('customer', num, '@email.com'),
  DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 60) DAY)
FROM (
  SELECT a.N + b.N * 10 + 1 as num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8) b
  ORDER BY num
  LIMIT 90
) numbers;
create table orders(orderid int primary key,
customer_id int,
orderdate date,
totalamount decimal(10,2),
foreign key(customer_id) references customers(customer_id));


-- Populate Orders table
INSERT INTO Orders (OrderID, customer_id, OrderDate, TotalAmount)
VALUES 
(1, 1, '2024-09-16', 150.00),
(2, 2, '2024-09-21', 200.50),
(3, 3, '2024-09-26', 75.25),
(4, 4, '2024-10-01', 300.75),
(5, 5, '2024-10-02', 50.00),
(6, 6, '2024-10-03', 125.50),
(7, 7, '2024-10-04', 80.00),
(8, 8, '2024-10-05', 220.25),
(9, 9, '2024-10-06', 175.00),
(10, 10, '2024-10-07', 90.50);

-- Insert 190 more orders with random customers and dates
INSERT INTO Orders (OrderID, Customer_ID, OrderDate, TotalAmount)
SELECT 
  10 + num,
  1 + FLOOR(RAND() * 100),
  DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY),
  ROUND(50 + RAND() * 450, 2)
FROM (
  SELECT a.N + b.N * 10 + c.N * 100 + 1 AS num
  FROM 
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
    (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
    (SELECT 0 AS N UNION SELECT 1) c
  ORDER BY num
  LIMIT 190
) numbers;