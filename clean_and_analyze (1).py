"""
Oil & Gas Production & Asset Performance Analytics
Step 1: Data cleaning and basic analysis using Pandas
Data source: oil_production_statistics.csv (user-provided, OECD-style oil
statistics - production, deliveries, consumption pattern, storage - for
36 countries, 2021-2023).
"""

import pandas as pd

# 1. Load data
# Note: file uses latin1 encoding, not utf-8 (has special characters e.g. "Türkiye")
df = pd.read_csv("oil_production_statistics.csv", encoding="latin1")

# 2. Look at the data
print("First 5 rows:")
print(df.head())

print("\nColumn info:")
print(df.info())

print("\nUnique products:", df["product"].unique())
print("Unique flows:", df["flow"].unique())
print("Years covered:", sorted(df["year"].unique()))
print("Number of countries:", df["country_name"].nunique())

# 3. Check missing values
print("\nMissing values per column:")
print(df.isnull().sum())
# This dataset has no missing values - good, one less step needed.

# 4. Check and remove duplicate rows
print("\nDuplicate rows found:", df.duplicated().sum())
df = df.drop_duplicates()
print("Rows after removing duplicates:", len(df))

# 5. Basic groupby analysis

# Focus on "Crude oil" + "Industrial Production" as the core production metric
production = df[(df["product"] == "Crude oil") & (df["flow"] == "Industrial Production")]

print("\nTotal crude oil industrial production by country (2021-2023 summed):")
print(production.groupby("country_name")["value"].sum().sort_values(ascending=False).head(10))

print("\nTotal crude oil industrial production by year:")
print(production.groupby("year")["value"].sum())
# Note: 2021 totals are much higher than 2022/2023 in this dataset - this
# looks like a coverage difference in the source data (e.g. fewer countries
# or months reported for later years), not a real production collapse.
# Worth checking country-by-country before treating 2022/2023 as comparable.

# Which products are tracked, and how many rows per product
print("\nRow count by product:")
print(df.groupby("product").size().sort_values(ascending=False))

# 6. Create a simple new column: rank each country's production within its year
production = production.copy()
production["production_rank_in_year"] = production.groupby("year")["value"] \
    .rank(ascending=False)

# 7. Save the cleaned data
df.to_csv("oil_production_statistics_clean.csv", index=False)
production.to_csv("crude_oil_production_by_country_year.csv", index=False)
print("\nSaved cleaned files: oil_production_statistics_clean.csv, crude_oil_production_by_country_year.csv")
