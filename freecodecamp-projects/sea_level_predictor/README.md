# [Sea Level Predictor](https://www.freecodecamp.org/learn/data-analysis-with-python/data-analysis-with-python-projects/sea-level-predictor)

## Instructions
This project is created using freeCodeCamp's [Replit starter code](https://replit.com/github/freeCodeCamp/boilerplate-demographic-data-analyzer).

Analyze a dataset of the global average sea level change since 1880. Use the data to predict the sea level change through year 2050.

Use the data to complete the following tasks:
- Use Pandas to import the data from `epa-sea-level.csv`.
- Use matplotlib to create a scatter plot using the `Year` column as the x-axis and the `CSIRO Adjusted Sea Level` column as the y-axis.
- Use the `linregress` function from `scipy.stats` to get the slope and y-intercept of the line of best fit. Plot the line of best fit over the top of the scatter plot. Make the line go through the year 2050 to predict the sea level rise in 2050.
- Plot a new line of best fit just using the data from year 2000 through the most recent year in the dataset. Make the line also go through the year 2050 to predict the sea level rise in 2050 if the rate of rise continues as it has since the year 2000.
- The x label should be `Year`, the y label should be `Sea Level (inches)`, and the title should be `Rise in Sea Level`.

The boilerplate also includes commands to save and return the image.

## Notes
- The project was tested using the provided unit tests in the starter code
- Link to Replit project: [Sea Level Predictor](https://replit.com/@ajchen97/sea-level-predictor)
