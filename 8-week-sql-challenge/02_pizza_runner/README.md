# :pizza: [Case Study #2](https://8weeksqlchallenge.com/case-study-2/) - Pizza Runner
<p align="center"> <img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="Image" width="500" height="520">

## Introduction
Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.
  
## Datasets
  - **runner:** shows the registration_date for each new runner
  - **customer_orders:** captures customer pizza orders with 1 row for each individual pizza that is part of the order; the pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza
  - **runner_orders:** captures the order_id, runner_id, cancellation; pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas; distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer
  - **pizza_names:** the pizzas available
  - **pizza_recipes:** each pizza_id has a standard set of toppings which are used as part of the pizza recipe
  - **pizza_toppings:** contains all of the topping_name values with their corresponding topping_id value

## Entity Relationship Diagram  
<p align="center"> <img src="https://user-images.githubusercontent.com/19737483/223602648-af46ce57-76ce-4754-bfd2-cf79829f840c.png" alt="Image">

## Case Study Questions
<details> <summary> A. Pizza Metrics </summary> 
  
  1. How many pizzas were ordered?
  2. How many unique customer orders were made?
  3. How many successful orders were delivered by each runner?
  4. How many of each type of pizza was delivered?
  5. How many Vegetarian and Meatlovers were ordered by each customer?
  6. What was the maximum number of pizzas delivered in a single order?
  7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
  8. How many pizzas were delivered that had both exclusions and extras?
  9. What was the total volume of pizzas ordered for each hour of the day?
  10. What was the volume of orders for each day of the week? </details>

<details> <summary> B. Runner and Customer Experience </summary>
  
  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
  2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
  3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
  4. What was the average distance travelled for each customer?
  5. What was the difference between the longest and shortest delivery times for all orders?
  6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
  7. What is the successful delivery percentage for each runner? </details>

<details> <summary> C. Ingredient Optimisation </summary> 
  
  1. What are the standard ingredients for each pizza?
  2. What was the most commonly added extra?
  3. What was the most common exclusion?
  4. Generate an order item for each record in the customers_orders table in the format of one of the following:
  - Meat Lovers
  - Meat Lovers - Exclude Beef
  - Meat Lovers - Extra Bacon
  - Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
  5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
  - For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
  6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first? </details>

<details> <summary> D. Pricing and Ratings </summary> 
  
  1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
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
  5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries? </details>

<details><summary> E. Bonus Questions </summary> 
  
  1. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu? </details>
  
## Notes
Before I start on the questions, the data needs to be cleaned and transformed to improve the accuracy and consistency of the data. I will use the resulting cleaned data to query from. The steps I have taken to clean the data can be found [here](https://github.com/ajchen97/data-analysis-and-visualization-projects/blob/main/8-week-sql-challenge/02_pizza_runner/pizza_runner_data_cleaning.md).
