-- Analyzing WorkOrderRouting table, this includes for each location:
-- unique work orders, total number of unique products and total cost in January 2004
SELECT
  wor.LocationID location_id,
  COUNT(DISTINCT wor.WorkOrderID) work_orders, 
  COUNT(DISTINCT wor.ProductID) unique_products, 
  SUM(wor.ActualCost) actual_cost
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS wor
WHERE wor.ActualStartDate >= "2004-01-01" AND wor.ActualStartDate <="2004-01-31"
GROUP BY location_id
ORDER BY actual_cost DESC;