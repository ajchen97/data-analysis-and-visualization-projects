## [Case Study #2](https://8weeksqlchallenge.com/case-study-2/) - Pizza Runner Results

### A. Pizza Metrics
**1. How many pizzas were ordered?**
```sql 
SELECT COUNT(*) AS total_pizzas
FROM customer_orders_temp;
```
| total_pizzas |
| ------------ |
| 14           |

**2. How many unique customer orders were made?**
```sql 
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders_temp;
```
| unique_orders |
| ------------- |
| 10            |

**3. How many successful orders were delivered by each runner?**
```sql 
SELECT runner_id, COUNT(*) AS successful_orders
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY 1
ORDER BY 1;
```

| runner_id | successful_orders |
| --------- | ----------------- |
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

**4. How many of each type of pizza was delivered?**
```sql 
SELECT p.pizza_name,
    COUNT(p.pizza_id) AS num_delivered
FROM customer_orders_temp c
JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
JOIN runner_orders_temp r
ON c.order_id = r.order_id
  AND r.cancellation IS NULL
GROUP BY 1;
```

| pizza_name | num_delivered |
| ---------- | ------------- |
| Vegetarian | 3             |
| Meatlovers | 9             |

**5. How many Vegetarian and Meatlovers were ordered by each customer?**
```sql 
SELECT c.customer_id, 
    p.pizza_name,
    COUNT(p.pizza_id) AS num_ordered
FROM customer_orders_temp c
JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY 1,2 
ORDER BY 1;
```
| customer_id | pizza_name | num_ordered |
| ----------- | ---------- | ----------- |
| 101         | Meatlovers | 2           |
| 101         | Vegetarian | 1           |
| 102         | Meatlovers | 2           |
| 102         | Vegetarian | 1           |
| 103         | Meatlovers | 3           |
| 103         | Vegetarian | 1           |
| 104         | Meatlovers | 3           |
| 105         | Vegetarian | 1           |

**6. What was the maximum number of pizzas delivered in a single order?**
```sql 
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
```
| max_delivered |
| ------------- |
| 3             |

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```sql 
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
```
| customer_id | any_changes | no_changes |
| ----------- | ----------- | ---------- |
| 101         | 0           | 2          |
| 102         | 0           | 3          |
| 103         | 3           | 0          |
| 104         | 2           | 1          |
| 105         | 1           | 0          |

**8. How many pizzas were delivered that had both exclusions and extras?**
```sql 
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
```
| both_changes_pizzas |
| ------------------- |
| 3                   |

**9. What was the total volume of pizzas ordered for each hour of the day?**
```sql 
SELECT EXTRACT('hour' FROM order_time) AS hour_of_day,
    COUNT(*) AS pizzas_ordered
FROM customer_orders_temp
GROUP BY 1
ORDER BY 1;
```
| hour_of_day | pizzas_ordered |
| ----------- | -------------- |
| 11          | 1              |
| 13          | 3              |
| 18          | 3              |
| 19          | 1              |
| 21          | 3              |
| 23          | 3              |

**10. What was the volume of orders for each day of the week?**
```sql 
SELECT TO_CHAR(order_time, 'Day') AS day_of_week,
    COUNT(*) AS pizzas_ordered
FROM customer_orders_temp
GROUP BY 1
ORDER BY 2;
```
| day_of_week | pizzas_ordered |
| ----------- | -------------- |
| Friday      | 1              |
| Thursday    | 3              |
| Saturday    | 5              |
| Wednesday   | 5              |


### B. Runner and Customer Experience
**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**
```sql 
SELECT DATE_PART('week', registration_date+3) AS registration_week,
    COUNT(runner_id) AS sign_ups
FROM pizza_runner.runners
GROUP BY 1
ORDER BY 1;
```
| registration_week | sign_ups |
| ----------------- | -------- |
| 1                 | 2        |
| 2                 | 1        |
| 3                 | 1        |

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
```sql 
WITH arrival_time AS (
  SELECT r.runner_id AS runner_id, 
      (EXTRACT('EPOCH' FROM r.pickup_time) - EXTRACT('EPOCH' FROM c.order_time))/60 AS arrival_time
  FROM runner_orders_temp r
  JOIN customer_orders_temp c
  ON r.order_id = c.order_id
  WHERE r.cancellation IS NULL)

SELECT runner_id, 
    CONCAT(ROUND(AVG(arrival_time)), ' mins') AS avg_arrival
FROM arrival_time
GROUP BY 1
ORDER BY 1;
```
| runner_id | avg_arrival |
| --------- | ----------- |
| 1         | 16 mins     |
| 2         | 24 mins     |
| 3         | 10 mins     |

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**
```sql 
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
    CONCAT(ROUND(AVG(prep_time)), ' mins') AS avg_prep
FROM prep
GROUP BY 1
ORDER BY 1;
```
| pizza_count | avg_prep   |
| ----------- | ---------- |
| 1           | 12 mins    |
| 2           | 18 mins    |
| 3           | 29 mins    |

**4. What was the average distance travelled for each customer?**
```sql 
SELECT c.customer_id AS customer_id, 
    CONCAT(ROUND(AVG(r.distance)::numeric, 2), ' km') AS avg_distance
FROM customer_orders_temp c
JOIN runner_orders_temp r
ON c.order_id = r.order_id
    AND r.cancellation IS NULL
GROUP BY 1
ORDER BY 1;
```
| customer_id | avg_distance |
| ----------- | ------------ |
| 101         | 20.00 km     |
| 102         | 16.73 km     |
| 103         | 23.40 km     |
| 104         | 10.00 km     |
| 105         | 25.00 km     |

**5. What was the difference between the longest and shortest delivery times for all orders?**
```sql 
SELECT CONCAT(MAX(duration)-MIN(duration), ' mins') AS delivery_time_difference
FROM runner_orders_temp
WHERE cancellation IS NULL;
```
| delivery_time_difference |
| ------------------------ |
| 30 mins                  |

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**
```sql 
SELECT runner_id, 
    order_id, 
    CONCAT(ROUND(AVG((distance)/(duration/60::numeric))::numeric, 2), ' km/h') AS avg_speed
FROM runner_orders_temp
WHERE cancellation IS NULL
GROUP BY 1,2
ORDER BY 1,2;
```
| runner_id | order_id | avg_speed  |
| --------- | -------- | ---------- |
| 1         | 1        | 37.50 km/h |
| 1         | 2        | 44.44 km/h |
| 1         | 3        | 40.20 km/h |
| 1         | 10       | 60.00 km/h |
| 2         | 4        | 35.10 km/h |
| 2         | 7        | 60.00 km/h |
| 2         | 8        | 93.60 km/h |
| 3         | 5        | 40.00 km/h |

**7. What is the successful delivery percentage for each runner?**
```sql 
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
```
| runner_id | success_percent |
| --------- | --------------- |
| 1         | 100%            |
| 2         | 75%             |
| 3         | 50%             |


### C. Ingredient Optimisation
**1. What are the standard ingredients for each pizza?**
```sql 
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
```
| pizza_name | ingredients                                                    |
| ---------- | -------------------------------------------------------------- |
| Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| Vegetarian | Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce          |

**2. What was the most commonly added extra?**
```sql 
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
```
| most_common_extra |
| ----------------- |
| Bacon             |

**3. What was the most common exclusion?**
```sql 
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
```
| most_common_exclusion |
| --------------------- |
| Cheese                |

**4. Generate an order item for each record in the customers_orders table in the format of one of the following:**
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers)

```sql 
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
```
| order_id | customer_id | pizza_id | exclusions           | extras         | order_item                                                       |
| -------- | ----------- | -------- | -------------------- | -------------- | ---------------------------------------------------------------- |
| 1        | 101         | 1        |                      |                | Meat Lovers                                                      |
| 2        | 101         | 1        |                      |                | Meat Lovers                                                      |
| 3        | 102         | 1        |                      |                | Meat Lovers                                                      |
| 3        | 102         | 2        |                      |                | Veggie Lovers                                                    |
| 4        | 103         | 1        | Cheese               |                | Meat Lovers - Exclude Cheese                                     |
| 4        | 103         | 2        | Cheese               |                | Veggie Lovers - Exclude Cheese                                   |
| 4        | 103         | 1        | Cheese               |                | Meat Lovers - Exclude Cheese                                     |
| 5        | 104         | 1        |                      | Bacon          | Meat Lovers - Extra Bacon                                        |
| 6        | 101         | 2        |                      |                | Veggie Lovers                                                    |
| 7        | 105         | 2        |                      | Bacon          | Veggie Lovers - Extra Bacon                                      |
| 8        | 102         | 1        |                      |                | Meat Lovers                                                      |
| 9        | 103         | 1        | Cheese               | Bacon, Chicken | Meat Lovers - Exclude Cheese - Extra Bacon, Chicken              |
| 10       | 104         | 1        | BBQ Sauce, Mushrooms | Bacon, Cheese  | Meat Lovers - Exclude BBQ Sauce, Mushrooms - Extra Bacon, Cheese |
| 10       | 104         | 1        |                      |                | Meat Lovers                                                      |

**5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients (For example: "Meat Lovers: 2xBacon, Beef, ... , Salami")**


```sql 
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

SELECT order_id, 
    customer_id, 
    pizza_id, 
    CASE WHEN pizza_id = 2 THEN concat('Meat Lovers: ', ingredients_list) 
        ELSE concat('Veggie Lovers: ', ingredients_list) END AS order_list
FROM ingredients_list;
```
| order_id | customer_id | pizza_id | order_list                                                                                   |
| -------- | ----------- | -------- | -------------------------------------------------------------------------------------------- |
| 1        | 101         | 1        | Veggie Lovers: BBQ Sauce, Bacon, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami         |
| 2        | 101         | 1        | Veggie Lovers: BBQ Sauce, Bacon, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami         |
| 3        | 102         | 1        | Veggie Lovers: BBQ Sauce, Bacon, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami         |
| 3        | 102         | 2        | Meat Lovers: Cheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes                      |
| 4        | 103         | 1        | Veggie Lovers: 2xCheese, BBQ Sauce, Bacon, Beef, Chicken, Mushrooms, Pepperoni, Salami       |
| 4        | 103         | 1        | Veggie Lovers: 2xCheese, BBQ Sauce, Bacon, Beef, Chicken, Mushrooms, Pepperoni, Salami       |
| 4        | 103         | 2        | Meat Lovers: 2xCheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes                    |
| 5        | 104         | 1        | Veggie Lovers: 2xBacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami       |
| 6        | 101         | 2        | Meat Lovers: Cheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes                      |
| 7        | 105         | 2        | Meat Lovers: Bacon, Cheese, Mushrooms, Onions, Peppers, Tomato Sauce, Tomatoes               |
| 8        | 102         | 1        | Veggie Lovers: BBQ Sauce, Bacon, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami         |
| 9        | 103         | 1        | Veggie Lovers: 2xBacon, 2xCheese, 2xChicken, BBQ Sauce, Beef, Mushrooms, Pepperoni, Salami   |
| 10       | 104         | 1        | Veggie Lovers: BBQ Sauce, Bacon, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami         |
| 10       | 104         | 1        | Veggie Lovers: 2xBBQ Sauce, 2xBacon, 2xCheese, 2xMushrooms, Beef, Chicken, Pepperoni, Salami |

**6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**
```sql 
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
  SELECT UNNEST(all_toppings) AS topping_id
  FROM orders)

SELECT pt.topping_name AS topping_name,
    COUNT(o.topping_id) AS quantity_used
FROM order_toppings_expanded o
JOIN pizza_runner.pizza_toppings pt
ON o.topping_id = pt.topping_id
GROUP BY 1
ORDER BY 2 DESC;
```
| topping_name | quantity_used |
| ------------ | ------------- |
| Cheese       | 19            |
| Mushrooms    | 15            |
| Bacon        | 14            |
| BBQ Sauce    | 11            |
| Chicken      | 11            |
| Pepperoni    | 10            |
| Salami       | 10            |
| Beef         | 10            |
| Tomato Sauce | 4             |
| Onions       | 4             |
| Tomatoes     | 4             |
| Peppers      | 4             |


### D. Pricing and Ratings
**1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?**
```sql 
WITH pizza_costs AS (
  SELECT *,
      CASE WHEN c.pizza_id = 1 THEN 12 
          ELSE 10 END AS pizza_cost
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL)

SELECT CONCAT('$', SUM(pizza_cost)) AS total_profit
FROM pizza_costs;
```
| total_profit |
| ------------ |
| $138         |

**2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra**
```sql 
WITH pizza_costs AS (
  SELECT *,
      CASE WHEN c.pizza_id = 1 AND c.extras IS NULL THEN 12 
          WHEN c.pizza_id = 2 AND c.extras IS NULL THEN 10
          WHEN c.pizza_id = 1 AND c.extras IS NOT NULL THEN CARDINALITY(c.extras) + 12
          WHEN c.pizza_id = 2 AND c.extras IS NOT NULL THEN CARDINALITY(c.extras) + 10 END AS pizza_cost
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL)
    
SELECT CONCAT('$', SUM(pizza_cost)) AS total_profit
FROM pizza_costs;
```
| total_profit |
| ------------ |
| $142         |

**3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.**
```sql 
DROP TABLE IF EXISTS customer_runner_ratings;

CREATE TABLE customer_runner_ratings AS (
  SELECT c.order_id,
  	  c.customer_id,
  	  r.runner_id
  FROM pizza_runner.customer_orders c
  JOIN pizza_runner.runner_orders r
  ON c.order_id = r.order_id
  	AND r.distance != 'null'
  GROUP BY 1,2,3
  ORDER BY 1);
  
ALTER TABLE customer_runner_ratings
	ADD runner_rating INT;

UPDATE customer_runner_ratings
SET runner_rating = 1
WHERE order_id = 1;

UPDATE customer_runner_ratings
SET runner_rating = 2
WHERE order_id = 5;

UPDATE customer_runner_ratings
SET runner_rating = 3
WHERE order_id = 8;

UPDATE customer_runner_ratings
SET runner_rating = 4
WHERE order_id IN (2,3,4);

UPDATE customer_runner_ratings
SET runner_rating = 5
WHERE order_id IN (7,10);

SELECT * 
FROM customer_runner_ratings;
```
| order_id | customer_id | runner_id | runner_rating |
| -------- | ----------- | --------- | ------------- |
| 1        | 101         | 1         | 1             |
| 5        | 104         | 3         | 2             |
| 8        | 102         | 2         | 3             |
| 2        | 101         | 1         | 4             |
| 3        | 102         | 1         | 4             |
| 4        | 103         | 2         | 4             |
| 7        | 105         | 2         | 5             |
| 10       | 104         | 1         | 5             |

**4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?**
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

```sql 
SELECT c.customer_id,
    c.order_id,
    r.runner_id,
    cr.runner_rating,
    c.order_time,
    r.pickup_time,
    CONCAT(ROUND((EXTRACT('EPOCH' FROM r.pickup_time) - EXTRACT('EPOCH' FROM c.order_time))/60), ' mins') AS time_btwn_order_pickup,
    r.duration AS delivery_duration,
    CONCAT(ROUND(AVG((r.distance)/(r.duration/60::numeric))::numeric, 2), ' km/h') AS avg_speed, 
    COUNT(c.order_id) AS total_pizzas
FROM customer_runner_ratings cr
JOIN customer_orders_temp c
ON cr.order_id = c.order_id
JOIN runner_orders_temp r
ON c.order_id = r.order_id
GROUP BY c.customer_id,
    c.order_id,
    r.runner_id,
    cr.runner_rating,
    c.order_time,
    r.pickup_time,
    r.duration,
    r.distance;
```
| customer_id | order_id | runner_id | runner_rating | order_time               | pickup_time              | time_btwn_order_pickup | delivery_duration | avg_speed  | total_pizzas |
| ----------- | -------- | --------- | ------------- | ------------------------ | ------------------------ | ---------------------- | ----------------- | ---------- | ------------ |
| 101         | 1        | 1         | 1             | 2020-01-01T18:05:02.000Z | 2020-01-01T18:15:34.000Z | 11 mins                | 32                | 37.50 km/h | 1            |
| 101         | 2        | 1         | 4             | 2020-01-01T19:00:52.000Z | 2020-01-01T19:10:54.000Z | 10 mins                | 27                | 44.44 km/h | 1            |
| 102         | 3        | 1         | 4             | 2020-01-02T23:51:23.000Z | 2020-01-03T00:12:37.000Z | 21 mins                | 20                | 40.20 km/h | 2            |
| 102         | 8        | 2         | 3             | 2020-01-09T23:54:33.000Z | 2020-01-10T00:15:02.000Z | 20 mins                | 15                | 93.60 km/h | 1            |
| 103         | 4        | 2         | 4             | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | 29 mins                | 40                | 35.10 km/h | 3            |
| 104         | 5        | 3         | 2             | 2020-01-08T21:00:29.000Z | 2020-01-08T21:10:57.000Z | 10 mins                | 15                | 40.00 km/h | 1            |
| 104         | 10       | 1         | 5             | 2020-01-11T18:34:49.000Z | 2020-01-11T18:50:20.000Z | 16 mins                | 10                | 60.00 km/h | 2            |
| 105         | 7        | 2         | 5             | 2020-01-08T21:20:29.000Z | 2020-01-08T21:30:45.000Z | 10 mins                | 25                | 60.00 km/h | 1            |


**5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?**
```sql 
WITH pizza_costs AS (
  SELECT *,
      CASE WHEN c.pizza_id = 1 THEN 12 
          ELSE 10 END AS pizza_cost,
      ROUND(r.distance::numeric*0.3, 2) AS delivery_cost
  FROM customer_orders_temp c
  JOIN runner_orders_temp r
  ON c.order_id = r.order_id
      AND r.cancellation IS NULL)
      
SELECT SUM(pizza_cost-delivery_cost) AS total_profit
FROM pizza_costs;
```
| total_profit |
| ------------ |
| 73.38        |


### E. Bonus Questions
**1. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?**
```sql 

```


