-- =========================================================
-- Oil & Gas Production & Asset Performance Analytics
-- SQL Analysis Layer
-- Table assumed: oil_production_statistics (loaded from
-- oil_production_statistics_clean.csv)
-- Data source: user-provided OECD-style oil statistics dataset,
-- 36 countries, 2021-2023. Columns: country_name, type, product,
-- flow, year, value.
-- =========================================================

-- 0. Create table
CREATE TABLE oil_production_statistics (
    country_name    VARCHAR(50),
    type            VARCHAR(20),
    product         VARCHAR(50),
    flow            VARCHAR(50),
    year            INT,
    value           FLOAT
);

-- 1. Top 10 countries by total crude oil industrial production (2021-2023)
SELECT
    country_name,
    ROUND(SUM(value), 1) AS total_crude_oil_production
FROM oil_production_statistics
WHERE product = 'Crude oil' AND flow = 'Industrial Production'
GROUP BY country_name
ORDER BY total_crude_oil_production DESC
LIMIT 10;

-- 2. Crude oil production trend by year (across all countries)
SELECT
    year,
    ROUND(SUM(value), 1) AS total_production
FROM oil_production_statistics
WHERE product = 'Crude oil' AND flow = 'Industrial Production'
GROUP BY year
ORDER BY year;

-- 3. Which countries produce crude oil AND rank in top 10 for total oil products production?
SELECT
    country_name,
    product,
    ROUND(SUM(value), 1) AS total_value
FROM oil_production_statistics
WHERE product = 'Total oil products production'
GROUP BY country_name, product
ORDER BY total_value DESC
LIMIT 10;

-- 4. Product mix - how much of each product type is tracked overall (row counts + total value)
SELECT
    product,
    COUNT(*) AS row_count,
    ROUND(SUM(value), 1) AS total_value
FROM oil_production_statistics
GROUP BY product
ORDER BY total_value DESC;

-- 5. Countries with negative "Net Deliveries" (net importers / drawing from storage)
SELECT
    country_name,
    product,
    year,
    value
FROM oil_production_statistics
WHERE flow = 'Net Deliveries' AND value < 0
ORDER BY value ASC
LIMIT 10;

-- 6. Compare Industrial Production vs Consumption Pattern for crude oil, by country
SELECT
    p.country_name,
    p.year,
    p.value AS industrial_production,
    c.value AS consumption_pattern
FROM
    (SELECT country_name, year, value FROM oil_production_statistics
     WHERE product = 'Crude oil' AND flow = 'Industrial Production') p
JOIN
    (SELECT country_name, year, value FROM oil_production_statistics
     WHERE product = 'Crude oil' AND flow = 'Consumption Pattern') c
ON p.country_name = c.country_name AND p.year = c.year
ORDER BY p.value DESC
LIMIT 10;

-- 7. Storage channelization - which countries/products show the most storage activity
SELECT
    country_name,
    product,
    ROUND(SUM(value), 1) AS total_storage_value
FROM oil_production_statistics
WHERE flow = 'Storage Channelization'
GROUP BY country_name, product
ORDER BY total_storage_value DESC
LIMIT 10;

-- 8. Full country benchmark: total crude production, avg per year, and rank
SELECT
    country_name,
    ROUND(SUM(value), 1) AS total_production,
    ROUND(AVG(value), 1) AS avg_yearly_production,
    RANK() OVER (ORDER BY SUM(value) DESC) AS production_rank
FROM oil_production_statistics
WHERE product = 'Crude oil' AND flow = 'Industrial Production'
GROUP BY country_name
ORDER BY production_rank;
