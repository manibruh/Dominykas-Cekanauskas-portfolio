# Dominykas Čekanauskas — Data Analytics Portfolio

### 1. [Adventure Works – Operations Dashboard (Power BI)](./Adventure%20Works%20-%20Operations%20Dashboard%20in%20Power%20BI%2C%20with%20presentation%20and%20analysis)
An end-to-end operations analysis of the AdventureWorks Cycles dataset, including:
- Star schema data model
- DAX measures for YoY growth using time intelligence functions
- Interactive dashboard: Top N filters, inventory stock-level slicers, conditional formatting
- Business diagnosis of inventory and channel allocation issues, including a demand forecasting model using seasonality indices and a proposed tiered offline/online inventory framework
- Presentation summarizing findings and recommendations

**Files:** `.pbix` dashboard file, presentation/analysis writeup, screenshots

### 2. [SQL Code Examples](./SQL%20code%20examples)
A collection of SQL queries demonstrating progressively advanced techniques:
- Basic querying and aggregation
- Window functions (e.g. ranking, running totals)
- CTEs (Common Table Expressions) for structuring multi-step logic
- Subqueries

**Files:** `.sql` scripts, output screenshots

### 3. [Fast Food Marketing Campaign A/B Test](./AB%20testing%20example%20-%20Fast%20Food%20Marketing%20Campaign)

A statistical comparison of three promotions for a new menu item across 137 stores, to decide which one to roll out chain-wide, including:

- Aggregation of weekly sales to one row per store, so observations are independent
- Pairwise Welch's t-tests implemented entirely in SQL, with 99% confidence intervals
- 99% confidence threshold to control false-positive risk across three comparisons
- Finding: Promotion 1 significantly outperforms Promotion 2 (+$10.8K per store per week); Promotion 1 vs 3 is inconclusive
- Full report and presentation with a rollout recommendation

**Files:** `.sql` scripts, charts, report and presentation links

### 4. [Chess Capture Checker (Python)](link-to-repo)

An interactive Python program that answers one chess question: given 1 white piece and up to 16 black pieces, which black pieces can the white piece capture? Includes:

- Two input modes: manual entry or random generation of a full starting position
- Input validation with clear error messages (unknown pieces, occupied squares, pawns on the first/last rank, duplicate king)
- Capture detection built on the `python-chess` library, correctly handling blocked paths and pawn diagonal captures
- Visual SVG board highlighting capturable pieces and every square the white piece attacks if nothing blocked it
- Runs in Google Colab or VS Code (Jupyter), with a text summary of capturable pieces

**Files:** `.ipynb` notebook, README with usage instructions and screenshot

## Well-known Tools & Skills
`SQL (GoogleSQL / BigQuery)` · `Power BI` · `DAX` · `Google Sheets`

---
*This portfolio is a work in progress and will be updated as I complete new projects.*
