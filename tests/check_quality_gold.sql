
--- Check The Quality of Gold Layer ---

-- Check Duplicates in gold.dim_customers Table
SELECT customer_key, COUNT(*)
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- Check Duplicates in gold.dim_products Table
SELECT product_key, COUNT(*)
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL; 


