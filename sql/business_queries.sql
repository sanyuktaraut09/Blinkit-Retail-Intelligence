-- ==========================================================
-- Blinkit Retail Intelligence
-- Business SQL Queries
-- Database : blinkit_db
-- Table    : blinkit_sales
-- ==========================================================

USE blinkit_db;

-- ==========================================================
-- 1. OVERALL BUSINESS KPIs
-- ==========================================================

-- Total Sales
SELECT SUM(Sales) AS Total_Sales
FROM blinkit_sales;

-- Average Sales
SELECT ROUND(AVG(Sales),2) AS Average_Sales
FROM blinkit_sales;

-- Total Orders
SELECT COUNT(*) AS Total_Orders
FROM blinkit_sales;

-- Average Customer Rating
SELECT ROUND(AVG(Rating),2) AS Average_Rating
FROM blinkit_sales;


-- ==========================================================
-- 2. PRODUCT CATEGORY ANALYSIS
-- ==========================================================

-- Sales by Item Category
SELECT
    `Item Type`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Item Type`
ORDER BY Total_Sales DESC;

-- Average Rating by Item Category
SELECT
    `Item Type`,
    ROUND(AVG(Rating),2) AS Average_Rating
FROM blinkit_sales
GROUP BY `Item Type`
ORDER BY Average_Rating DESC;

-- Top 5 Selling Categories
SELECT
    `Item Type`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Item Type`
ORDER BY Total_Sales DESC
LIMIT 5;


-- ==========================================================
-- 3. OUTLET ANALYSIS
-- ==========================================================

-- Sales by Outlet Type
SELECT
    `Outlet Type`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Type`
ORDER BY Total_Sales DESC;

-- Sales by Outlet Size
SELECT
    `Outlet Size`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Size`
ORDER BY Total_Sales DESC;

-- Sales by Outlet Location
SELECT
    `Outlet Location Type`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Location Type`
ORDER BY Total_Sales DESC;


-- ==========================================================
-- 4. OUTLET PERFORMANCE
-- ==========================================================

-- Best Performing Outlet
SELECT
    `Outlet Identifier`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Identifier`
ORDER BY Total_Sales DESC
LIMIT 1;

-- Lowest Performing Outlet
SELECT
    `Outlet Identifier`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Identifier`
ORDER BY Total_Sales ASC
LIMIT 1;

-- Highest Rated Outlet
SELECT
    `Outlet Identifier`,
    ROUND(AVG(Rating),2) AS Average_Rating
FROM blinkit_sales
GROUP BY `Outlet Identifier`
ORDER BY Average_Rating DESC
LIMIT 1;


-- ==========================================================
-- 5. ADVANCED BUSINESS ANALYSIS
-- ==========================================================

-- Rank Categories by Sales
SELECT
    `Item Type`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM blinkit_sales
GROUP BY `Item Type`;

-- Sales Contribution (%)
SELECT
    `Item Type`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(
        (SUM(Sales) /
        (SELECT SUM(Sales) FROM blinkit_sales))*100,
        2
    ) AS Sales_Percentage
FROM blinkit_sales
GROUP BY `Item Type`
ORDER BY Total_Sales DESC;

-- Running Sales Trend by Year
SELECT
    `Outlet Establishment Year`,
    SUM(Sales) AS Yearly_Sales,
    SUM(SUM(Sales)) OVER(
        ORDER BY `Outlet Establishment Year`
    ) AS Running_Total
FROM blinkit_sales
GROUP BY `Outlet Establishment Year`
ORDER BY `Outlet Establishment Year`;