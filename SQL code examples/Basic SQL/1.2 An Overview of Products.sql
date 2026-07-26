-- Selects all products in a detailed view, including category and sub-category, ordered by category name
SELECT
  product.ProductID,
  product.Name AS ProductName,
  product.ProductNumber,
  product.Size,
  product.Color,
  product.ProductSubcategoryID,
  productsubcategory.Name AS ProductSubcategoryName,
  productcategory.Name AS ProductCategoryName
FROM `tc-da-1.adwentureworks_db.product` AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS productsubcategory
  ON product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS productcategory
  ON productsubcategory.ProductCategoryID = productcategory.ProductCategoryID
ORDER BY ProductCategoryName;