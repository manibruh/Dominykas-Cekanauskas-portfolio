-- Selects all products in a detailed view, including sub-category, ordered by sub-category name
SELECT
  product.ProductID,
  product.Name AS ProductName,
  product.ProductNumber,
  product.Size,
  product.Color,
  product.ProductSubcategoryID,
  productsubcategory.Name AS ProductSubcategoryName
FROM `tc-da-1.adwentureworks_db.product` AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS productsubcategory
  ON product.ProductSubcategoryID = productsubcategory.ProductSubcategoryID
ORDER BY ProductSubcategoryName;