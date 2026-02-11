DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
    cst_key VARCHAR(255),
    cst_firstname VARCHAR(255),
    cst_lastname VARCHAR(255),
    cst_material_status VARCHAR(255),
    cst_gndr VARCHAR(255),
    cst_create_date DATE
);

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
    prd_key VARCHAR(255),
    prd_nm VARCHAR(255),
    prd_cost VARCHAR(255),
    prd_line VARCHAR(255),
    prd_start_dt DATE,
    prd_end_dt DATE
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num VARCHAR(255),
    sls_prd_key VARCHAR(255),
    sls_cust_id VARCHAR(255),
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid VARCHAR(255),
    bdate DATE,
    gen VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id VARCHAR(255),
    cat VARCHAR(255),
    subcat VARCHAR(255),
    maintenance VARCHAR(255)
);

DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid VARCHAR(255),
    cntry VARCHAR(255)
);
