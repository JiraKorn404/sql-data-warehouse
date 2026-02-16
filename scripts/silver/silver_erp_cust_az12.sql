-- Create, Clean, Insert bronze -> silver erp_cust_az12

DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	cid VARCHAR(255),
    bdate DATE,
    gen VARCHAR(255),
    dwh_create_date DATETIME DEFAULT NOW()
);

TRUNCATE TABLE silver.erp_cust_az12;
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
FROM bronze.erp_cust_az12

