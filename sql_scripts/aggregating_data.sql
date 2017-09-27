##--------- Create database to store aggregated tables
CREATE DATABASE agg_sm;
USE agg_sm;

## Intermediate table for each CHECK_CODE (i.e. for each purchase) and index
## Quantity now refers to the total number of items purchased
## Data for 12.7m purchases, around 30m unique items
CREATE TABLE agg_sm.sm_checks_unique AS
SELECT CHECK_CODE, MAX(CHECK_DAT) AS CHECK_DAT, MAX(SHOP) AS SHOP, CLIENT_REG_CODE,
SUM(QUANTITY) AS QUANTITY, SUM(SUMMA_FULL) AS SUMMA_FULL,
SUM(SUMMA_MONEY) AS SUMMA_MONEY, SUM(SUMMA_BONUS) AS SUMMA_BONUS,
SUM(SUMMA_DISCOUNT) AS SUMMA_DISCOUNT
FROM sportmaster.sm_checks
GROUP BY CHECK_CODE, CLIENT_REG_CODE
;
ALTER TABLE agg_sm.sm_checks_unique ADD INDEX(CHECK_CODE);
ALTER TABLE agg_sm.sm_checks_unique ADD INDEX(CLIENT_REG_CODE);


## Spend, purchases avg spend and quantity, total_discount points+bonus
CREATE TABLE agg_sm.client_spend_summary AS (
SELECT CLIENT_REG_CODE, COUNT(*) AS purchases,
SUM(SUMMA_FULL) AS total_spend,
SUM(SUMMA_BONUS) AS total_bonus_spend,
SUM(SUMMA_DISCOUNT) AS total_discount_spend,
AVG(SUMMA_FULL) AS avg_spend,
SUM(CASE WHEN DAYOFWEEK(CHECK_DAT) = 7 OR DAYOFWEEK(CHECK_DAT) = 1 THEN 1 ELSE 0 END) AS weekend_purchases,
SUM(CASE WHEN DAYOFWEEK(CHECK_DAT) = 7 OR DAYOFWEEK(CHECK_DAT) = 1 THEN SUMMA_FULL ELSE 0 END) AS weekend_spend
FROM agg_sm.sm_checks_unique
GROUP BY CLIENT_REG_CODE)
;
ALTER TABLE agg_sm.client_spend_summary ADD INDEX (CLIENT_REG_CODE);

## Spend, purchases for adults
CREATE TABLE agg_sm.client_spend_adults_summary AS (
SELECT CLIENT_REG_CODE,
SUM(CASE WHEN B.AGE = 'Adults' THEN SUMMA_FULL ELSE 0 END) AS adults_spend
FROM sportmaster.sm_checks A
JOIN sportmaster.sm_catalog B ON A.ART = B.ART
GROUP BY CLIENT_REG_CODE)
;
ALTER TABLE agg_sm.client_spend_adults_summary ADD INDEX (CLIENT_REG_CODE);


## Favourite stores for each client (purchases and spend per region)
DROP TABLE agg_sm.client_store_spend_summary;
CREATE TABLE agg_sm.client_store_spend_summary AS (
SELECT A.CLIENT_REG_CODE, B.SHOP_REGION, 
COUNT(*) AS purchases, SUM(A.SUMMA_FULL) AS total_spend
FROM agg_sm.sm_checks_unique A
JOIN sportmaster.sm_shops_sprav B ON A.SHOP = B.SHOP
GROUP BY A.CLIENT_REG_CODE, B.SHOP_REGION
)
;
ALTER TABLE agg_sm.client_store_spend_summary ADD INDEX (CLIENT_REG_CODE);


## Monthly spend summary for each client
DROP TABLE agg_sm.client_monthly_spend_summary;
CREATE TABLE agg_sm.client_monthly_spend_summary AS (
SELECT CLIENT_REG_CODE,
EXTRACT(YEAR FROM CHECK_DAT) AS year, MONTHNAME(CHECK_DAT) AS month,
COUNT(*) AS purchases, SUM(SUMMA_FULL) AS total_spend
FROM agg_sm.sm_checks_unique
GROUP BY CLIENT_REG_CODE, year, month
);

ALTER TABLE agg_sm.client_monthly_spend_summary ADD INDEX (CLIENT_REG_CODE);

## Category spend per client
DROP TABLE agg_sm.client_cat_spend_summary;
CREATE TABLE agg_sm.client_cat_spend_summary AS (
SELECT A.CLIENT_REG_CODE, B.CATEGORY,SUM(A.SUMMA_FULL) AS total_spend
FROM sportmaster.sm_checks A
JOIN sportmaster.sm_catalog B ON A.ART = B.ART
GROUP BY A.CLIENT_REG_CODE, B.CATEGORY
)
;
ALTER TABLE agg_sm.client_cat_spend_summary ADD INDEX (CLIENT_REG_CODE);











## Promotions received and used
SELECT B.CLIENT_REG_CODE, A.DISC_ID
FROM sportmaster.sm_check_discount A
JOIN sportmaster.sm_checks B ON A.CHECK_CODE = B.CHECK_CODE
;


SELECT * FROM sportmaster.sm_promo_sprav;
SELECT * FROM sportmaster.sm_communication;
SELECT * FROM sportmaster.sm_check_discount;
SELECT * FROM sportmaster.sm_checks ORDER BY CHECK_CODE DESC;

SELECT COUNT(DISTINCT CHECK_CODE) AS check_codes,
COUNT(DISTINCT CHECK_LIST_CODE) as check_list_codes
FROM sportmaster.sm_checks;


