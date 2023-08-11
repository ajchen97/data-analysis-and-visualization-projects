## COVID-19 Data Exploration SQL Queries & Results

***Start by selecting the data that will be used from the  `covid_deaths` datase: `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `population`.**
```sql 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths cd
WHERE location ILIKE '%states%'
ORDER BY 1,2
LIMIT 10;
```
|location   |date      |total_cases|new_cases|total_deaths|population|
|-----------|----------|-----------|---------|------------|----------|
|United States|2020-01-03||0||338289856|
|United States|2020-01-04||0||338289856|
|United States|2020-01-05||0||338289856|
|United States|2020-01-06||0||338289856|
|United States|2020-01-07||0||338289856|
|United States|2020-01-08||0||338289856|
|United States|2020-01-09||0||338289856|
|United States|2020-01-10||0||338289856|
|United States|2020-01-11||0||338289856|
|United States|2020-01-12||0||338289856|

**1. What is the total number of cases versus the total number of deaths in each country and the percentage of deaths?**

The percentage shows the likelihood of dying if you contract covid in your country. The query below shows the percentage of death for those that contracted covid in the United States between August 1, 2020 and August 15, 2020.
```sql 
SELECT location, date, total_cases, total_deaths,
  ROUND((total_deaths/CAST(total_cases AS numeric))*100, 2) AS death_percentage
FROM covid_deaths cd
WHERE location ILIKE '%united states'
  AND date BETWEEN '2020-08-01' AND '2020-08-15'
ORDER BY 1,2;
```
|location |date |total_cases |total_deaths |death_percentage |
| --- | --- | --- | --- | --- |
|United States|2020-08-01|4556982|158367|3.48|
|United States|2020-08-02|4625166|159736|3.45|
|United States|2020-08-03|4681578|160900|3.44|
|United States|2020-08-04|4732427|161822|3.42|
|United States|2020-08-05|4777756|162675|3.40|
|United States|2020-08-06|4829812|163747|3.39|
|United States|2020-08-07|4885404|165007|3.38|
|United States|2020-08-08|4938569|166218|3.37|
|United States|2020-08-09|5001075|167535|3.35|
|United States|2020-08-10|5052754|168578|3.34|
|United States|2020-08-11|5099227|169478|3.32|
|United States|2020-08-12|5142604|170273|3.31|
|United States|2020-08-13|5201562|171371|3.29|
|United States|2020-08-14|5255954|172697|3.29|
|United States|2020-08-15|5307476|173892|3.28|


**2. What is the total number of cases versus the population in each country and the percentage of infection?**

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
