CREATE VIEW gold.fact_sales AS
SELECT 
	sls.sls_ord_num AS order_number,
    prd.product_key,
    cst.customer_key,
    sls.sls_order_dt AS order_date,
    sls.sls_ship_dt AS ship_date,
    sls.sls_due_dt AS due_date,
    sls.sls_sales AS sales_amount,
    sls.sls_quantity AS quantity,
    sls.sls_price AS price
FROM silver.crm_sales_details AS sls
JOIN gold.dim_customers AS cst
	ON sls.sls_cust_id = cst.customer_id
JOIN gold.dim_products AS prd
	ON sls.sls_prd_key = prd.product_number
