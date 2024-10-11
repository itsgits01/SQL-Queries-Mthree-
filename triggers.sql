create database trigger_practise;

use trigger_practise;

create table customers(id int auto_increment primary key,
name varchar(100),
email varchar(100));

create table email_changes_log(
id int auto_increment primary key,
customer_id int,
old_email varchar(100),
new_email varchar(100),
changed_at timestamp default current_timestamp);


insert into customers(name,email) values('Auahdahd','dqhduiqwh@gmail.com');

select * from customers;

DELIMITER //
CREATE TRIGGER log_email_changes
after update on customers
for each row
begin
     if old.email!=new.email then
           insert into email_changes_log(customer_id,old_email,new_email)
           values(old.id,old.email, new.email);
	 end if;
end//

delimiter ;

select * from email_changes_log;
update customers set email='ghghg2356@gmail.com' where id =1;
select * from customers;



--  new query
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10, 2),
    stock INT
);

CREATE TABLE low_stock_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    stock_level INT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, price, stock) 
VALUES ('Product A', 100.00, 9), 
       ('Product B', 150.00, 50);
SELECT * FROM products;

DELIMITER //
CREATE TRIGGER update_inventory
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    -- Check if the stock level has dropped below a threshold (e.g., 10 units)
    IF NEW.stock < 10 THEN
        -- Insert a low stock warning into the log
        INSERT INTO low_stock_log (product_id, stock_level)
        VALUES (NEW.id, NEW.stock);
    END IF;
END //
DELIMITER ;

UPDATE products 
SET stock = 8 
WHERE id = 1; -- Reducing the stock of 'Product A' to 8 units

SELECT * FROM low_stock_log;






