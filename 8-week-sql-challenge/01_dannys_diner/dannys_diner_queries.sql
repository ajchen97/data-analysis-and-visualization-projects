-- https://8weeksqlchallenge.com/case-study-1/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT sales.customer_id AS customer_id, 
    SUM(menu.price) AS total_spent
FROM dannys_diner.sales
LEFT JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1

-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, 
	COUNT(DISTINCT order_date) AS days_visited
FROM dannys_diner.sales
GROUP BY 1

-- 3. What was the first item from the menu purchased by each customer?
SELECT customer_id, product_name
FROM (
  SELECT *,
      ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_num
  FROM dannys_diner.sales
  LEFT JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
  ORDER BY customer_id, order_date) items
WHERE row_num = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
