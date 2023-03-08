# [Case Study #2](https://8weeksqlchallenge.com/case-study-2/) - Pizza Runner Data Cleaning

## customer_orders table
- create a temporary table 'customer_orders_temp' using a select statement
- 'exclusions': use CASE to replace any 'null' string values or '' string values with NULL value and convert the string into an array of integers
- 'extras': use CASE to replace any 'null' string values or '' string values with NULL value and convert the string into an array of integers

```sql
DROP TABLE IF EXISTS customer_orders_temp;

CREATE TEMP TABLE customer_orders_temp AS (
  SELECT order_id,
  	customer_id,
  	pizza_id, 
  	CASE WHEN exclusions = 'null' or exclusions = '' THEN NULL
  	ELSE STRING_TO_ARRAY(exclusions, ',')::int[] END AS exclusions,
   	CASE WHEN extras = 'null' or extras = '' THEN NULL
  	ELSE STRING_TO_ARRAY(extras, ',')::int[] END AS extras,
    order_time
  FROM pizza_runner.customer_orders
); 
```

## runner_orders table
- create a temporary table 'runner_orders_temp' using a select statement
- 'pickup_time': use CASE to replace any 'null' string values or '' string values with NULL value, then convert to datatype to timestamp
- 'distance': use CASE to replace any 'null' string values or '' string values with NULL value and TRIM to remove any strings then convert datatype to real
- 'duration': use CASE to replace any 'null' string values or '' string values with NULL value and TRIM to remove any strings then convert datatype to integer
- 'cancellation': use CASE to replace any 'null' string values or '' string values with NULL value

```sql
DROP TABLE IF EXISTS runner_orders_temp; 

CREATE TEMP TABLE runner_orders_temp AS (
  SELECT order_id, 
  	runner_id,
  	CASE WHEN pickup_time = 'null' or pickup_time = '' THEN NULL 
  	ELSE pickup_time::timestamp END AS pickup_time,
    CASE WHEN distance = 'null' or distance = '' THEN NULL
    ELSE TRIM(trailing 'km' FROM distance)::real END AS distance,
    CASE WHEN duration = 'null' or duration = '' THEN NULL
    ELSE TRIM(trailing 'minutes' FROM duration)::integer END AS duration,
    CASE WHEN cancellation = 'null' or cancellation = '' THEN NULL
    ELSE cancellation END AS cancellation
  FROM pizza_runner.runner_orders
); 
```

## pizza_recipes table
- create a temporary table 'pizza_recipes_temp' using a select statement
- 'toppings': use CASE to replace any 'null' string values or '' string values with NULL value and convert string to an array of integers

```sql
DROP TABLE IF EXISTS pizza_recipes_temp; 

CREATE TEMP TABLE pizza_recipes_temp AS (
  SELECT pizza_id, 
	CASE WHEN toppings = 'null' or toppings = '' THEN NULL
  	ELSE STRING_TO_ARRAY(toppings, ',')::int[] END AS toppings
  FROM pizza_runner.pizza_recipes
); 
```
