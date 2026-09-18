
----- Load Data From CSV Files Into Tables (Bronze Layer) ----- 

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @bronze_start_time DATETIME, @bronze_end_time DATETIME;
		SET @bronze_start_time = GETDATE();
		PRINT '====================================';
		PRINT 'Loading CRM Tables';
		PRINT '====================================';

		SET @start_time = GETDATE();
		PRINT '>> Inserting Data into Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';


		SET @start_time = GETDATE();
		PRINT 'Inserting Data into Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';


		SET @start_time = GETDATE(); 
		PRINT '>> Inserting Data into Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';


		PRINT '====================================';
		PRINT 'Loading ERP Tables';
		PRINT '====================================';

		SET @start_time = GETDATE();
		PRINT '>> Inserting Data into Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';


		SET @start_time = GETDATE();
		PRINT '>> Inserting Data into Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';


		SET @start_time = GETDATE();
		PRINT '>> Inserting Data into Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Hassnaa\Data Engineering\Data Warehouse Project\Data-Warehouse-SQL-Project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR(10)) + ' seconds';
		PRINT '>> ---------------------';

		SET @bronze_end_time = GETDATE();
		PRINT 'Loading Bronze Layer Completed Successfully';
		PRINT '-- Time Token: ' + CAST(DATEDIFF(second, @bronze_start_time, @bronze_end_time) AS VARCHAR(10)) + ' seconds';
	END TRY

	BEGIN CATCH
		PRINT '====================================';
		PRINT 'ERROR IN LOADING BRONZE LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT '====================================';
		THROW;
	END CATCH

END