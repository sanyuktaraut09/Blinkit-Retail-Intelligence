-- Total number of records
SELECT COUNT(*)
FROM blinkit_sales;

-- View first 5 rows
SELECT *
FROM blinkit_sales
LIMIT 5;

-- Total Sales
SELECT
ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales;

-- Average Sales
SELECT
ROUND(AVG(Sales),2) AS Avg_Sales
FROM blinkit_sales;

-- Top Selling Categories
SELECT
`Item Type`,
ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Item Type`
ORDER BY Total_Sales DESC;

-- Top 10 Outlets
SELECT
`Outlet Identifier`,
ROUND(SUM(Sales),2) AS Total_Sales
FROM blinkit_sales
GROUP BY `Outlet Identifier`
ORDER BY Total_Sales DESC
LIMIT 10;