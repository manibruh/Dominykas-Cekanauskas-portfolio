-- Quick query to find find all work orders from January 2004 where actual cost >300
SELECT
  WorkOrderID,
  SUM(ActualCost) actual_cost
FROM `tc-da-1.adwentureworks_db.workorderrouting`
WHERE ActualStartDate >= "2004-01-01"
GROUP BY WorkOrderID
HAVING actual_cost > 300;
