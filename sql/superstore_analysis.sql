/* =====================================================
   Superstore Sales Analysis
   Tools: PostgreSQL
   Dataset: Superstore Retail Dataset
   Analyst: Hamzah Alsalmi
   ===================================================== */


/* =====================================================
   1. DATA TRANSFORMATION
   Convert raw CSV fields into clean SQL columns
   ===================================================== */

CREATE TABLE superstore AS
SELECT
    "Row ID" AS row_id,
    "Order ID" AS order_id,
    TO_DATE("Order Date", 'DD/MM/YYYY') AS order_date,
    TO_DATE("Ship Date", 'DD/MM/YYYY') AS ship_date,
    "Ship Mode" AS ship_mode,
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    "Segment" AS segment,
    "Country" AS country,
    "City" AS city,
    "State" AS state,
    "Postal Code" AS postal_code,
    "Region" AS region,
    "Product ID" AS product_id,
    "Category" AS category,
    "Sub-Category" AS sub_category,
    "Product Name" AS product_name,
    "Sales" AS sales
FROM superstore_raw;


/* =====================================================
   2. KPI SUMMARY
   ===================================================== */

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM superstore;


/* =====================================================
   3. SALES BY CATEGORY
   ===================================================== */

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;


/* =====================================================
   4. SALES BY REGION
   ===================================================== */

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;


/* =====================================================
   5. SALES BY CUSTOMER SEGMENT
   ===================================================== */

SELECT
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;


/* =====================================================
   6. TOP 10 PRODUCTS BY REVENUE
   ===================================================== */

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_revenue
FROM superstore
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;


/* =====================================================
   7. TOP 10 CUSTOMERS BY SPENDING
   ===================================================== */

SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_spent
FROM superstore
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;


/* =====================================================
   8. MONTHLY SALES TREND
   ===================================================== */

SELECT
    DATE_TRUNC('month', order_date)::date AS month,
    ROUND(SUM(sales), 2) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;


/* =====================================================
   9. SHIPPING PERFORMANCE
   ===================================================== */

SELECT
    ship_mode,
    ROUND(AVG(ship_date - order_date), 2) AS avg_shipping_days
FROM superstore
GROUP BY ship_mode
ORDER BY avg_shipping_days;


/* =====================================================
   10. RANK CUSTOMERS BY SPENDING
   Demonstrates window functions
   ===================================================== */

SELECT
    customer_name,
    ROUND(SUM(sales),2) AS total_spent,
    RANK() OVER (ORDER BY SUM(sales) DESC) AS customer_rank
FROM superstore
GROUP BY customer_name
LIMIT 15;


/* =====================================================
   11. TOP PRODUCT WITHIN EACH CATEGORY
   ===================================================== */

SELECT *
FROM (
    SELECT
        category,
        product_name,
        SUM(sales) AS revenue,
        RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS rank
    FROM superstore
    GROUP BY category, product_name
) ranked
WHERE rank = 1;


/* =====================================================
   12. YEARLY SALES TREND
   ===================================================== */

SELECT
    DATE_TRUNC('year', order_date) AS year,
    ROUND(SUM(sales),2) AS yearly_sales
FROM superstore
GROUP BY year
ORDER BY year;


/* =====================================================
   13. AVERAGE ORDER VALUE BY SEGMENT
   ===================================================== */

SELECT
    segment,
    ROUND(SUM(sales)/COUNT(DISTINCT order_id),2) AS avg_order_value
FROM superstore
GROUP BY segment
ORDER BY avg_order_value DESC;