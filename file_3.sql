create database info;

use info;

-- Example 2: Product Recommendations
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE product_recommendations (
    product_id INT,
    recommended_product_id INT,
    strength DECIMAL(3, 2),
    PRIMARY KEY (product_id, recommended_product_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (recommended_product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 699.99),
(3, 'Tablet', 'Electronics', 399.99),
(4, 'Headphones', 'Electronics', 149.99),
(5, 'Smart Watch', 'Electronics', 249.99);

INSERT INTO product_recommendations (product_id, recommended_product_id, strength) VALUES
(1, 2, 0.8),
(1, 3, 0.6),
(1, 4, 0.7),
(2, 1, 0.8),
(2, 3, 0.9),
(2, 5, 0.7),
(3, 1, 0.6),
(3, 2, 0.9),
(3, 4, 0.5);

select * from products;
select * from product_recommendations;

-- Self join to get product recommendations with product names
SELECT 
    p1.product_name AS product_name,
    p2.product_name AS recommended_product_name,
    pr.strength
FROM 
    product_recommendations pr
INNER JOIN 
    products p1 ON pr.product_id = p1.product_id
INNER JOIN 
    products p2 ON pr.recommended_product_id = p2.product_id
ORDER BY 
    pr.strength DESC;
