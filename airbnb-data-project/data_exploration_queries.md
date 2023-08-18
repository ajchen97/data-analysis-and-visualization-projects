## Airbnb Data Exploration SQL Queries & Results

**1. What is the revenue per day?**
```sql
WITH updated_calendar AS (
  SELECT listing_id, 
    date,
    available,
    CAST(REPLACE((SUBSTR(price, 2)), ',', '') AS numeric) AS price
  FROM calendar)

SELECT date,
  SUM(price) AS revenue
FROM updated_calendar
GROUP BY 1
ORDER BY 1
LIMIT 10;
```
|date|revenue|
|-|-|
2023-06-06|4093820.00
2023-06-07|11495956.00
2023-06-08|12352032.00
2023-06-09|13040026.00
2023-06-10|13123168.00
2023-06-11|12563294.00
2023-06-12|12454025.00
2023-06-13|12496724.00
2023-06-14|12597565.00
2023-06-15|12877242.00

**2. How many neighbourhoods are there in Los Angeles?**
```sql
SELECT COUNT(DISTINCT neighbourhood) AS neighbourhood_count
FROM listings;
```
|neighbourhood_count|
|-|
265

**3. How many hosts are there in each neighbourhood?**
```sql
SELECT neighbourhood,
  COUNT(DISTINCT host_id) AS host_count
FROM listings
GROUP BY 1
ORDER BY 1
LIMIT 10;
```
|neighbourhood|host_count|
|-|-|
Acton|12
Adams-Normandie|20
Agoura Hills|51
Agua Dulce|14
Alhambra|241
Alondra Park|14
Altadena|177
Angeles Crest|5
Arcadia|120
Arleta|8

**4. How many listings are there in each neighbourhood?**
```sql
SELECT neighbourhood,
  COUNT(id) AS listings_count
FROM listings
GROUP BY 1
ORDER BY 1
LIMIT 10;
```
|neighbourhood|listings_count|
|-|-|
Acton|12
Adams-Normandie|34
Agoura Hills|65
Agua Dulce|25
Alhambra|503
Alondra Park|17
Altadena|244
Angeles Crest|5
Arcadia|197
Arleta|9

**5. What is the average price of listings in each neighbourhood?**
```sql
SELECT neighbourhood, 
  ROUND(AVG(price), 2) AS avg_price_per_neighbourhood
FROM listings
GROUP BY 1
ORDER BY 1
LIMIT 10;
```
|neighbourhood|avg_price_per_neighbourhood|
|-|-|
Acton|199.83
Adams-Normandie|105.21
Agoura Hills|310.37
Agua Dulce|292.56
Alhambra|185.53
Alondra Park|234.47
Altadena|215.55
Angeles Crest|223.40
Arcadia|167.82
Arleta|344.78

**6. How many listings of each room type (private room, entire home, etc) are there?**
```sql
SELECT room_type,
  COUNT(id) AS listings_count
FROM listings
GROUP BY 1;
```
|room_type|listings_count|
|-|-|
Entire home/apt|31023
Shared room|740
Private room|12623
Hotel room|78

**7. What is the average price per room type listing?**
```sql
SELECT room_type,
  ROUND(AVG(price), 2) AS avg_price_per_room_type
FROM listings
GROUP BY 1;
```
|room_type|avg_price_per_room_type|
|-|-|
Entire home/apt|346.30
Shared room|65.40
Private room|123.85
Hotel room|664.65

**8. How many listings of each bedroom (1 bdrm, 2 bdrm, etc) are there?**
```sql
SELECT bedrooms,
  COUNT(id) AS listings_count
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
HAVING COUNT(id) > 10 -- accounting for outliers that have less than 10 listings each
ORDER BY 1;
```
|bedrooms|listings_count|
|-|-|
1|13118
2|7957
3|4806
4|2369
5|946
6|298
7|117
8|44
9|18
10|13

**9. What is the average price per bedroom listing?**
```sql
SELECT bedrooms,
  ROUND(AVG(price), 2) AS avg_price_per_listing
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
HAVING COUNT(bedrooms) > 10
ORDER BY 1;
```
|bedrooms|avg_price_per_listing|
|-|-|
1|188.70
2|253.96
3|434.08
4|754.40
5|1189.18
6|1854.24
7|3251.04
8|4019.77
9|3930.56
10|2963.62
