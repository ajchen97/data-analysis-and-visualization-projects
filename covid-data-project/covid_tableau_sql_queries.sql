-- Queries used for data visualization in Tableau


-- Global Numbers
SELECT SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  SUM(CAST(new_deaths AS numeric))/SUM(CAST(new_cases AS numeric))*100 AS global_death_percentage
FROM covid_deaths cd;

-- Total Death Count Per Continent
SELECT location, MAX(total_deaths) AS total_deaths_count
FROM covid_deaths cd
WHERE continent IS NULL 
  AND location NOT IN ('World', 'High income', 'Upper middle income', 'Lower middle income', 'European Union', 'Low income')
GROUP BY 1
ORDER BY 2 DESC;

-- Percent Population Infected Per Country
SELECT location, population, 
  MAX(total_cases) AS highest_infection_rate, 
  MAX(ROUND((CAST(total_cases AS numeric)/CAST(population AS numeric))*100, 2)) AS population_infection_percentage
FROM covid_deaths cd
GROUP BY 1,2
ORDER BY 4 DESC;

-- Percent Population Infected
SELECT location, population, date,
  MAX(total_cases) AS highest_infection_rate, 
  MAX(ROUND((CAST(total_cases AS numeric)/CAST(population AS numeric))*100, 2)) AS population_infection_percentage
FROM covid_deaths cd
GROUP BY 1,2,3
ORDER BY 5 DESC;
