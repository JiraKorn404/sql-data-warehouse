-- Create, Clean, Insert bronze -> silver crm_sales_details

DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
	sls_ord_num VARCHAR(255),
    sls_prd_key VARCHAR(255),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_dt DATETIME DEFAULT NOW()
);

TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT 
	sls_ord_num,
    TRIM(sls_prd_key) AS sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
		ELSE DATE(sls_order_dt)
	END AS sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
		ELSE DATE(sls_ship_dt)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
		ELSE DATE(sls_due_dt)
	END AS sls_due_dt,
	CASE 
        WHEN sls_sales IS NULL OR sls_sales <= 0 THEN 
             -- If sales are missing, we MUST rely on price. 
             -- If price is also missing (0), this will result in 0, which is unavoidable.
             sls_quantity * ABS(sls_price)
        WHEN sls_price IS NULL OR sls_price = 0 THEN
             -- If price is missing, DO NOT RECALCULATE. Keep the original Sales value.
             sls_sales
        WHEN sls_sales != sls_quantity * ABS(sls_price) THEN
             -- Only recalc mismatch if Price is valid (>0)
             sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 THEN 
             -- Use ABS(sls_sales) to ensure we don't get negative prices from bad sales data
             ABS(sls_sales) / NULLIF(sls_quantity, 0)
        ELSE ABS(sls_price) -- Enforce positive price even if we don't recalculate
    END AS sls_price
FROM bronze.crm_sales_details;
