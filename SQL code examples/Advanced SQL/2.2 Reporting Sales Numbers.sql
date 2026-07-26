WITH
-- Selects all orders and retrieves information about the country, region and the sales person
sales_data AS (  
  SELECT 
    sales_order_header.SalesOrderID,
    sales_order_header.CustomerID,
    sales_person.SalesPersonID,
    sales_order_header.OrderDate,
    sales_territory.CountryRegionCode,
    sales_territory.Name Territory,
    sales_order_header.TotalDue
  FROM `tc-da-1.adwentureworks_db.salesorderheader` sales_order_header
  JOIN `tc-da-1.adwentureworks_db.salesterritory` sales_territory
    ON sales_order_header.TerritoryID = sales_territory.TerritoryID
  LEFT JOIN `tc-da-1.adwentureworks_db.salesperson` sales_person
    ON sales_order_header.SalesPersonID = sales_person.SalesPersonID
),
-- Creates a report from sales_data CTE
-- Grouped by each month, country and region
-- Selects number of orders, number of unique customers, number of sales people and Total amount (with tax)
monthly_sales AS (
  SELECT
    FORMAT_DATE('%Y-%m-%d',DATE_TRUNC(sales_data.OrderDate, MONTH)) Order_Month,
    sales_data.CountryRegionCode,
    sales_data.Territory Region,
    COUNT(*) Order_Count,
    COUNT(DISTINCT sales_data.CustomerID) Unique_Customer_Count,
    COUNT(DISTINCT sales_data.SalesPersonID) Unique_SalesPerson_Count,
    ROUND(SUM(sales_data.TotalDue), 2) TotalAmountWithTax
  FROM sales_data
  GROUP BY 1, 2, 3
)
-- Final query, selects everything from monthly_sales CTE and adds cumulative sum
-- Calculated per Country and Region
SELECT *,
 SUM(TotalAmountWithTax) OVER (PARTITION BY Region ORDER BY Order_Month) Cumulative_TotalAmountWithTax
FROM monthly_sales