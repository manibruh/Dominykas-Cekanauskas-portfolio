# Fast Food Marketing Campaign A/B Test

## Overview

A fast-food chain is testing three marketing promotions for a new menu item and needs to decide which one to roll out chain-wide. This project analyzes weekly sales data from 137 store locations, each running one of three promotions for four weeks, to determine whether any promotion drives significantly higher sales than the others.
 
## Dataset
 
Source: [IBM Watson Analytics Marketing Campaign dataset](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test) (548 rows, no missing values), covering 137 stores across 10 markets.
 
| Column | Description |
|---|---|
| market_id | Market identifier |
| market_siza | Small / Medium / Large |
| location_id | Store identifier |
| age_of_store | Age of store in years |
| promotion | Promotion assigned to the store (1, 2, or 3) |
| week | Week number (1–4) |
| sales_in_thousands | Weekly sales of the new item, in thousands |
 
Each store ran only one promotion for all four weeks, so the data is aggregated to one row per store before any statistical testing.
 
## Approach
 
- **Aggregation:** weekly rows are collapsed to one row per store (137 independent observations) by averaging each store's weekly sales, since the four weekly readings from the same store are not independent.
- **Pairwise comparisons:** with three promotions, every pair (1 vs 2, 1 vs 3, 2 vs 3) is tested separately using Welch's t-test, which does not assume equal variance between groups.
- **Confidence level:** a 99% confidence threshold is used (rather than the conventional 95%) to control the overall false-positive risk introduced by running three comparisons.
- **Tooling:** the aggregation and statistical tests are implemented in SQL, run against the dataset in BigQuery.
## Contents
 
This repository includes the SQL used to aggregate the data and run the pairwise significance tests, along with the resulting analysis, visualizations, and final recommendation on which promotion to adopt.

Full report of the Analysis: [Google Docs](https://docs.google.com/document/d/1aa9Wedio68aX0ceqxFpEGwvnHES6A5XG2IqOiyiYZdU/edit?usp=sharing)

Presentation that will be used to present the entire test and results: [Google Slides](https://docs.google.com/presentation/d/1Kl-G_qwkpz5JeWy7f0vH51810c1LaEWRF0Wv8fc71Dk/edit?usp=sharing)
