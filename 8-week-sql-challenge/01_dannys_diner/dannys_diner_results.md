## [Case Study #1](https://8weeksqlchallenge.com/case-study-1/) - Danny's Diner Results

**1. What is the total amount each customer spent at the restaurant?**
```sql 
SELECT sales.customer_id AS customer_id, 
    SUM(menu.price) AS total_spent
FROM dannys_diner.sales
LEFT JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;
```
| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

**2. How many days has each customer visited the restaurant?**
```sql 
SELECT customer_id, 
    COUNT(DISTINCT order_date) AS days_visited
FROM dannys_diner.sales
GROUP BY 1;
```
| customer_id | days_visited |
| ----------- | ------------ |
| A           | 4            |
| B           | 6            |
| C           | 2            |

**3. What was the first item from the menu purchased by each customer?**
```sql 
SELECT DISTINCT customer_id, product_name
FROM (
  SELECT *,
      RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS ranking
  FROM dannys_diner.sales
  LEFT JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
  ORDER BY customer_id, order_date) items
WHERE ranking = 1;
```
| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
```sql 
WITH items AS (
  SELECT menu.product_name,
      COUNT(sales.product_id) AS purchase_count
  FROM dannys_diner.sales
  LEFT JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id 
  GROUP BY 1)

SELECT product_name, purchase_count
FROM items
WHERE purchase_count = (
  SELECT MAX(purchase_count)
  FROM items);
```
| product_name | purchase_count |
| ------------ | -------------- |
| ramen        | 8              |

**5. Which item was the most popular for each customer?**
```sql 
WITH items AS (
  SELECT customer_id, 
      product_name,
      COUNT(product_name) AS purchases
  FROM dannys_diner.sales
  LEFT JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id 
  GROUP BY 1,2
  ORDER BY 1,3 DESC),
ranking AS (
  SELECT customer_id, 
      product_name, 
      purchases,
      RANK() OVER (PARTITION BY customer_id ORDER BY purchases DESC) AS ranking
  FROM items)

SELECT customer_id, product_name
FROM ranking
WHERE ranking = 1;
```
| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | ramen        |
| B           | curry        |
| B           | sushi        |
| C           | ramen        |

**6. Which item was purchased first by the customer after they became a member?**
```sql 
WITH customers AS (
  SELECT sales.customer_id AS customer_id, 
      sales.order_date, 
      members.join_date,
      menu.product_name AS product_name,
      RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS ranking
  FROM dannys_diner.sales
  JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
      AND members.join_date <= sales.order_date
  JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
  ORDER BY sales.customer_id, sales.order_date)

SELECT customer_id, product_name
FROM customers
WHERE ranking = 1;
```
| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| B           | sushi        |

**7. Which item was purchased just before the customer became a member?**
```sql 
WITH customers AS (
  SELECT sales.customer_id AS customer_id, 
      sales.order_date, 
      members.join_date,
      menu.product_name AS product_name,
      RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS ranking
  FROM dannys_diner.sales
  JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
      AND members.join_date > sales.order_date
  JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
  ORDER BY sales.customer_id)

SELECT customer_id, product_name
FROM customers
WHERE ranking = 1;
```
| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi        |
| A           | curry        |
| B           | sushi        |

**8. What is the total items and amount spent for each member before they became a member?**
```sql 
SELECT sales.customer_id AS customer_id, 
    COUNT(menu.product_name) AS total_items,
    SUM(menu.price) AS total_spent
FROM dannys_diner.sales
JOIN dannys_diner.members
ON sales.customer_id = members.customer_id
    AND members.join_date > sales.order_date
JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;
```
| customer_id | total_items | total_spent |
| ----------- | ----------- | ----------- |
| A           | 2           | 25          |
| B           | 3           | 40          |

**9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```sql 
SELECT sales.customer_id,
    SUM(CASE WHEN menu.product_name = 'sushi' THEN 20*menu.price ELSE 10*menu.price END) AS points
FROM dannys_diner.sales
JOIN dannys_diner.menu
ON sales.product_id = menu.product_id
GROUP BY 1
ORDER BY 1;
```
| customer_id | points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**
```sql 
WITH points AS (
  SELECT sales.customer_id, 
      sales.order_date, 
      members.join_date, 
      menu.product_name, 
      menu.price,
      CASE WHEN (sales.order_date < members.join_date OR sales.order_date > members.join_date + 7) AND menu.product_name = 'sushi' THEN 20*menu.price
          WHEN (sales.order_date < members.join_date OR sales.order_date > members.join_date + 7) AND menu.product_name != 'sushi' THEN 10*menu.price 
          WHEN sales.order_date BETWEEN members.join_date AND members.join_date + 7 THEN 20*menu.price END AS points
  FROM dannys_diner.sales
  JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
  JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
  ORDER BY sales.customer_id, sales.order_date)

SELECT customer_id, 
    SUM(points) AS total_points
FROM points
WHERE customer_id in ('A', 'B')
    AND EXTRACT('month' FROM order_date) = '01'
GROUP BY 1;
```
| customer_id | total_points |
| ----------- | ------------ |
| A           | 1370         |
| B           | 940          |
