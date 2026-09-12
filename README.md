Oil & Gas Production & Asset Performance Analytics
Built on the dataset you uploaded: `oil_production_statistics.csv`.
About this dataset
36 countries (mostly OECD members - US, Canada, Mexico, UK, most of Europe, Japan, South Korea, Australia, etc.)
Years: 2021, 2022, 2023
6 columns: `country_name`, `type`, `product`, `flow`, `year`, `value`
11 product types: Crude oil, LPG, Naphtha, Gasoline and diesel, Residual fuel oil, Middle distillates, Total gas oil/kerosene/oil production, etc.
4 "flow" categories: Industrial Production, Net Deliveries, Consumption Pattern, Storage Channelization
This is a real oil-statistics-style dataset (the structure matches how agencies like the IEA publish national oil balances - production, deliveries, consumption, and storage, broken out by product).
What I found when I checked the data
No missing values — every row is filled in.
44 duplicate rows — exact repeats, removed with `drop_duplicates()`.
A real data quirk worth knowing about: total "Crude oil / Industrial Production" values for 2021 (~2.5 million) are far higher than 2022 or 2023 (~110-120K each). This is almost certainly a coverage difference in the source data (e.g. more countries/months reported for 2021) rather than an actual production collapse — I flagged this in the script rather than silently averaging it away. Worth checking country-by-country before comparing years directly.
Not every product has every flow type (e.g. "Crude oil" only has an "Industrial Production" flow, not "Net Deliveries") — this is a genuine structural feature of the data, not an error.
Project steps
Python (Pandas) — cleaning & basic analysis → `clean_and_analyze.py`
Loads the CSV (note: needs `encoding="latin1"`, not the default utf-8, because of characters like "Türkiye"), checks `.info()` / `.isnull()` / `.duplicated()`, drops the 44 duplicate rows, filters to the core "Crude oil + Industrial Production" production metric, runs `groupby()` summaries, adds a rank column, and saves two clean files. Already tested — runs end to end.
SQL — main analysis → `analysis_queries.sql`
8 queries: top 10 producers, year-over-year trend, total oil products production leaders, product mix summary, negative net-deliveries (net importers), production vs. consumption comparison (using a JOIN), storage activity by country, and a full country benchmark with `RANK()`.
Power BI — dashboard (build this yourself in Power BI Desktop using `oil_production_statistics_clean.csv`)
KPI cards: Total Crude Oil Production, Top Producing Country, Number of Countries Tracked, Total Storage Activity
Charts: production by country (bar), production trend by year (line - note the 2021 coverage caveat above), product mix (pie or bar), production vs. consumption (scatter or clustered bar)
Filters/slicers: Country, Product, Flow, Year
Real insights this dataset already shows (from running the script)
The United States dominates crude oil industrial production in this dataset (~1.59 million units, 2021-2023 combined), followed by Canada (~590K) and Mexico (~208K).
Among European producers, Norway and the United Kingdom lead (North Sea production), well ahead of the rest of Europe.
"Total oil products production" and "Total gas oil production" are the most consistently reported metrics (322 rows each), making them good candidates for cross-country comparison.
Slovakia and Belgium show negative "Net Deliveries" values for some products - worth investigating as either net imports or storage drawdowns rather than production.
