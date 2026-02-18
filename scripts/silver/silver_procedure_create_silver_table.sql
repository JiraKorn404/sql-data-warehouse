DROP PROCEDURE IF EXISTS silver.create_silver_table;

DELIMITER //

CREATE PROCEDURE silver.create_silver_table()
BEGIN
	DROP TABLE IF EXISTS silver.crm_cust_info;
	CREATE TABLE silver.crm_cust_info (
		cst_id INT,
		cst_key VARCHAR(255),
		cst_firstname VARCHAR(255),
		cst_lastname VARCHAR(255),
		cst_marital_status VARCHAR(255),
		cst_gndr VARCHAR(255),
		cst_create_date DATE,
		dwh_create_dt DATETIME DEFAULT NOW()
	);

	DROP TABLE IF EXISTS silver.crm_prd_info;
	CREATE TABLE silver.crm_prd_info (
		prd_id INT,
		cat_id VARCHAR(255),
		prd_key VARCHAR(255),
		prd_nm VARCHAR(255),
		prd_cost INT,
		prd_line VARCHAR(255),
		prd_start_dt DATE,
		prd_end_dt DATE,
		dwh_create_dt DATETIME DEFAULT NOW()
	);

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

	DROP TABLE IF EXISTS silver.erp_cust_az12;
	CREATE TABLE silver.erp_cust_az12 (
		cid VARCHAR(255),
		bdate DATE,
		gen VARCHAR(255),
		dwh_create_date DATETIME DEFAULT NOW()
	);

	DROP TABLE IF EXISTS silver.erp_loc_a101;
	CREATE TABLE silver.erp_loc_a101 (
		cid VARCHAR(255),
		cntry VARCHAR(255),
		dwh_create_date DATETIME DEFAULT NOW()
	);

	DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
	CREATE TABLE silver.erp_px_cat_g1v2 (
		id VARCHAR(255),
		cat VARCHAR(255),
		subcat VARCHAR(255),
		maintenance VARCHAR(255),
		dwh_create_date DATETIME DEFAULT NOW()
	);
END //

DELIMITER ;
