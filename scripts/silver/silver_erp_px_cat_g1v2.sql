-- Create, Clean, Insert bronze -> silver erp_px_cat_g1v2

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
	id VARCHAR(255),
    cat VARCHAR(255),
    subcat VARCHAR(255),
    maintenance VARCHAR(255),
    dwh_create_date DATETIME DEFAULT NOW()
);

TRUNCATE TABLE silver.erp_px_cat_g1v2;
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
FROM bronze.erp_px_cat_g1v2
