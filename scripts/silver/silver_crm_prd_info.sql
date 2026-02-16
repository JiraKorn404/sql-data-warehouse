-- Create, Clean, Insert bronze -> silver crm_prd_info

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

TRUNCATE TABLE silver.crm_prd_info;
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
FROM bronze.crm_prd_info
