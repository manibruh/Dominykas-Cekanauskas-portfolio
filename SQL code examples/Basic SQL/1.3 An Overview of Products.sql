-- Selects active sales of bikes that have a list price greater than 2000 in a detailed view
-- including category, sub-category and list price, ordered by lisp price descending
SELECT
  product.ProductID,
  product.Name AS ProductName,
  product.ProductNumber,
  product.Size,
  product.Color,
  product.ProductSubcategoryID,
  productsubcategory.Name AS ProductSubcategoryName,
  productcategory.Name AS ProductCategoryName,
  product.ListPrice AS ListPrice
FROM `tc-da-1.adwentureworks_db.product` AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS productsubcategory
  ON product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS productcategory
  ON productsubcategory.ProductCategoryID = productcategory.ProductCategoryID
WHERE productcategory.Name = "Bikes" AND product.ListPrice >= 2000 
  AND SellEndDate IS NULL
ORDER BY ListPrice DESC;