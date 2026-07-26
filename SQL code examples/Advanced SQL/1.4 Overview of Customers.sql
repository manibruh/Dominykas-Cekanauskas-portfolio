WITH 
-- Joins Contact and Individual tables to select names and contact details for each customer
-- Additionally separates First and Last names to 2 additional columns
customer_contact_info AS (
  SELECT 
    individual.CustomerID,
    contact.ContactID,
    contact.FirstName,
    contact.LastName,
    CONCAT(contact.FirstName, ' ', contact.LastName) FullName,
    CASE WHEN contact.Title IS NULL 
      THEN CONCAT('Dear ', contact.LastName)
      ELSE CONCAT(contact.Title, ' ', contact.LastName) END Adressing_Title,
    contact.EmailAddress,
    contact.Phone
  FROM `tc-da-1.adwentureworks_db.contact` contact
  JOIN `tc-da-1.adwentureworks_db.individual` individual
    ON contact.ContactId = individual.ContactId
),
-- Joins CountryRegion, StateProvince and Address tables
-- to select address details for each customer
-- Additionally removes duplicate addresses, which were old
customer_address_info AS (
  SELECT 
    customer_address.CustomerID,
    latest_address.City,
    state_province.Name State,
    country_region.Name Country,
    latest_address.AddressLine1,
    latest_address.Address_No,
    latest_address.Address_St,
    latest_address.AddressLine2,
  FROM `tc-da-1.adwentureworks_db.countryregion` country_region
  JOIN `tc-da-1.adwentureworks_db.stateprovince` state_province
    ON country_region.CountryRegionCode = state_province.CountryRegionCode
  JOIN (
    SELECT 
      address.AddressLine1,
      LEFT(address.AddressLine1, STRPOS(address.AddressLine1, ' ')) Address_No,
      SUBSTR(address.AddressLine1, STRPOS(address.AddressLine1, ' ')+1) Address_St,
      address.AddressLine2,
      address.City,
      address.StateProvinceID,
      address.AddressID
  FROM `tc-da-1.adwentureworks_db.address` address
  ) latest_address
    ON state_province.StateProvinceID = latest_address.StateProvinceID
  JOIN `tc-da-1.adwentureworks_db.customeraddress` customer_address 
    ON latest_address.AddressID = customer_address.AddressID
  QUALIFY ROW_NUMBER() OVER 
    (PARTITION BY customer_address.CustomerID ORDER BY latest_address.AddressID DESC) = 1

),
-- Top Customers, joins with the 2 CTEs above, Customers and SalesOrderHeader
-- which selects all the needed information about customers and their orders
-- Additionally it selects Customers with CustomerType 'I' and retrieves TotalAmountWithTax
-- and LastOrderDate
top_customers AS ( 
  SELECT
    customer.CustomerID,
    customer_contact_info.* EXCEPT(CustomerID, ContactID),
    customer.AccountNumber,
    customer.CustomerType,
    customer_address_info.* EXCEPT(CustomerID),
    COUNT(sales_order_header.SalesOrderID) Order_Count,
    ROUND(SUM(sales_order_header.TotalDue), 3) TotalAmountWithTax,
    MAX(sales_order_header.OrderDate) LastOrderDate
  FROM 
    (SELECT * FROM`tc-da-1.adwentureworks_db.customer` WHERE CustomerType = 'I') customer
  JOIN customer_contact_info
    ON customer.customerID = customer_contact_info.CustomerID
  JOIN customer_address_info
    ON customer.customerID = customer_address_info.CustomerID
  JOIN `tc-da-1.adwentureworks_db.salesorderheader` sales_order_header
    ON customer.CustomerID = sales_order_header.CustomerID
  GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
),
-- Checks and selects the most recent order out of all of customers
latest_top_customers AS (
  SELECT *, 
    (SELECT MAX(top_customers.LastOrderDate) FROM top_customers) AS recent_order
  FROM top_customers
)
-- Final query, selects all active cutomers from North America, which either have:
-- TotalAmountWithTax is no less than 2500 OR they have placed 5 or more orders
-- Additionally, AddressLine1 is split into two columns - Address_No and Address_St
SELECT 
  latest_top_customers.*,
  CASE WHEN latest_top_customers.LastOrderDate >= recent_order - INTERVAL 365 DAY
    THEN 'Active'
    ELSE 'Inactive' END Customer_Status
FROM latest_top_customers
WHERE 
  (CASE WHEN latest_top_customers.LastOrderDate >= recent_order - INTERVAL 365 DAY
    THEN 'Active'
    ELSE 'Inactive' END) = 'Active' AND
  latest_top_customers.Country IN ('United States', 'Canada') AND
  (latest_top_customers.TotalAmountWithTax > 2500 OR latest_top_customers.Order_Count >= 5)
ORDER BY latest_top_customers.Country, latest_top_customers.State, latest_top_customers.LastOrderDate
