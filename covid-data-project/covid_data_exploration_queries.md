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
--  AND date BETWEEN '2020-08-01' AND '2020-08-15'
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

The percentage shows how much of the population is infected with covid. The query below shows the percentage of the population infected in the United States between August 1, 2020 and August 15, 2020.
```sql 
SELECT location, date, total_cases, population, 
  ROUND((CAST(total_cases AS numeric)/CAST(population AS numeric))*100, 2) AS population_infection_percentage
FROM covid_deaths cd
WHERE location ILIKE '%united states'
--  AND date BETWEEN '2020-08-01' AND '2020-08-15'
ORDER BY 1,2;
```
|location|date|total_cases|population|population_infection_percentage|
|-|-|-|-|-|
|United States|2020-08-01|4556982|338289856|1.35|
|United States|2020-08-02|4625166|338289856|1.37|
|United States|2020-08-03|4681578|338289856|1.38|
|United States|2020-08-04|4732427|338289856|1.40|
|United States|2020-08-05|4777756|338289856|1.41|
|United States|2020-08-06|4829812|338289856|1.43|
|United States|2020-08-07|4885404|338289856|1.44|
|United States|2020-08-08|4938569|338289856|1.46|
|United States|2020-08-09|5001075|338289856|1.48|
|United States|2020-08-10|5052754|338289856|1.49|
|United States|2020-08-11|5099227|338289856|1.51|
|United States|2020-08-12|5142604|338289856|1.52|
|United States|2020-08-13|5201562|338289856|1.54|
|United States|2020-08-14|5255954|338289856|1.55|
|United States|2020-08-15|5307476|338289856|1.57|


**3. What are the highest infection rates compared to the population of each country?**
```sql 
SELECT location, population, 
  MAX(total_cases) AS highest_infection_rate, 
  MAX(ROUND((CAST(total_cases AS numeric)/CAST(population AS numeric))*100, 2)) AS population_infection_percentage
FROM covid_deaths cd
-- WHERE total_cases IS NOT NULL
GROUP BY 1,2
ORDER BY 4 DESC
LIMIT 10;
```
location|population|highest_infection_rate|population_infection_percentage
|-|-|-|-|
Cyprus|896007|660854|73.76
San Marino|33690|24367|72.33
Brunei|449002|310019|69.05
Austria|8939617|6081287|68.03
Faeroe Islands|53117|34658|65.25
South Korea|51815808|33201796|64.08
Slovenia|2119843|1344637|63.43
Gibraltar|32677|20550|62.89
Martinique|367512|230354|62.68
Andorra|79843|48015|60.14


**4. What are the countries with the highest death count per population?**
```sql 
SELECT location, MAX(total_deaths) AS total_deaths_count
FROM covid_deaths cd
WHERE continent IS NOT NULL 
--  AND total_deaths IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```
location|total_deaths_count
|-|-|
United States|1127152
Brazil|704659
India|531917
Russia|399854
Mexico|334336
United Kingdom|228429
Peru|221364
Italy|191012
Germany|174979
France|167985


**5. Which continents have the highest death count per population?**
```sql 
SELECT location, MAX(total_deaths) AS total_deaths_count
FROM covid_deaths cd
WHERE continent IS NULL 
  AND location NOT IN ('World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Low income')
GROUP BY 1
ORDER BY 2 DESC;
```
continent|total_deaths_count
|-|-|
Europe|2074440
Asia|1632364
North America|1602820
South America|1356054
Africa|259001
Oceania|29046

**6. What is the total number of cases versus deaths globally, and the percentage of deaths?**
```sql 
SELECT SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  SUM(CAST(new_deaths AS numeric))/SUM(CAST(new_cases AS numeric))*100 AS global_death_percentage
FROM covid_deaths cd;
```
total_cases|total_deaths|global_death_percentage
|-|-|-|
3258495536|29563200|0.90726532147687435100


**7. What is the total population versus the total vaccinations?**

This shows the number of new vaccinations by location and date and the rolling total of vaccinations as of date.
```sql 
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
  SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_new_vaccination_count
FROM covid_deaths cd
JOIN covid_vaccinations cv
ON cd.location = cv.location
  AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;
```


**8. Use a CTE to perform Calculation on Partition By in the previous question.**

This shows the percentage of the population that has received at least one covid vaccination.
```sql 
WITH pop_vacc AS (
  SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_new_vaccination_count
  FROM covid_deaths cd
  JOIN covid_vaccinations cv
  ON cd.location = cv.location
    AND cd.date = cv.date
  WHERE cd.continent IS NOT NULL
  ORDER BY 2,3)

SELECT *, 
  (rolling_new_vaccination_count/population)*100 AS population_vaccinated_percentage
FROM pop_vacc;
```


**9. Use a Temp Table to perform Calculation on Partition By in the previous question.**
```sql 


```


**10. Create a View to store data for later visualizations.**
```sql 
CREATE VIEW rolling_vaccination_count AS 
  SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
    SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_new_vaccination_count
  FROM covid_deaths cd
  JOIN covid_vaccinations cv
  ON cd.location = cv.location
    AND cd.date = cv.date
  WHERE cd.continent IS NOT NULL
  ORDER BY 2,3;
```
