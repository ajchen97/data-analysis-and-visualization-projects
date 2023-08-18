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
  COUNT(DISTINCT id) AS listings_count,
  COUNT(DISTINCT id)::numeric/(SELECT COUNT(DISTINCT id) FROM listings) AS listings_percentage
FROM listings
GROUP BY 1;
```
|room_type|listings_count|listings_percentage|
|-|-|-|
Entire home/apt|31023|0.69771050737675422814
Shared room|740|0.01664267722202231018
Private room|12623|0.28389258726160489385
Hotel room|78|0.00175422813961856783

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
SELECT CASE WHEN bedrooms < 6 THEN bedrooms::varchar ELSE '6+' END AS bedrooms,
  COUNT(DISTINCT id) AS listings_count,
  COUNT(DISTINCT id)::numeric/(SELECT COUNT(DISTINCT id) FROM listings) AS listings_percentage
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
ORDER BY 1;
```
|bedrooms|listings_count|listings_percentage|
|-|-|-|
1|13118|0.29502518891687657431
2|7957|0.17895376034544800288
3|4806|0.10808744152572867938
4|2369|0.05327905721482547679
5|946|0.02127563871896365599
6+|516|0.01160489384670744872

**9. What is the average price per bedroom listing?**
```sql
SELECT CASE WHEN bedrooms < 6 THEN bedrooms::varchar ELSE '6+' END AS bedrooms,
  ROUND(AVG(price), 2) AS avg_price_per_listing
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
ORDER BY 1;
```
|bedrooms|avg_price_per_listing|
|-|-|
1|188.70
2|253.96
3|434.08
4|754.40
5|1189.18
6+|2489.14

**10. How many room type listings are instant bookable?**
```sql
WITH instant_book AS (
  SELECT room_type,
    instant_bookable,
    DENSE_RANK() OVER (PARTITION BY room_type ORDER BY instant_bookable DESC) AS book_rank
  FROM listings),
total_instant_book AS (
  SELECT room_type,
    (COUNT(book_rank) FILTER (WHERE book_rank = 1))::numeric AS yes_instant_bookable,
    (COUNT(book_rank) FILTER (WHERE book_rank = 2))::numeric AS not_instant_bookable,
    COUNT(room_type)::numeric AS total_listings
FROM instant_book
GROUP BY 1)

SELECT room_type,
  yes_instant_bookable,
  not_instant_bookable,
  total_listings,
  ROUND(yes_instant_bookable/total_listings, 3) AS percent_yes, 
  ROUND(not_instant_bookable/total_listings, 3) AS percent_no
FROM total_instant_book;
```
|room_type|yes_instant_bookable|not_instant_bookable|total_listings|percent_yes|percent_no|
|-|-|-|-|-|-|
Entire home/apt|8678|22345|31023|0.280|0.720
Hotel room|45|33|78|0.577|0.423
Private room|4343|8280|12623|0.344|0.656
Shared room|161|579|740|0.218|0.782
