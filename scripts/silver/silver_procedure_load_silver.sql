CALL silver.load_silver();

DROP PROCEDURE IF EXISTS silver.load_silver;

DELIMITER //

CREATE PROCEDURE silver.load_silver()
BEGIN
	DECLARE start_time DATETIME DEFAULT NULL;
    DECLARE end_time DATETIME DEFAULT NULL;
    DECLARE batch_start DATETIME DEFAULT NULL;
    DECLARE batch_end DATETIME DEFAULT NULL;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1
			@sql_state = RETURNED_SQLSTATE,
            @err_no = MYSQL_ERRNO,
            @err_msg = MESSAGE_TEXT;
		SELECT '=============================================' AS log_message;
        SELECT '>> ERROR OCCURRED DURING SILVER LAYER LOAD' AS log_message;    
        SELECT CONCAT('>> SQL State : ', @sql_state) AS log_message;        
        SELECT CONCAT('>> Error Code : ', @err_no) AS log_message;                 
        SELECT CONCAT('>> Error Message : ', @err_msg) AS log_message;             
        SELECT CONCAT('>> Failed at approx: ', NOW()) AS log_message;
        SELECT '=============================================';
	END;


    SET batch_start = NOW();
    
	-- Loading silver.crm_cust_info
    SET start_time = NOW();
    SELECT '>> Truncating Table: silver.crm_cust_info' AS log_message;
	TRUNCATE TABLE silver.crm_cust_info;
    SELECT '>> Inserting Table: silver.crm_cust_info' AS log_message;
	INSERT INTO silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
	)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			WHEN UPPER(TRIM(cst_marital_status)) = 'S'  THEN 'Single'
			ELSE 'n/a'
		END AS cst_marital_status, -- Map marital status values to readable format
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
			ELSE 'n/a'
		END AS cst_gndr, -- Map gender values to readable format
		cst_create_date
	FROM (
		SELECT
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
	) t
	WHERE flag_last = 1; -- Select the most recent record per customer
	SET end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
    SELECT '========================';

	-- Loading silver.crm_prd_info
    SET start_time = NOW();
	SELECT '>> Truncating Table: silver.crm_prd_info' AS log_message;
	TRUNCATE TABLE silver.crm_prd_info;
    SELECT '>> Inserting Table: silver.crm_prd_info' AS log_message;
	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID key
		SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Extract product ID key
		prd_nm,
		IFNULL(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'R' THEN 'Road'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a' -- Map product line values to readable format
		END AS prd_line,
		prd_start_dt,
		DATE_SUB(
			LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC), INTERVAL 1 DAY
		) AS prd_end_dt -- Calculate end date as one day before the next start date
	FROM bronze.crm_prd_info;
    SET end_time = NOW();
    SELECT CONCAT('>> Load Duration', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
    SELECT '========================';
    
	-- Loading silver.crm_sales_details
    SET start_time = NOW();
	SELECT '>> Truncating Table: silver.crm_sales_details' AS log_message;
	TRUNCATE TABLE silver.crm_sales_details;
    SELECT '>> Inserting Table: silver.crm_sales_details' AS log_message;
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
    SET end_time = NOW();
    SELECT CONCAT('>> Load Duration', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
    SELECT '========================';
    
	-- Loading silver.erp_cust_az12
    SET start_time = NOW();
	SELECT '>> Truncating Table: silver.erp_cust_az12' AS log_message;
	TRUNCATE TABLE silver.erp_cust_az12;
    SELECT '>> Inserting Table: silver.erp_cust_az12' AS log_message;
	INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
	)
	SELECT 
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
			ELSE cid
		END AS cid,
		CASE WHEN bdate < '1924-01-01' OR bdate > NOW() THEN NULL
			ELSE bdate 
		END AS bdate,
		CASE WHEN UPPER(gen) LIKE 'F%' THEN 'Female'
			WHEN UPPER(gen) LIKE 'M%' THEN 'Male'
			ELSE 'n/a'
		END AS gen
	FROM bronze.erp_cust_az12;
    SET end_time = NOW();
    SELECT CONCAT('>> Load Duration', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
    SELECT '========================';
    
    -- Loading silver.erp_loc_a101
    SET start_time = NOW();
	SELECT '>> Truncating Table: silver.erp_loc_a101' AS log_message;
	TRUNCATE TABLE silver.erp_loc_a101;
    SELECT '>> Inserting Table: silver.erp_loc_a101' AS log_message;
	INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
	)
	SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE WHEN REPLACE(TRIM(cntry), '\r', '') = 'DE' THEN 'Germany'
			WHEN REPLACE(TRIM(cntry), '\r', '') IN ('US', 'USA') THEN 'United States'
			WHEN REPLACE(TRIM(cntry), '\r', '') = '' OR TRIM(cntry) IS NULL THEN 'n/a'
			ELSE REPLACE(TRIM(cntry), '\r', '')
		END AS cntry
	FROM bronze.erp_loc_a101;
    SET end_time = NOW();
    SELECT CONCAT('>> Load Duration', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
    SELECT '========================';
    
	-- Load erp_px_cat_g1v2
    SET start_time = NOW();
	SELECT '>> Truncating Table: silver.erp_px_cat_g1v2' AS log_message;
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
    SELECT '>> Inserting Table: silver.erp_px_cat_g1v2' AS log_message;
	INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
	)
	SELECT
		id,
		cat,
		subcat,
		REPLACE(maintenance, '\r', '') AS maintenance
	FROM bronze.erp_px_cat_g1v2;
    SET end_time = NOW();
    SELECT CONCAT('>> Load Duration', TIMESTAMPDIFF(SECOND, start_time, end_time), ' seconds') AS log_message;
	SELECT '========================';
        
    SET batch_end = NOW();
    SELECT CONCAT('>> Total Load Duration', TIMESTAMPDIFF(SECOND, batch_start, batch_end), ' seconds') AS log_message;
    SELECT '========================';
    
END //

DELIMITER ;
