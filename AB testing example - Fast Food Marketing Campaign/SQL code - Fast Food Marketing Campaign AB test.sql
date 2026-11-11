WITH 
-- Collapses weekly rows into one row per store
store_sales AS ( 
  SELECT
   location_id,
   promotion,
   AVG(sales_in_thousands) avg_sales
  FROM `tc-da-1.turing_data_analytics.wa_marketing_campaign`
  GROUP BY location_id, promotion
),
-- For each promotion, gets the sample size, mean, and variance
-- of store-level sales. These are needed for a t-test per group
promotion_statistics AS (
  SELECT
    promotion,
    COUNT(*) n,
    ROUND(AVG(avg_sales), 3) mean_sales,
    ROUND(VAR_SAMP(avg_sales), 3) var,
  FROM store_sales
  GROUP BY promotion
  ORDER BY promotion
),
-- Builds every unique pair of promotions (1-2, 1-3, 2-3)
-- and calculates for each pair:
-- diff = difference in mean sales
-- se   = standard error of that difference (how much it could wobble)
-- df   = degrees of freedom, needed because the two groups can have different variances
pairs AS (
  SELECT
    a.promotion promo_a,
    b.promotion promo_b,
    a.mean_sales - b.mean_sales diff,
    SQRT(a.var / a.n + b.var / b.n) se,
    POW(a.var / a.n + b.var / b.n, 2) /
      (POW(a.var / a.n, 2) / (a.n - 1) + POW(b.var / b.n, 2) / (b.n - 1)) df
  FROM promotion_statistics a
  JOIN promotion_statistics b ON a.promotion < b.promotion
)
-- Turns each pairs numbers into a test result
-- t_stat         = how many standard errors apart the means are
-- ci99_low/high  = 99% confidence interval for the true difference
-- 2.63           = hardcoded critical value for ~88 df, two tailed, 99%
-- significant_99 = TRUE if the interval excludes 0
--                  i.e. the diffrence is unlikely due to chance
SELECT
  promo_a,
  promo_b,
  ROUND(diff, 3) mean_diff,
  ROUND(diff / se, 3) t_stat,
  ROUND(df, 1) degrees_of_freeedom,
  ROUND(diff - 2.63 * se, 3) ci99_low,
  ROUND(diff + 2.63 * se, 3) ci99_high,
  ABS(diff / se) > 2.63 signigicant_99
FROM pairs
ORDER BY promo_a, promo_b