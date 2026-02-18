-- Create, Clean, Insert bronze -> silver erp_loc_a101

DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
	cid VARCHAR(255),
    cntry VARCHAR(255),
    dwh_create_date DATETIME DEFAULT NOW()
);

TRUNCATE TABLE silver.erp_loc_a101;
INSERT INTO silver.erp_loc_a101 (
	cid,
    cntry
)
SELECT
	cid,
    CASE WHEN REPLACE(TRIM(cntry), '\r', '') = 'DE' THEN 'Germany'
		WHEN REPLACE(TRIM(cntry), '\r', '') IN ('US', 'USA') THEN 'United States'
        WHEN REPLACE(TRIM(cntry), '\r', '') = '' OR TRIM(cntry) IS NULL THEN 'n/a'
        ELSE REPLACE(TRIM(cntry), '\r', '')
	END AS cntry
FROM bronze.erp_loc_a101
