## [Case Study #1](https://8weeksqlchallenge.com/case-study-1/) - Danny's Diner Results

**1. What is the total amount each customer spent at the restaurant?**
| customer_id | total_spent |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

**2. How many days has each customer visited the restaurant?**
| customer_id | days_visited |
| ----------- | ------------ |
| A           | 4            |
| B           | 6            |
| C           | 2            |

**3. What was the first item from the menu purchased by each customer?**
| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
| product_name | purchase_count |
| ------------ | -------------- |
| ramen        | 8              |

**5. Which item was the most popular for each customer?**
| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | ramen        |
| B           | curry        |
| B           | sushi        |
| C           | ramen        |

**6. Which item was purchased first by the customer after they became a member?**
| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| B           | sushi        |

**7. Which item was purchased just before the customer became a member?**
| customer_id | product_name |
| ----------- | ------------ |
| A           | sushi        |
| A           | curry        |
| B           | sushi        |

**8. What is the total items and amount spent for each member before they became a member?**
| customer_id | total_items | total_spent |
| ----------- | ----------- | ----------- |
| A           | 2           | 25          |
| B           | 3           | 40          |

**9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
| customer_id | points |
| ----------- | ------ |
| A           | 860    |
| B           | 940    |
| C           | 360    |

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**
| customer_id | total_points |
| ----------- | ------------ |
| A           | 1370         |
| B           | 940          |
