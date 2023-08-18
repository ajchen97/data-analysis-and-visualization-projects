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

-- Hosts per Neighbourhood
SELECT neighbourhood,
  COUNT(DISTINCT host_id) AS host_count
FROM listings
GROUP BY 1
ORDER BY 1;

-- Listings per Neighbourhood
SELECT neighbourhood, 
  COUNT(id) AS listings_count
FROM listings
GROUP BY 1
ORDER BY 1;

-- Avg Price per Neighbourhood
SELECT neighbourhood, 
  ROUND(AVG(price), 2) AS avg_price_per_neighbourhood
FROM listings
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
