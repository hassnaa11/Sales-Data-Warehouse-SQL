# Sales Data Warehouse & Analytics Engine

A modern **Data Warehouse** built using **Microsoft SQL Server**, following a **Medallion Architecture (Bronze, Silver, Gold)** to integrate sales, customer, and product data from CRM and ERP source systems.

The project transforms raw source data into a clean, business-ready **Star Schema** that can be used for SQL analytics and BI reporting.

---

## Project Overview

In enterprise environments, business data is often distributed across multiple systems.

* **CRM systems** contain customer and sales information.
* **ERP systems** contain additional customer, product, geographic, and category information.

The pipeline follows three layers as shown in this digram:

<img width="1112" height="600" alt="architecture" src="https://github.com/user-attachments/assets/d0c83431-1ee4-471a-bb13-4f425fd8af6b" />


---

## Business Objectives

### 1. Unified Customer & Product Data

Integrate CRM and ERP records into standardized dimension tables:

* `gold.dim_customers`
* `gold.dim_products`

This creates a centralized view of customers and products.

### 2. Centralized Sales Data

Create a business-ready fact table:

* `gold.fact_sales`

This enables analysis of:

* Sales revenue
* Orders
* Products
* Quantities
* Prices
* Order dates
* Shipping dates
* Due dates

### 3. Business Intelligence

Provide a clean **Star Schema** that can be used for:

* SQL analysis
* Power BI dashboards
* Tableau dashboards
* Ad-hoc business reporting

### 4. Data Quality

Transform raw source data through structured cleansing and validation processes, including:

* Data type conversion
* NULL handling
* Deduplication
* Standardization
* Data validation
* Data integration

---

# Architecture

The project follows the **Medallion Architecture** pattern.

| Layer      | Purpose                                                        | Load Strategy  |
| ---------- | -------------------------------------------------------------- | -------------- |
| **Bronze** | Stores raw CRM and ERP source data with minimal transformation | Full Load      |
| **Silver** | Cleans, standardizes, validates, and transforms raw data       | Full Load      |
| **Gold**   | Provides business-ready fact and dimension tables              | Business-ready |

### Bronze Layer

The Bronze layer contains raw data loaded directly from the source systems.

Main tables include:

```text
bronze.crm_cust_info
bronze.crm_prd_info
bronze.crm_sales_details

bronze.erp_cust_az12
bronze.erp_loc_a101
bronze.erp_px_cat_g12
```

The main purpose of this layer is to preserve the source data before applying transformations.

---

### Silver Layer

The Silver layer transforms the raw Bronze data into clean and standardized datasets.

Typical transformations include:

* Removing duplicates
* Handling NULL values
* Standardizing codes
* Standardizing gender and marital status
* Converting data types
* Validating dates
* Creating derived fields
* Cleaning inconsistent values

---

### Gold Layer

The Gold layer contains business-ready tables designed for analytical workloads.

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

These tables form the final **Star Schema**.

---

# Data Flow

Data flows from CRM and ERP source systems through the Bronze (raw), Silver (cleaned), and Gold (integrated) layers, resulting in business-ready fact_sales, dim_customers, and dim_products tables.

<img width="882" height="490" alt="data_flow" src="https://github.com/user-attachments/assets/2f0accc9-8cd9-4abd-9494-d69c226e30d3" />


---

# Data Model — Star Schema

The Gold layer uses a **Star Schema** consisting of one central fact table and two dimension tables.

<img width="902" height="462" alt="data_model" src="https://github.com/user-attachments/assets/b8ee9877-daa5-4d95-a9b2-1a5ca3c0514e" />


---

# Data Dictionary

## `gold.fact_sales`

The central transactional fact table containing sales information.

| Column         | Description                                      |
| -------------- | ------------------------------------------------ |
| `order_number` | Unique sales order identifier                    |
| `product_key`  | Surrogate key referencing the product dimension  |
| `customer_key` | Surrogate key referencing the customer dimension |
| `order_date`   | Date when the order was placed                   |
| `ship_date`    | Date when the order was shipped                  |
| `due_date`     | Expected fulfillment date                        |
| `sales_amount` | Sales amount                                     |
| `quantity`     | Quantity sold                                    |
| `price`        | Product selling price                            |

---

## `gold.dim_customers`

Contains consolidated customer information from CRM and ERP sources.

| Column            | Description                   |
| ----------------- | ----------------------------- |
| `customer_key`    | Surrogate key                 |
| `customer_id`     | Customer identifier           |
| `customer_number` | Customer business/natural key |
| `first_name`      | Customer first name           |
| `last_name`       | Customer last name            |
| `country`         | Customer country              |
| `marital_status`  | Standardized marital status   |
| `gender`          | Standardized gender           |
| `birthdate`       | Customer date of birth        |

---

## `gold.dim_products`

Contains consolidated product and category information.

| Column           | Description                     |
| ---------------- | ------------------------------- |
| `product_key`    | Surrogate key                   |
| `product_id`     | Product identifier              |
| `product_number` | Product business/natural key    |
| `product_name`   | Product name                    |
| `category_id`    | Product category identifier     |
| `category`       | Product category                |
| `subcategory`    | Product subcategory             |
| `cost`           | Product cost                    |
| `maintenance`    | Product maintenance information |
| `product_line`   | Product line classification     |


---

# Setup & Execution

## Prerequisites

Before running the project, make sure you have:

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* CRM and ERP source datasets
* Basic knowledge of SQL

---

## 1. Clone the Repository

```bash
git clone https://github.com/hassnaa11/Sales-Data-Warehouse-SQL.git
```

Navigate to the project directory:

```bash
cd Sales-Data-Warehouse-SQL
```

---

## 2. Open the Project in SSMS

Open **SQL Server Management Studio (SSMS)** and connect to your SQL Server instance.

---

## 3. Initialize the Database

Run:

```text
scripts/database_initializtion.sql
```

This creates the database and required schemas:

```text
bronze
silver
gold
```

---

## 4. Load the Bronze Layer

Run:

```text
scripts/bronze/bronze_ddl.sql
scripts/bronze/bronze_data_loading.sql
```

This creates the raw Bronze tables and loads the CRM and ERP source data.

---

## 5. Load the Silver Layer

Run:

```text
scripts/silver/silver_ddl.sql
scripts/silver/silver_data_loading.sql
```

The Silver layer performs the required data cleansing and transformation processes.

---

## 6. Build the Gold Layer

Run:

```text
scripts/gold/gold_ddl.sql
```

This creates the business-ready analytical model:

```text
gold.dim_customers
gold.dim_products
gold.fact_sales
```

---

## 7. Run Data Quality Checks

Run:

```text
tests/check_quality_silver.sql
tests/check_quality_gold.sql
```

The validation scripts check areas such as:

* Primary key uniqueness
* Duplicate records
* NULL values
* Foreign key relationships
* Data consistency

---

# Data Quality & Validation

Data quality checks are applied throughout the transformation pipeline.

Key validation areas include:

```text
✓ Primary Key Uniqueness
✓ Duplicate Detection
✓ NULL Value Checks
✓ Data Type Validation
✓ Foreign Key Integrity
✓ Standardization Checks
```

These checks help ensure that the Gold layer contains reliable and consistent data for analytical use.
