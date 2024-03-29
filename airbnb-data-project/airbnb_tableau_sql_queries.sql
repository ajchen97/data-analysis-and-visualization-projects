-- Queries used for visualization of Airbnb data in Tableau


-- Revenue by Date
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
ORDER BY 1;

-- Room Type Listings Count
SELECT room_type,
  COUNT(DISTINCT id) AS listings_count,
  COUNT(DISTINCT id)::numeric/(SELECT COUNT(DISTINCT id) FROM listings) AS listings_percentage
FROM listings
GROUP BY 1;

-- Avg Price per Room Type Listing
SELECT room_type,
  ROUND(AVG(price), 2) AS avg_price_per_room_type
FROM listings
GROUP BY 1;

-- Bedroom Listings Count
SELECT CASE WHEN bedrooms < 6 THEN bedrooms::varchar ELSE '6+' END AS bedrooms,
  COUNT(DISTINCT id) AS listings_count,
  COUNT(DISTINCT id)::numeric/(SELECT COUNT(DISTINCT id) FROM listings) AS listings_percentage
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Avg Price per Bedroom Listing
SELECT CASE WHEN bedrooms < 6 THEN bedrooms::varchar ELSE '6+' END AS bedrooms,
  ROUND(AVG(price), 2) AS avg_price_per_listing
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Instant Bookable Listings
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
