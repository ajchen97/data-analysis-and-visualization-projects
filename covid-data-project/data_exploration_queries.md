## COVID-19 Data Exploration SQL Queries & Results

***Start by selecting the data that will be used from the  `covid_deaths` datase: `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `population`.**
```sql 
SELECT location, CAST(date AS date), total_cases, new_cases, total_deaths, population
FROM covid_deaths cd
ORDER BY 1,2
LIMIT 10;
```
|location   |date      |total_cases|new_cases|total_deaths|population|
|-----------|----------|-----------|---------|------------|----------|
|Afghanistan|2020-01-03|           |        0|            |  41128772|
|Afghanistan|2020-01-04|           |        0|            |  41128772|
|Afghanistan|2020-01-05|           |        0|            |  41128772|
|Afghanistan|2020-01-06|           |        0|            |  41128772|
|Afghanistan|2020-01-07|           |        0|            |  41128772|
|Afghanistan|2020-01-08|           |        0|            |  41128772|
|Afghanistan|2020-01-09|           |        0|            |  41128772|
|Afghanistan|2020-01-10|           |        0|            |  41128772|
|Afghanistan|2020-01-11|           |        0|            |  41128772|
|Afghanistan|2020-01-12|           |        0|            |  41128772|

**1. What is the total number of cases versus the total number of deaths and the percentage of deaths?**

This shows the likelihood of dying if you contract covid in your country.
```sql 


```


**2. What is the total number of cases versus the population and the percentage of infection**

This shows what percentage of the population is infected with Covid.
```sql 


```


**3. What are the countries with the highest infection rate compared to the population?**
```sql 


```


**4. What are the countries with the highest death count per population?**
```sql 


```


**5. Which continents have the highest death count per population?**
```sql 


```


**6. What is the total population versus the total vaccinations and the percentage of the population that has at least one covid vaccination?**

This shows the percentage of the population that has received at least one covid vaccination.
```sql 


```


**7. Use a CTE to perform Calculation on Partition By in the previous question.**
```sql 


```


**8. Use a Temp Table to perform Calculation on Partition By in the previous question.**
```sql 


```


**9. Create a View to store data for later visualizations.**
```sql 


```
