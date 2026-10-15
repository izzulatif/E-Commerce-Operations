-- ==========================================
-- PROJECT 1: E-COMMERCE OPERATIONAL RISK ANALYSIS
-- ==========================================

-- 1. Database & Table Setup
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    region VARCHAR(50),
    signup_date DATE
);

INSERT INTO customers VALUES
(101, 'Ahmad Razak', 'Kuala Lumpur', '2025-01-15'),
(102, 'Siti Nurhaliza', 'Selangor', '2025-02-01'),
(103, 'Tan Wei Ming', 'Penang', '2025-02-10'),
(104, 'Muthu Kumar', 'Johor', '2025-03-05'),
(105, 'Lee Jia Yi', 'Kuala Lumpur', '2025-03-12'),
(106, 'Farah Ann', 'Sabah', '2025-04-01');

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    shipping_date DATE,
    product_category VARCHAR(50),
    order_amount DECIMAL(10, 2),
    order_status VARCHAR(20)
);

INSERT INTO orders VALUES
(1001, 101, '2026-08-01', '2026-08-03', 'Electronics', 1200.00, 'Completed'),
(1002, 101, '2026-08-15', '2026-08-20', 'Apparel', 150.00, 'Completed'),
(1003, 102, '2026-08-02', '2026-08-08', 'Electronics', 850.00, 'Cancelled'),
(1004, 102, '2026-08-25', '2026-09-02', 'Home Goods', 300.00, 'Returned'),
(1005, 103, '2026-08-05', '2026-08-06', 'Apparel', 80.00, 'Completed'),
(1006, 103, '2026-08-20', '2026-08-22', 'Electronics', 2100.00, 'Completed'),
(1007, 104, '2026-08-10', '2026-08-18', 'Electronics', 950.00, 'Cancelled'),
(1008, 104, '2026-08-28', '2026-09-05', 'Apparel', 200.00, 'Returned'),
(1009, 105, '2026-09-01', '2026-09-03', 'Home Goods', 450.00, 'Completed'),
(1010, 105, '2026-09-15', '2026-09-22', 'Electronics', 1100.00, 'Cancelled'),
(1011, 106, '2026-09-02', '2026-09-12', 'Electronics', 1300.00, 'Returned');


-- ==========================================
-- 2. ANALYTICAL QUERIES
-- ==========================================

-- Query 1: Shipping Delay & Tiering
WITH OrderDelays AS (
	SELECT order_id, 
		customer_id, 
		product_category, 
		order_status, 
		order_amount, 
		DATEDIFF(shipping_date, order_date) AS shipping_delay_days
	FROM orders
)
SELECT 
	order_id, 
    customer_id, 
    product_category, 
    order_status, 
    order_amount, 
    shipping_delay_days,
	CASE
		WHEN shipping_delay_days <= 3 THEN 'Fast (<=3 Days)'
		WHEN shipping_delay_days BETWEEN 4 AND 6 THEN 'Moderate (4-6 Days)'
		ELSE 'Severely Delayed (>6 Days)'
	END AS delay_tier
FROM OrderDelays;


-- Query 2: Order-over-Order Value Trajectory
SELECT 
	customer_id, 
    order_id, 
    order_date, 
    order_amount, 
    LAG(order_amount) OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS previous_order_amount, 
    order_amount - LAG(order_amount) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS amount_difference
FROM orders
ORDER BY order_date ASC;


-- Query 3: Category Failure Rate Summary
SELECT
	product_category, 
    COUNT(order_id) AS total_orders, 
    SUM(CASE WHEN order_status IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) AS failed_orders, 
    ROUND(
        SUM(CASE WHEN order_status IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id), 
        2
    ) AS failure_rate_pct
FROM orders
GROUP BY product_category;