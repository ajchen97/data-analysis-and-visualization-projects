-- https://8weeksqlchallenge.com/case-study-2/
-- PostgreSQL

-- A. PIZZA METRICS
-- 1. How many pizzas were ordered?
SELECT COUNT(*) AS total_pizzas
FROM customer_orders_temp;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders_temp;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY 1
ORDER BY 1;

-- 4. How many of each type of pizza was delivered?
SELECT p.pizza_name,
    COUNT(p.pizza_id) AS num_delivered
FROM customer_orders_temp c
JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
JOIN runner_orders_temp r
ON c.order_id = r.order_id
  AND r.cancellation IS NULL
GROUP BY 1;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id, 
    p.pizza_name,
    COUNT(p.pizza_id) AS num_ordered
FROM customer_orders_temp c
JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY 1,2 
ORDER BY 1;

-- 6. What was the maximum number of pizzas delivered in a single order?
WITH pizzas_delivered AS (
  SELECT c.order_id, 
      COUNT(c.order_id) AS num_delivered
  FROM customer_orders_temp c 
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL
  GROUP BY 1
  ORDER BY 1)

SELECT MAX(num_delivered) AS max_delivered
FROM pizzas_delivered;

-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH either_changes AS (
  SELECT c.customer_id AS customer_id,
      c.pizza_id AS pizza_id, 
      CASE WHEN c.exclusions IS NOT NULL OR c.extras IS NOT NULL THEN 1 ELSE 0 END AS changes
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL
  ORDER BY c.customer_id)

SELECT customer_id, 
    COUNT(changes) FILTER (WHERE changes = 1) AS any_changes,
    COUNT(changes) FILTER (WHERE changes = 0) AS no_changes
FROM either_changes
GROUP BY 1;

-- 8. How many pizzas were delivered that had both exclusions and extras?
WITH both_changes AS (
  SELECT c.customer_id AS customer_id,
      c.pizza_id AS pizza_id, 
      CASE WHEN c.exclusions IS NOT NULL AND c.extras IS NOT NULL THEN 1 ELSE 0 END AS changes
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL
  ORDER BY c.customer_id)

SELECT COUNT(changes) FILTER (WHERE changes = 1) AS both_changes_pizzas
FROM both_changes;

-- 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT('hour' FROM order_time) AS hour_of_day,
    COUNT(*) AS pizzas_ordered
FROM customer_orders_temp
GROUP BY 1
ORDER BY 1;

-- 10. What was the volume of orders for each day of the week?
SELECT TO_CHAR(order_time, 'Day') AS day_of_week,
    COUNT(*) AS pizzas_ordered
FROM customer_orders_temp
GROUP BY 1
ORDER BY 2;


-- B. RUNNER AND CUSTOMER EXPERIENCE
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT DATE_PART('week', registration_date+3) AS registration_week,
    COUNT(runner_id) AS sign_ups
FROM pizza_runner.runners
GROUP BY 1
ORDER BY 1;

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
WITH arrival_time AS (
  SELECT r.runner_id AS runner_id, 
      (EXTRACT('EPOCH' FROM r.pickup_time) - EXTRACT('EPOCH' FROM c.order_time))/60 AS arrival_time
  FROM runner_orders_temp r
  JOIN customer_orders_temp c
  ON r.order_id = c.order_id
  WHERE r.cancellation IS NULL)

SELECT runner_id, 
    CONCAT(ROUND(AVG(arrival_time)::numeric, 2), ' mins') AS avg_arrival
FROM arrival_time
GROUP BY 1
ORDER BY 1;

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH prep AS (
  SELECT c.order_id AS order_id, 
      COUNT(c.order_id) AS pizza_count,
      (EXTRACT(EPOCH FROM r.pickup_time) - EXTRACT(EPOCH FROM c.order_time))/60 AS prep_time
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL
  GROUP BY 1,3)

SELECT pizza_count, 
    CONCAT(ROUND(AVG(prep_time)::numeric, 2), ' mins') AS avg_prep
FROM prep
GROUP BY 1
ORDER BY 1;

-- 4. What was the average distance travelled for each customer?
SELECT c.customer_id AS customer_id, 
    CONCAT(ROUND(AVG(r.distance)::numeric, 2), ' km') AS avg_distance
FROM customer_orders_temp c
JOIN runner_orders_temp r
ON c.order_id = r.order_id
    AND r.cancellation IS NULL
GROUP BY 1
ORDER BY 1;

-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT CONCAT(MAX(duration)-MIN(duration), ' mins') AS delivery_time_difference
FROM runner_orders_temp
WHERE cancellation IS NULL;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT runner_id, 
    order_id, 
    CONCAT(ROUND(AVG((distance)/(duration/60::numeric))::numeric, 2), ' km/h') AS avg_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY 1,2
ORDER BY 1,2;

-- 7. What is the successful delivery percentage for each runner?
WITH orders AS (
  SELECT runner_id, 
      COUNT(order_id)::numeric AS total_orders,
      (COUNT(order_id) FILTER (WHERE cancellation IS NULL))::numeric AS successful_orders
  FROM runner_orders_temp
  GROUP BY 1)

SELECT runner_id, 
    CONCAT(ROUND((successful_orders/total_orders)*100), '%') AS success_percent
FROM orders
ORDER BY 1;


-- C. Ingredient Optimisation
-- 1. What are the standard ingredients for each pizza?
WITH toppings_expanded AS (
  SELECT r.pizza_id AS pizza_id, 
      n.pizza_name AS pizza_name,
      UNNEST(r.toppings) AS topping_id
  FROM pizza_recipes_temp r
  JOIN pizza_runner.pizza_names n
  ON r.pizza_id = n.pizza_id)
    
SELECT t.pizza_name AS pizza_name, 
    ARRAY_AGG(pt.topping_name) AS ingredients
FROM toppings_expanded t
JOIN pizza_runner.pizza_toppings pt
ON t.topping_id = pt.topping_id
GROUP BY 1;

-- 2. What was the most commonly added extra?
WITH extras_expanded AS (
  SELECT extras,
      UNNEST(extras) AS extra_id
  FROM customer_orders_temp),
toppings_expanded AS (
  SELECT DISTINCT UNNEST(r.toppings) AS topping_id
  FROM pizza_recipes_temp r
  JOIN pizza_runner.pizza_names n
  ON r.pizza_id = n.pizza_id),
extras_count AS (
  SELECT extra_id, 
      COUNT(extra_id) AS extras_count
  FROM extras_expanded 
  GROUP BY 1)

SELECT pt.topping_name AS most_common_extra
FROM extras_count e
JOIN toppings_expanded t
ON e.extra_id = t.topping_id
JOIN pizza_runner.pizza_toppings pt
ON t.topping_id = pt.topping_id
WHERE e.extras_count = (
    SELECT MAX(extras_count) 
    FROM extras_count);

-- 3. What was the most common exclusion?
WITH exclusions_expanded AS (
  SELECT exclusions,
      UNNEST(exclusions) AS exclusion_id
  FROM customer_orders_temp),
toppings_expanded AS (
  SELECT DISTINCT UNNEST(r.toppings) AS topping_id
  FROM pizza_recipes_temp r
  JOIN pizza_runner.pizza_names n
  ON r.pizza_id = n.pizza_id),
exclusions_count AS (
  SELECT exclusion_id, 
      COUNT(exclusion_id) AS exclusions_count
  FROM exclusions_expanded 
  GROUP BY 1)

SELECT pt.topping_name AS most_common_exclusion
FROM exclusions_count e
JOIN toppings_expanded t
ON e.exclusion_id = t.topping_id
JOIN pizza_runner.pizza_toppings pt
ON t.topping_id = pt.topping_id
WHERE e.exclusions_count = (
    SELECT MAX(exclusions_count) 
    FROM exclusions_count);
    
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following: (Meat Lovers), (Meat Lovers - Exclude Beef), (Meat Lovers - Extra Bacon), (Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers)
WITH toppings_expanded AS (
  SELECT DISTINCT UNNEST(r.toppings) AS topping_id
  FROM pizza_recipes_temp r
  JOIN pizza_runner.pizza_names n
  ON r.pizza_id = n.pizza_id),
toppings_list AS (
  SELECT t.topping_id AS topping_id, 
      pt.topping_name AS topping_name,
      CASE WHEN pt.topping_name IN ('Bacon', 'Beef', 'Chicken', 'Pepperoni', 'Salami') THEN 'meat'
          ELSE 'non-meat' END AS topping_type
  FROM toppings_expanded t
  JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id),
extras_expanded AS (
  SELECT extras,
      UNNEST(extras) AS extra_id
  FROM customer_orders_temp),
extra_names AS (
  SELECT extras,
      STRING_AGG(DISTINCT pt.topping_name, ', ') AS extra_names
  FROM extras_expanded e
  JOIN toppings_expanded t
  ON e.extra_id = t.topping_id
  JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id
  GROUP BY 1),
exclusions_expanded AS (
  SELECT exclusions,
      UNNEST(exclusions) AS exclusion_id
  FROM customer_orders_temp),
exclusion_names AS (
  SELECT exclusions,
      STRING_AGG(DISTINCT pt.topping_name, ', ') AS exclusion_names
  FROM exclusions_expanded e
  JOIN toppings_expanded t
  ON e.exclusion_id = t.topping_id
  JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id
  GROUP BY 1),
orders AS (
  SELECT c.order_id AS order_id, 
      c.customer_id AS customer_id,
      c.pizza_id AS pizza_id,
      CASE WHEN c.exclusions IS NOT NULL THEN exclusion_names END AS exclusions,
      CASE WHEN c.extras IS NOT NULL THEN extra_names END AS extras,
  	  CASE WHEN pizza_name = 'Meatlovers' THEN 'Meat Lovers'
          WHEN pizza_name = 'Vegetarian' THEN 'Veggie Lovers' END AS order_name
  FROM customer_orders_temp c
  LEFT JOIN pizza_runner.pizza_names n
  ON c.pizza_id = n.pizza_id
  LEFT JOIN exclusion_names exc
  ON exc.exclusions = c.exclusions
  LEFT JOIN extra_names ext
  ON ext.extras = c.extras)
  
SELECT order_id,
    customer_id,
    pizza_id,
    exclusions,
    extras,
    CASE WHEN exclusions IS NOT NULL AND extras IS NULL THEN CONCAT(order_name, ' - Exclude ', exclusions)
    	WHEN exclusions IS NULL AND extras IS NOT NULL THEN CONCAT(order_name, ' - Extra ', extras)
    	WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN CONCAT(order_name,' - Exclude ', exclusions, ' - Extra ', extras)
    	ELSE order_name END AS order_item
FROM orders
ORDER BY 1;

-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients (For example: "Meat Lovers: 2xBacon, Beef, ... , Salami")
WITH toppings_expanded AS (
  SELECT DISTINCT UNNEST(r.toppings) AS topping_id
  FROM pizza_recipes_temp r
  JOIN pizza_runner.pizza_names n
  ON r.pizza_id = n.pizza_id),
toppings_list AS (
  SELECT DISTINCT t.topping_id AS topping_id, 
      pt.topping_name AS topping_name,
      CASE WHEN pt.topping_name IN ('Bacon', 'Beef', 'Chicken', 'Pepperoni', 'Salami') THEN 'meat'
          ELSE 'non-meat' END AS topping_type
  FROM toppings_expanded t
  JOIN pizza_runner.pizza_toppings pt
  ON t.topping_id = pt.topping_id),
orders AS (
  SELECT c.order_id,
      c.customer_id,
      c.pizza_id,
      ARRAY_CAT(ARRAY_CAT(c.exclusions, c.extras), r.toppings) AS all_toppings,
  	  ROW_NUMBER() OVER (ORDER BY c.order_id) AS row_num
  FROM customer_orders_temp c
  JOIN pizza_recipes_temp r
  ON c.pizza_id = r.pizza_id),
order_toppings_expanded as (
  SELECT *, 
      UNNEST(all_toppings) AS topping_id
  FROM orders),
toppings_count AS (
  SELECT o.row_num, 
      o.topping_id, 
      COUNT(t.topping_name) AS topping_count,
      CASE WHEN COUNT(t.topping_name) > 1 THEN CONCAT(COUNT(t.topping_name), 'x', t.topping_name) 
  		  ELSE t.topping_name END AS topping_count_name
  FROM order_toppings_expanded o
  JOIN toppings_list t
  ON t.topping_id = o.topping_id
  GROUP BY 1,2, t.topping_name),
ingredients_list AS (
  SELECT o.order_id,
      o.customer_id, 
      o.pizza_id, 
      o.row_num, 
      STRING_AGG(DISTINCT tc.topping_count_name, ', ' ORDER BY tc.topping_count_name) AS ingredients_list
  FROM order_toppings_expanded o
  JOIN toppings_list t
  ON t.topping_id = o.topping_id
  JOIN toppings_count tc
  ON o.topping_id = tc.topping_id
      AND o.row_num = tc.row_num
GROUP BY 1,2,3,4) 

SELECT order_id, customer_id, pizza_id, 
	CASE WHEN pizza_id = 2 THEN concat('Meat Lovers: ', ingredients_list) ELSE concat('Veggie Lovers: ', ingredients_list) END AS order_list
FROM ingredients_list;


-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


-- D. Pricing and Ratings
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
/** 2. What if there was an additional $1 charge for any pizza extras?
      - Add cheese is $1 extra **/
-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
/** 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
      - customer_id
      - order_id
      - runner_id
      - rating
      - order_time
      - pickup_time
      - Time between order and pickup
      - Delivery duration
      - Average speed
      - Total number of pizzas **/
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

-- E. Bonus Questions
-- 1. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
