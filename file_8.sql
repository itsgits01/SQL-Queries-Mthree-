-- Create tables

use facebook;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 599.99),
(3, 'Tablet', 'Electronics', 399.99),
(4, 'Desk Chair', 'Furniture', 149.99),
(5, 'Coffee Table', 'Furniture', 199.99),
(6, 'Bookshelf', 'Furniture', 89.99),
(7, 'Running Shoes', 'Apparel', 79.99),
(8, 'T-shirt', 'Apparel', 19.99),
(9, 'Jeans', 'Apparel', 59.99);

INSERT INTO sales (sale_id, product_id, sale_date, quantity) VALUES
(1, 1, '2023-01-15', 2),
(2, 2, '2023-01-16', 3),
(3, 4, '2023-01-17', 1),
(4, 7, '2023-01-18', 4),
(5, 3, '2023-02-01', 2),
(6, 5, '2023-02-02', 1),
(7, 8, '2023-02-03', 5),
(8, 1, '2023-02-15', 1),
(9, 6, '2023-02-16', 2),
(10, 2, '2023-02-17', 2),
(11, 9, '2023-03-01', 3),
(12, 4, '2023-03-02', 2),
(13, 7, '2023-03-03', 3),
(14, 3, '2023-03-15', 1),
(15, 5, '2023-03-16', 1);

select * from products;
select * from sales;

explain WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') AS month, -- Extract year and month
        p.category,
        SUM(s.quantity * p.unit_price) AS total_revenue
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY month, p.category
),
-- Step 2: Find the maximum total revenue for each month
monthly_max_revenue AS (
    SELECT 
        month,
        MAX(total_revenue) AS max_revenue
    FROM monthly_revenue
    GROUP BY month
)
-- Step 3: Select the top-performing categories that match the max revenue for each month
SELECT 
    mr.month,
    mr.category AS top_category,
    mr.total_revenue
FROM monthly_revenue mr
JOIN monthly_max_revenue mmr
    ON mr.month = mmr.month
   AND mr.total_revenue = mmr.max_revenue
ORDER BY mr.month;

explain WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') AS month, -- Extract year and month
        p.category,
        SUM(s.quantity * p.unit_price) AS total_revenue,
        -- Assign row numbers based on total revenue in descending order for each month
        ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(s.sale_date, '%Y-%m') ORDER BY SUM(s.quantity * p.unit_price) DESC) AS rn
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    GROUP BY month, p.category
)
-- Select only the top-performing categories for each month
SELECT 
    month,
    category AS top_category,
    total_revenue
FROM monthly_revenue
WHERE rn = 1
ORDER BY month;


-- Problem Statement:
-- Analyze the sales data to find the top-performing product category for each month of 2023.
-- The performance should be based on total revenue (quantity sold * unit price).
-- Your query should return the month, the top-performing category, and its total revenue.
-- In case of a tie, include all categories with the same top performance.

-- Expected output format:
-- | month | top_category | total_revenue |
-- |-------|--------------|---------------|
-- | 2023-01 | Electronics | 2799.97      |
-- | 2023-02 | Furniture   | 399.98       |
-- | 2023-03 | Electronics | 999.98       |

-- Note: The actual values may differ based on the sample data provided.