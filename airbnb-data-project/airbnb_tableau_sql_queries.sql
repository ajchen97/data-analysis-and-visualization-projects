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
  COUNT(id) AS listings_count,
  COUNT(id)::numeric/(SELECT COUNT(*) FROM listings) AS listings_percentage
FROM listings
GROUP BY 1;

-- Avg Price per Room Type Listing
SELECT room_type,
  ROUND(AVG(price), 2) AS avg_price_per_room_type
FROM listings
GROUP BY 1;

-- Bedroom Listings Count
SELECT bedrooms,
  COUNT(id) AS listings_count,
  COUNT(id)::numeric/(SELECT COUNT(*) FROM listings) AS listings_percentage
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
HAVING COUNT(id) > 10 -- accounting for outliers that have less than 10 listings each
ORDER BY 1;

-- Avg Price per Bedroom Listing
SELECT bedrooms,
  ROUND(AVG(price), 2) AS avg_price_per_listing
FROM listings
WHERE bedrooms IS NOT NULL
GROUP BY 1
HAVING COUNT(bedrooms) > 10
ORDER BY 1;

-- Instant Bookable Listings
WITH instant_book AS (
  SELECT room_type,
    instant_bookable,
    DENSE_RANK() OVER (PARTITION BY room_type ORDER BY instant_bookable DESC) AS book_rank
  FROM listings)

SELECT room_type,
  COUNT(book_rank) FILTER (WHERE book_rank = 1) AS yes_instant_bookable,
  COUNT(book_rank) FILTER (WHERE book_rank = 2) AS not_instant_bookable
FROM instant_book
GROUP BY 1;
