## [Case Study #3](https://8weeksqlchallenge.com/case-study-3/) - Foodie-Fi Results

### A. Customer Journey
**1. Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey. (Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!)**
```sql 
SELECT s.customer_id, 
    s.plan_id,
    s.start_date,
    p.plan_name,
    p.price
FROM foodie_fi.subscriptions s 
JOIN foodie_fi.plans p
ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19)
ORDER BY s.customer_id, s.start_date;
```
| customer_id | plan_id | start_date               | plan_name     | price  |
| ----------- | ------- | ------------------------ | ------------- | ------ |
| 1           | 0       | 2020-08-01T00:00:00.000Z | trial         | 0.00   |
| 1           | 1       | 2020-08-08T00:00:00.000Z | basic monthly | 9.90   |
| 2           | 0       | 2020-09-20T00:00:00.000Z | trial         | 0.00   |
| 2           | 3       | 2020-09-27T00:00:00.000Z | pro annual    | 199.00 |
| 11          | 0       | 2020-11-19T00:00:00.000Z | trial         | 0.00   |
| 11          | 4       | 2020-11-26T00:00:00.000Z | churn         |        |
| 13          | 0       | 2020-12-15T00:00:00.000Z | trial         | 0.00   |
| 13          | 1       | 2020-12-22T00:00:00.000Z | basic monthly | 9.90   |
| 13          | 2       | 2021-03-29T00:00:00.000Z | pro monthly   | 19.90  |
| 15          | 0       | 2020-03-17T00:00:00.000Z | trial         | 0.00   |
| 15          | 2       | 2020-03-24T00:00:00.000Z | pro monthly   | 19.90  |
| 15          | 4       | 2020-04-29T00:00:00.000Z | churn         |        |
| 16          | 0       | 2020-05-31T00:00:00.000Z | trial         | 0.00   |
| 16          | 1       | 2020-06-07T00:00:00.000Z | basic monthly | 9.90   |
| 16          | 3       | 2020-10-21T00:00:00.000Z | pro annual    | 199.00 |
| 18          | 0       | 2020-07-06T00:00:00.000Z | trial         | 0.00   |
| 18          | 2       | 2020-07-13T00:00:00.000Z | pro monthly   | 19.90  |
| 19          | 0       | 2020-06-22T00:00:00.000Z | trial         | 0.00   |
| 19          | 2       | 2020-06-29T00:00:00.000Z | pro monthly   | 19.90  |
| 19          | 3       | 2020-08-29T00:00:00.000Z | pro annual    | 199.00 |

Descriptions:
- customer_id 1: did a free trial & decided to purchase the basic monthly plan at the end of the trial
- customer_id 2: did a free trial & decided to purchase the pro annual plan at the end of the trial
- customer_id 11: did a free trial & decided to cancel the trial/not make a purchase
- customer_id 13: did a free trial & decided to purchase the basic monthly plan at the end of the trial then upgraded to the pro monthly plan after 3 months
- customer_id 15: did a free trial & decided to purchase the basic monthly plan at the end of the trial, but then canceled their subscription one month later
- customer_id 16: did a free trial & decided to purchase the basic monthly plan at the end of the trial then upgraded to the pro annual plan after 4 months
- customer_id 18: did a free trial & decided to purchase the pro monthly plan at the end of the trial
- customer_id 19: did a free trial & decided to purchase the pro monthly plan at the end of the trial then upgraded to the pro annual plan after 2 months


### B. Data Analysis Questions
**1. How many customers has Foodie-Fi ever had?**
```sql 
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;
```
| total_customers |
| --------------- |
| 1000            |

**2. What is the monthly distribution of trial plan start_date values for our dataset? Use the start of the month as the group by value**
```sql 
SELECT EXTRACT('month' FROM start_date) AS month,
    COUNT(*) AS trial_distribution
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY 1
ORDER BY 1;
```
| month | trial_distribution |
| ----- | ------------------ |
| 1     | 88                 |
| 2     | 68                 |
| 3     | 94                 |
| 4     | 81                 |
| 5     | 88                 |
| 6     | 79                 |
| 7     | 89                 |
| 8     | 88                 |
| 9     | 87                 |
| 10    | 79                 |
| 11    | 75                 |
| 12    | 84                 |

**3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**
```sql 
SELECT p.plan_name,
    COUNT(*) AS events_2021
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p 
ON s.plan_id = p.plan_id
WHERE s.start_date > '12-31-2020'
GROUP BY 1
ORDER BY 2;
```
| plan_name     | events_2021 |
| ------------- | ----------- |
| basic monthly | 8           |
| pro monthly   | 60          |
| pro annual    | 63          |
| churn         | 71          |

**4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**
```sql 


```

**5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**
```sql 


```

**6. What is the number and percentage of customer plans after their initial free trial?**
```sql 


```

**7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?**
```sql 


```

**8. How many customers have upgraded to an annual plan in 2020?**
```sql 


```

**9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**
```sql 


```

**10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)?**
```sql 


```

**11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**
```sql 


```



### C. Challenge Payment Question
**1. The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:**
  - monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
  - upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
  - upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
  - once a customer churns they will no longer make payments


### D. Outside The Box Questions
**1. How would you calculate the rate of growth for Foodie-Fi?**

**2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?**

**3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?**

**4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in 
the survey?**

**5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?**
