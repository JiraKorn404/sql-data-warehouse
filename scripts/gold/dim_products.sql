CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_key) AS product_key,
	prd.prd_id AS procuct_id,
	prd.prd_key AS product_number,
	prd.prd_nm AS product_name,
    prd.cat_id AS category_id,
    cat.cat AS category,
    cat.subcat AS subcategory,
    cat.maintenance,
    prd.prd_cost AS cost,
    prd.prd_line AS product_line,
    prd.prd_start_dt AS start_date
FROM silver.crm_prd_info AS prd
JOIN silver.erp_px_cat_g1v2 AS cat
	ON prd.cat_id = cat.id
    
WHERE prd.prd_end_dt IS NULL
