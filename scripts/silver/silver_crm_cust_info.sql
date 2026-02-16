-- Create, Clean, Insert bronze -> silver crm_cust_info

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

TRUNCATE TABLE silver.crm_cust_info;
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
WHERE flag_last = 1 -- Select the most recent record per customer
