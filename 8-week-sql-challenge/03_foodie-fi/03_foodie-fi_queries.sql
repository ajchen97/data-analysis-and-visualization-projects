-- https://8weeksqlchallenge.com/case-study-3/

-- A. Customer Journey
-- 1. Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.
SELECT s.customer_id, 
    s.plan_id,
    s.start_date,
    p.plan_name,
    p.price
FROM foodie_fi.subscriptions s 
JOIN foodie_fi.plans p
ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19)
ORDER BY s.customer_id, s.start_date


-- B. Data Analysis Questions
-- 1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;

-- 2. What is the monthly distribution of trial plan start_date values for our dataset? Use the start of the month as the group by value\
SELECT EXTRACT('month' FROM start_date) AS month,
    COUNT(*) AS trial_distribution
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY 1
ORDER BY 1;

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT p.plan_name,
    COUNT(*) AS events_2021
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p 
ON s.plan_id = p.plan_id
WHERE s.start_date > '12-31-2020'
GROUP BY 1
ORDER BY 2;

-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT CONCAT(ROUND(((COUNT(DISTINCT customer_id) FILTER (WHERE plan_id = 4))::numeric/COUNT(DISTINCT customer_id)::numeric*100), 1), '%') AS percent_churned
FROM foodie_fi.subscriptions;

-- 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH next_plan AS (
  SELECT *, 
      LEAD(plan_id) OVER (PARTITION BY customer_id ORDER BY start_date) AS next_plan
  FROM foodie_fi.subscriptions)

SELECT CONCAT(ROUND(((COUNT(DISTINCT customer_id) FILTER (WHERE plan_id = 0 AND next_plan = 4))::numeric/COUNT(DISTINCT customer_id)::numeric)*100), '%') AS percent_churned_after_trial
FROM next_plan;
 
-- 6. What is the number and percentage of customer plans after their initial free trial?

-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

-- 8. How many customers have upgraded to an annual plan in 2020?

-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)?

-- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?



-- C. Challenge Payment Question 
/**1. The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:
  - monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
  - upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
  - upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
  - once a customer churns they will no longer make payments **/
