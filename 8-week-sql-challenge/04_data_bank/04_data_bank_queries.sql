-- https://8weeksqlchallenge.com/case-study-4/

-- A. Customer Nodes Exploration
-- 1. How many unique nodes are there on the Data Bank system?
-- 2. What is the number of nodes per region?
-- 3. How many customers are allocated to each region?
-- 4. How many days on average are customers reallocated to a different node?
-- 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?



-- B. Customer Transactions
-- 1. What is the unique count and total amount for each transaction type?
-- 2. What is the average total historical deposit counts and amounts for all customers?
-- 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
-- 4. What is the closing balance for each customer at the end of the month?
-- 5. What is the percentage of customers who increase their closing balance by more than 5%? 



-- C. Data Allocation Challenge 
/** 
To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:
  - Option 1: data is allocated based off the amount of money at the end of the previous month
  - Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
  - Option 3: data is updated real-time
  1. For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:
  - running customer balance column that includes the impact each transaction
  - customer balance at the end of each month
  - minimum, average and maximum values of the running balance for each customer
  2. Using all of the data available - how much data would have been required for each option on a monthly basis? 
**/





-- D. Extra Challenge
/** 
Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.
  1. If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based off the interest calculated on a daily basis at the end of each day, how much data would be required for this option on a monthly basis?

Special notes:
  - Data Bank wants an initial calculation which does not allow for compounding interest, however they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina! 
**/
