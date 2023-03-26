## [Case Study #2](https://8weeksqlchallenge.com/case-study-2/) - Pizza Runner Results

### A. Pizza Metrics
**1. How many pizzas were ordered?**
| total_pizzas |
| ------------ |
| 14           |

**2. How many unique customer orders were made?**
| unique_orders |
| ------------- |
| 10            |

**3. How many successful orders were delivered by each runner?**
| runner_id | successful_orders |
| --------- | ----------------- |
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

**4. How many of each type of pizza was delivered?**
| pizza_name | num_delivered |
| ---------- | ------------- |
| Vegetarian | 3             |
| Meatlovers | 9             |

**5. How many Vegetarian and Meatlovers were ordered by each customer?**
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
| max_delivered |
| ------------- |
| 3             |

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
| customer_id | any_changes | no_changes |
| ----------- | ----------- | ---------- |
| 101         | 0           | 2          |
| 102         | 0           | 3          |
| 103         | 3           | 0          |
| 104         | 2           | 1          |
| 105         | 1           | 0          |

**8. How many pizzas were delivered that had both exclusions and extras?**
| both_changes_pizzas |
| ------------------- |
| 3                   |

**9. What was the total volume of pizzas ordered for each hour of the day?**
| hour_of_day | pizzas_ordered |
| ----------- | -------------- |
| 11          | 1              |
| 13          | 3              |
| 18          | 3              |
| 19          | 1              |
| 21          | 3              |
| 23          | 3              |

**10. What was the volume of orders for each day of the week?**
| day_of_week | pizzas_ordered |
| ----------- | -------------- |
| Friday      | 1              |
| Thursday    | 3              |
| Saturday    | 5              |
| Wednesday   | 5              |


### B. Runner and Customer Experience
**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**
| registration_week | sign_ups |
| ----------------- | -------- |
| 1                 | 2        |
| 2                 | 1        |
| 3                 | 1        |

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
| runner_id | avg_arrival |
| --------- | ----------- |
| 1         | 15.68 mins  |
| 2         | 10.47 mins  |
| 3         | 23.72 mins  |

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**
| pizza_count | avg_prep   |
| ----------- | ---------- |
| 1           | 12.36 mins |
| 2           | 18.38 mins |
| 3           | 29.28 mins |

**4. What was the average distance travelled for each customer?**
| customer_id | avg_distance |
| ----------- | ------------ |
| 101         | 20.00 km     |
| 102         | 16.73 km     |
| 103         | 23.40 km     |
| 104         | 10.00 km     |
| 105         | 25.00 km     |

**5. What was the difference between the longest and shortest delivery times for all orders?**
| delivery_time_difference |
| ------------------------ |
| 30 mins                  |

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**
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
| runner_id | success_percent |
| --------- | --------------- |
| 1         | 100%            |
| 2         | 75%             |
| 3         | 50%             |


### C. Ingredient Optimisation
**1. What are the standard ingredients for each pizza?**
| pizza_name | ingredients                                                    |
| ---------- | -------------------------------------------------------------- |
| Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami |
| Vegetarian | Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce          |

**2. What was the most commonly added extra?**
| most_common_extra |
| ----------------- |
| Bacon             |

**3. What was the most common exclusion?**

**4. Generate an order item for each record in the customers_orders table in the format of one of the following: (Meat Lovers), (Meat Lovers - Exclude Beef), (Meat Lovers - Extra Bacon), (Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers)**

**5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients (For example: "Meat Lovers: 2xBacon, Beef, ... , Salami") **

**6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**

### D. Pricing and Ratings
**1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?**

2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
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
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

### E. Bonus Questions
**1. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?**
