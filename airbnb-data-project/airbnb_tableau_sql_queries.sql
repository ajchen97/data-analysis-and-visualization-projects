-- Queries used for visualization of Airbnb data in Tableau


-- What is the revenue per day?
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

