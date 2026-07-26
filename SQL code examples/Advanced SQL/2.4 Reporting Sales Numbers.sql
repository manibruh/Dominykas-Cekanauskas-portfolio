WITH
-- Selects all orders and retrieves information about the country, region and the sales person
sales_data AS (  
  SELECT 
    sales_order_header.SalesOrderID,
    sales_order_header.CustomerID,
    sales_person.SalesPersonID,
    sales_order_header.OrderDate,
    sales_order_header.TerritoryID,
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
    sales_data.TerritoryID,
    sales_data.CountryRegionCode,
    sales_data.Territory Region,
    COUNT(*) Order_Count,
    COUNT(DISTINCT sales_data.CustomerID) Unique_Customer_Count,
    COUNT(DISTINCT sales_data.SalesPersonID) Unique_SalesPerson_Count,
    ROUND(SUM(sales_data.TotalDue), 2) TotalAmountWithTax
  FROM sales_data
  GROUP BY 1, 2, 3, 4
),
-- calculated mean (average tax rate per country) and
-- percentage of provinces with available tax data for each country
mean_per_country AS (
  SELECT 
    all_provinces.CountryRegionCode,
    AVG(max_tax_rate_per_state.Max_Tax_Rate) Mean_Tax_Rate,
    COUNT(DISTINCT max_tax_rate_per_state.StateProvinceID) / COUNT(DISTINCT all_provinces.StateProvinceID) 
      Perc_Provinces_W_Tax
  FROM `tc-da-1.adwentureworks_db.stateprovince` all_provinces
  LEFT JOIN (
    SELECT
      sales_tax_rate.StateProvinceID,
      MAX(sales_tax_rate.TaxRate) Max_Tax_Rate
    FROM `tc-da-1.adwentureworks_db.salestaxrate` sales_tax_rate
    GROUP BY 1
  ) max_tax_rate_per_state
    ON all_provinces.StateProvinceID = max_tax_rate_per_state.StateProvinceID
  GROUP BY 1
)
-- Final query, selects only the needed columns from monthly_sales CTE + Mean_Tax_Rate and Perc_Provinces_W_Tax from mean_per_country CTE
-- and adds cumulative sum, calculated per Country and Region, additionally new column sales_rank was added
-- Ranked by TotalAmountWithTax and filtered US Country
SELECT 
  monthly_sales.Order_Month,
  monthly_sales.CountryRegionCode,
  monthly_sales.Region,
  monthly_sales.Order_Count,
  monthly_sales.Unique_Customer_Count,
  monthly_sales.Unique_SalesPerson_Count,
  monthly_sales.TotalAmountWithTax,
  RANK() OVER (PARTITION BY Region ORDER BY TotalAmountWithTax DESC) Country_Sales_Rank,
  SUM(TotalAmountWithTax) OVER (PARTITION BY Region ORDER BY Order_Month) Cumulative_TotalAmountWithTax,
  ROUND(mean_per_country.Mean_Tax_Rate, 2) Mean_Tax_Rate,
  ROUND(mean_per_country.Perc_Provinces_W_Tax, 3) Perc_Provinces_W_Tax
FROM monthly_sales
JOIN mean_per_country
  ON monthly_sales.CountryRegionCode = mean_per_country.CountryRegionCode
WHERE monthly_sales.CountryRegionCode = 'US'
ORDER BY monthly_sales.TotalAmountWithTax DESC