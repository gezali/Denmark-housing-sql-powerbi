# 🏠 Danish Housing Market Analysis

An end-to-end data analytics project: cleaning Danish housing sales data in **SQL Server** and building an interactive, three-page **Power BI** report on prices, sales performance and house-type trends across Denmark's regions.

## 🖼 Dashboard Preview

### Housing Market Overview
![Housing Market Overview](Screenshot%202026-11-05%20193851.png)

### Sales Performance
![Sales Performance](Screenshot%202026-11-05%20194156.png)

### House Type Analysis
![House Type Analysis](Screenshot%202026-11-05%20194213.png)

---

## 📌 Table of Contents
1. [Dashboard Preview](#-dashboard-preview)
2. [Project Overview](#-project-overview)
3. [Tools & Technologies](#-tools--technologies)
4. [Repository Structure](#-repository-structure)
5. [Dataset](#-dataset)
6. [Data Processing Steps](#-data-processing-steps)
7. [Dashboard](#-dashboard)
8. [Key Insights](#-key-insights)
9. [How to Reproduce](#-how-to-reproduce)
10. [Author](#-author)

---

## 📖 Project Overview

The goal of this project is to understand how the Danish housing market behaves across regions, sales types and house types. The workflow:

**Raw CSV → SQL Server (load + clean) → Power BI (model + visualise) → Insights**

Questions answered by the dashboards:
- Which regions are growing fastest in median sales price?
- How do offer prices compare with final purchase prices?
- Which regions generate the most sales value?
- How do sales types (regular, auction, family, other) differ in growth and price per sqm?
- How do inflation, interest rate and mortgage bond yield vary by house type?
- What do size (sqm) and price per sqm look like for each house type?

---

## 🛠 Tools & Technologies

| Tool | Purpose |
|------|---------|
| SQL Server (SSMS) | Data loading, null handling, cleaning |
| Power BI Desktop | Data modelling, DAX measures, dashboards |
| DAX | Calculated measures (YTD sales, YoY growth, price per sqm, etc.) |
| CSV | Source data format |

---

## 📁 Repository Structure

```
Danish-Housing/
│
├── Housing_Data.csv        # Raw dataset (~100,000 records)
├── Housing_Data.sql        # SQL cleaning script
├── Danish_Housing.pbix     # Power BI report
├── images/
│   ├── housing_market_overview.png
│   ├── sales_performance.png
│   └── house_type_analysis.png
└── README.md
```

---

## 🗂 Dataset

**File:** `Housing_Data.csv` — roughly 100,000 housing sales records.

| Column | Description |
|--------|-------------|
| `date`, `quarter` | Date of sale and quarter (e.g. 2024Q4) |
| `house_id` | Identifier of the property record |
| `house_type` | Villa, Apartment, Townhouse, Summerhouse, Farm |
| `sales_type` | regular_sale, auction, family_sale, other_sale |
| `year_build` | Year the property was built |
| `purchase_price` | Final purchase price |
| `%_change_between_offer_and_purchase` | Percentage difference between offer and purchase price |
| `no_rooms`, `sqm` | Number of rooms and size in square metres |
| `sqm_price` | Price per square metre |
| `address`, `zip_code`, `city` | Location details |
| `area`, `region` | Sub-area (e.g. North Zealand) and region (Zealand, Jutland, Fyn & islands, Bornholm) |
| `nom_interest_rate%` | Nominal interest rate |
| `dk_ann_infl_rate%` | Danish annual inflation rate |
| `yield_on_mortgage_credit_bonds%` | Yield on mortgage credit bonds |

---

## 🧹 Data Processing Steps

### 1. Data Loading
1. Created a dedicated database in SQL Server:
   ```sql
   CREATE DATABASE House;
   USE House;
   ```
2. Imported `Housing_Data.csv` into a table named `Housing_Data` using the **SQL Server Import and Export Wizard** (Flat File Source).

### 2. Data Exploration
Inspected the table and checked distinct values and nulls in the columns that looked incomplete:
```sql
SELECT * FROM Housing_Data;

SELECT DISTINCT dk_ann_infl_rate FROM Housing_Data;
SELECT DISTINCT city, house_id FROM Housing_Data WHERE city IS NULL;
SELECT city, house_id FROM Housing_Data WHERE house_id = 173270;
```

### 3. Data Cleaning

**a) Missing `city` values** – null cities were filled with a placeholder value:
```sql
UPDATE Housing_Data SET city = 'Arsted' WHERE city IS NULL;
```

**b) Missing inflation rate (`dk_ann_infl_rate`)** – nulls were replaced with a default value (the column's most recent/maximum value was checked first):
```sql
SELECT MAX(dk_ann_infl_rate) FROM Housing_Data;

UPDATE Housing_Data
SET dk_ann_infl_rate = '07:07:00.0000000'
WHERE dk_ann_infl_rate IS NULL;
```

**c) Missing mortgage bond yield (`yield_on_mortgage_credit_bonds`)** – nulls were filled the same way:
```sql
UPDATE Housing_Data
SET yield_on_mortgage_credit_bonds = '10:14:00.0000000'
WHERE yield_on_mortgage_credit_bonds IS NULL;
```

**d) Final null check** across the table, including `house_type`:
```sql
SELECT * FROM Housing_Data;
SELECT DISTINCT house_type FROM Housing_Data WHERE house_type IS NULL;
```

> ⚠️ **Note on data types:** the replacement values above (`07:07:00.0000000`, `10:14:00.0000000`) are in `TIME` format, which means the import wizard read these two columns as `time` instead of decimals (e.g. 7.07 and 10.14). If you re-run this project, consider setting these columns to `DECIMAL(5,2)` during import so the rates can be aggregated correctly in Power BI.

### 4. Data Preprocessing in Power BI
- Connected Power BI Desktop to the cleaned `House` database (SQL Server connector).
- Reviewed column data types in **Power Query** (dates, whole numbers, decimals, text).
- Verified there were no remaining nulls or duplicate records in key columns.
- Created a **Date table** for time intelligence (Year, Quarter, Month, Day) to support YTD and YoY calculations.
- Built relationships between the fact table and the date table.

### 5. DAX Measures
Measures created for the dashboards include (see `Danish_Housing.pbix` for exact definitions):
- Total YTD Sales
- YoY Sales Growth by Sales Type
- Median Sales Price Change by Region
- Units Sold (latest year & quarter) and 12-Month Sales
- Offer Price vs Purchase Price
- Offer to SQM Ratio and Average SQM Price

---

## 📊 Dashboard

The Power BI report contains three pages.

### Page 1 – Housing Market Overview
High-level KPIs and trends: median sales price change by region, units sold in the latest quarter, 12-month sales value, offer vs purchase price scatter plot, and YoY sales growth by sales type.

### Page 2 – Sales Performance
Regional sales funnel, a **Key Influencers** AI visual for what drives purchase price, a YTD sales table, offer-to-sqm ratio by sales type, and average price per sqm by region.

### Page 3 – House Type Analysis
Interactive slicers (Area, City, Sales Type, Region) driving three charts: average offer/purchase price by house type, average inflation/interest/yield by house type, and average sqm vs sqm price by house type.

---

## 🔍 Key Insights

- **Regional growth:** Jutland shows the strongest median sales price growth (+0.053), followed by Fyn & islands (+0.031) and Zealand (+0.024), while Bornholm declined (−0.050).
- **Sales by region:** Zealand (≈95bn) and Jutland (≈81bn) dominate total sales value; Fyn & islands contributes ≈15bn and Bornholm ≈1bn.
- **Price per sqm:** Zealand is the most expensive region (≈20.85K avg per sqm, ~35.6% share), while Bornholm is the cheapest (≈10.6K).
- **Sales type:** Auctions grew the most year over year (+0.29), while family sales fell sharply (−0.75). Regular sales have the highest offer-to-sqm ratio (≈14.9K).
- **Offer vs purchase price:** Offer and purchase prices track each other very closely, with only a few outliers.
- **House types:** Farms have the highest average price (≈2.7M) and the largest size, but Apartments have the highest price per sqm (≈28.7K) while Villas have the lowest (≈11.9K).

---

## ▶️ How to Reproduce

1. Clone this repository.
2. Open SQL Server Management Studio and import `Housing_Data.csv` into a database named `House` (table `Housing_Data`).
3. Run `Housing_Data.sql` to clean the data.
4. Open `Danish_Housing.pbix` in Power BI Desktop and update the data source to point to your SQL Server instance.
5. Click **Refresh** to load the data and explore the dashboards.

---

## 👤 Author

**Zakariya Gezali**
Aspiring Data Analyst — SQL | Power BI | Excel | Python | Tableau
GitHub: [@gezali](https://github.com/gezali)

---

⭐ If you found this project useful, feel free to star the repository!
