--Each locations unique work orders, unique products and total costs for each location
--Includes location names and average number of days between start and end dates of orders
SELECT
  wor.LocationID location_id,
  location.Name location,
  COUNT(DISTINCT wor.WorkOrderID) work_orders, 
  COUNT(DISTINCT wor.ProductID) unique_products, 
  SUM(wor.ActualCost) actual_cost,
  ROUND(AVG(DATE_DIFF(wor.ActualEndDate, wor.ActualStartDate, DAY)), 2) avg_days_diff
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS wor
JOIN `tc-da-1.adwentureworks_db.location` AS location
  ON wor.LocationID = location.LocationID
WHERE wor.ActualStartDate >= "2004-01-01" AND wor.ActualStartDate <="2004-01-31"
GROUP BY location_id, location
ORDER BY actual_cost DESC;