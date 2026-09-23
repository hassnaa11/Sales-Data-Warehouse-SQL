
----- Check Data Quality in Bronze Layer Before Loading in Silver Layer ----- 

/*************  1) Table crm_cust_info  *************/
--- Check for NULLs and Duplicates ---
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--- Check Unwanted Spaces ---
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--- Check Data Consistancy & Standrdization in Gender and Status Columns ---
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;


/*************  2) Table crm_prd_info  *************/
--- Check for NULLs and Duplicates ---
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--- Check Unwanted Spaces ---
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--- Check NULLs or Negative Numbers ---
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

--- Check Data Consistancy & Standrdization in prd_line Column ---
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

--- Check IF End Data IS Larger than Start Date ---
SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


/*************  3) Table crm_sales_details  *************/
--- Check for Incorrect Dates ---  
SELECT NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt = 0 
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101;

SELECT NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt = 0 
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101;

SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt = 0 
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101;

--- Check for Invalid Order Dates ---
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

--- Check Incorrect sales, quantity, price ---
SELECT sls_sales,sls_quantity,sls_price,
	CASE WHEN sls_sales != sls_quantity * ABS(sls_price) OR sls_sales <= 0 OR sls_sales IS NULL 
			THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales2,
	CASE WHEN sls_price <= 0 OR sls_price IS NULL 
			THEN sls_sales / NULLIF(sls_quantity, 0)
		 ELSE sls_price
	END AS sls_price2
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price;


/*************  4) Table erp_cust_az12  *************/
--- Check Birth Date Range ---
SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > GETDATE();

--- Check Data Consistancy & Standrdization ---
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;


/*************  5) Table erp_loc_a101  *************/
--- Check Data Consistancy & Standrdization ---
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;


/*************  6) Table erp_px_cat_g1v7  *************/
--- Check Unwanted Spaces ---
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

--- Check Data Consistancy & Standrdization ---
SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;

