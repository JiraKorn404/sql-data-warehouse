-- Check for Duplicates
SELECT prd_key, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) != 1;

-- Check for Whitespaces
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULLS or Negative Numbers
SELECT IFNULL(prd_cost, 0) AS prd_key
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for Data Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

-- Show Table
SELECT *
FROM silver.crm_cust_info;

-- Check for Invalid Date Orders
SELECT *
From bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT COUNT(*)
FROM bronze.crm_prd_info
