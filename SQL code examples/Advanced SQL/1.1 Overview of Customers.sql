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
    address.City,
    state_province.Name State,
    country_region.Name Country,
    address.AddressLine1,
    address.AddressLine2,
  FROM `tc-da-1.adwentureworks_db.countryregion` country_region
  JOIN `tc-da-1.adwentureworks_db.stateprovince` state_province
    ON country_region.CountryRegionCode = state_province.CountryRegionCode
  JOIN `tc-da-1.adwentureworks_db.address` address
    ON state_province.StateProvinceID = address.StateProvinceID
  JOIN `tc-da-1.adwentureworks_db.customeraddress` customer_address 
    ON address.AddressID = customer_address.AddressID
  QUALIFY ROW_NUMBER() OVER 
    (PARTITION BY customer_address.CustomerID ORDER BY address.AddressID DESC) = 1
)
-- Final query, joins with the 2 CTEs above, Customers and SalesOrderHeader
-- which selects all the needed information about customers and their orders
-- Additionally it selects Customers with CustomerType 'I' and retrieves TotalAmountWithTax
-- and LastOrderDate
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

GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
ORDER BY TotalAmountWithTax DESC
LIMIT 200