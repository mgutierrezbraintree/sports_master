##--------- Create database to store aggregated tables
CREATE DATABASE agg_sm;
USE agg_sm;

## Spend, purchases, avg spend and quantity, total discount points+bonus, 
CREATE TABLE client_spend_summary AS (
SELECT CLIENT_REG_CODE, COUNT(*) AS purchases,
SUM(SUMMA_FULL) AS total_spend,
SUM(SUMMA_BONUS) AS total_bonus_spend,
SUM(SUMMA_DISCOUNT) AS total_discount_spend,
AVG(SUMMA_FULL) AS avg_spend,
AVG(QUANTITY) AS avg_quantity,
SUM(CASE WHEN DAYOFWEEK(CHECK_DAT) = 7 OR DAYOFWEEK(CHECK_DAT) = 1 THEN 1 ELSE 0 END) AS weekend_purchases,
SUM(CASE WHEN DAYOFWEEK(CHECK_DAT) = 7 OR DAYOFWEEK(CHECK_DAT) = 1 THEN SUMMA_FULL ELSE 0 END) AS weekend_spend,
SUM(CASE WHEN B.AGE = 'Adults' THEN 1 ELSE 0 END) AS adults_purchase,
SUM(CASE WHEN B.AGE = 'Adults' THEN SUMMA_FULL ELSE 0 END) AS adults_spend
FROM sportmaster.sm_checks A
JOIN sportmaster.sm_catalog B ON A.ART = B.ART
GROUP BY CLIENT_REG_CODE);

## Favourite stores for each client (purchases and spend per region)
CREATE TABLE client_store_spend_summary AS (
SELECT A.CLIENT_REG_CODE, B.SHOP_REGION, 
COUNT(*) AS purchases, SUM(A.SUMMA_FULL) AS total_spend
FROM sportmaster.sm_checks A
JOIN sportmaster.sm_shops_sprav B ON A.SHOP = B.SHOP
GROUP BY A.CLIENT_REG_CODE, B.SHOP_REGION
);

## Monthly spend summary for each client
CREATE TABLE client_monthly_spend_summary AS (
SELECT CLIENT_REG_CODE,
EXTRACT(YEAR FROM CHECK_DAT) AS year, MONTHNAME(CHECK_DAT) AS month,
COUNT(*) AS purchases, SUM(SUMMA_FULL) AS total_spend
FROM sportmaster.sm_checks
GROUP BY CLIENT_REG_CODE, year, month
);

## Category spend per client
CREATE TABLE client_cat_spend_summary AS (
SELECT A.CLIENT_REG_CODE, B.category,
COUNT(*) AS purchases, SUM(A.SUMMA_FULL) AS total_spend
FROM sportmaster.sm_checks A
JOIN sportmaster.sm_catalog B ON A.ART = B.ART
GROUP BY A.CLIENT_REG_CODE, B.category
);


## Promotions received and points receieved



SELECT * FROM sportmaster.sm_catalog;
