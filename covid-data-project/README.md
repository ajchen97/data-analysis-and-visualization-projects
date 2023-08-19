# COVID-19 Data Exploration & Visualization Project

## About the Project
In this project, I am exploring global COVID-19 data using PostgreSQL and creating a dashboard of visualizations using Tableau. The data is obtained from [Our World in Data](https://ourworldindata.org/covid-deaths), which provides data on the number of **confirmed** deaths from COVID-19. I have split the data into two datasets: `covid_deaths` and `covid_vaccinations`. The skills I used in this project include joins, CTE's, temp tables, window functions, aggregate functions, views, and data conversion.

## Datasets
- **`covid_deaths`:** contains data related to covid deaths
- **`covid_vaccinations`:** contains data related to covid vaccinations
  
## Information to Explore
1. What is the total number of cases versus the total number of deaths in each country and the percentage of deaths?
2. What is the total number of cases versus the population in each country and the percentage of infection?
3. What are the highest infection rates compared to the population for each country?
4. What are the countries with the highest death count per population?
5. Which continents have the highest death count per population?
6. What is the total number of cases versus deaths globally, and the percentage of deaths?
7. What is the total population versus the total vaccinations?
8. Use a CTE to perform Calculation on Partition By in the previous question.
9. Use a Temp Table to perform Calculation on Partition By in the previous question.
10. Create a View to store data for later visualizations.

## Data Visualization
Below is a screenshot of a dashboard of visualizations created in Tableau. To view the live dashboard, visit this [link](https://public.tableau.com/app/profile/amandachen/viz/COVID-19ProjectDashboard_16921382026580/Dashboard1).

![covid_project_dashboard](https://github.com/ajchen97/data-analysis-and-visualization-projects/assets/19737483/24ecc2a4-19da-49ad-bfd8-b865c1308c63)
