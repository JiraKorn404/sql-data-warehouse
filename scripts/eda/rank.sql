-- Which 5 products generate the highest revenue?
SELECT *
FROM (
SELECT
	p.product_name,
    SUM(f.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
GROUP BY p.product_name
) t
WHERE rank_products <= 5;

-- SELECT
-- 	p.product_name,
--     SUM(sales_amount) AS total_revenue
-- FROM gold.fact_sales AS f
-- LEFT JOIN gold.dim_products AS p
-- 	ON f.product_key = p.product_key
-- GROUP BY p.product_name
-- ORDER BY total_revenue DESC
-- LIMIT 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT	*
FROM (
SELECT
	p.product_name,
    SUM(sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(sales_amount) ASC) AS rank_products
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
GROUP BY p.product_name
-- LIMIT 5;
) t
WHERE rank_products <= 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT *
FROM (
SELECT
	c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_customers 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
) t
WHERE rank_customers <= 5;

-- The 3 customers with the fewest orders placed
SELECT *
FROM (
SELECT
	c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_order_placed,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT f.order_number) ASC) AS rank_customers 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
) t
-- WHERE rank_customers <= 3;
