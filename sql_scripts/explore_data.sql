
SELECT A.CLIENT_REG_CODE, SUM(B.SUMMA_FULL) AS total_spend
FROM sm_clients A
JOIN sm_checks B ON A.CLIENT_REG_CODE = B.CLIENT_REG_CODE
GROUP BY CLIENT_REG_CODE;

##-------- Shops data
SELECT COUNT(DISTINCT SHOP_CITY)
FROM sm_shops_sprav; ## 418 shops (26 closed), 13 Regions and 193 cities

SELECT A.SHOP, B.SHOP_CITY, B.SHOP_REGION, SUM(VISITORS) AS total_visitors
FROM sm_shops_visitors A
JOIN sm_shops_sprav B ON A.SHOP = B.SHOP
GROUP BY A.SHOP, B.SHOP_CITY, B.SHOP_REGION
ORDER BY total_visitors DESC;  ## visitors by shop

SELECT B.SHOP_REGION, SUM(VISITORS) AS total_visitors
FROM sm_shops_visitors A
JOIN sm_shops_sprav B ON A.SHOP = B.SHOP
GROUP BY B.SHOP_REGION
ORDER BY total_visitors DESC;  ## visitors by shop region

##-------- User data
SELECT *
FROM sm_clients
WHERE BIRTHDAY IS NOT NULL
ORDER BY BIRTHDAY;  ## looking for very old or very young (or not born) people

SELECT CLIENT_REG_CODE, COUNT(*) AS purchases, SUM(SUMMA_FULL) AS spend
FROM sm_checks
GROUP BY CLIENT_REG_CODE;  ## spend and purchases for each client

SELECT A.CLIENT_REG_CODE, B.SHOP_REGION,
COUNT(*) AS purchases, SUM(SUMMA_FULL) AS spend
FROM sm_checks A
JOIN sm_shops_sprav B ON A.SHOP = B.SHOP
GROUP BY A.CLIENT_REG_CODE, B.SHOP_REGION;  ## spend and purchases for each client for each region

SELECT EXTRACT(YEAR FROM CHECK_DAT) AS year, MONTHNAME(CHECK_DAT) AS month,
CLIENT_REG_CODE, COUNT(*) AS purchases,
SUM(SUMMA_FULL) AS spend, SUM(SUMMA_BONUS) as bonus_spend,
SUM(SUMMA_DISCOUNT) AS discount_spend
FROM sm_checks
GROUP BY year, month, CLIENT_REG_CODE;  ## client purchases for each month

SELECT *
FROM sm_promo_sprav;

## Can each promotion only be used once?




