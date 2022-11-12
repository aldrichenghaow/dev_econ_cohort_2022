# This R script file contains solutions to exercises in our first workbook.

# Exercise 1 - Histogram
ggplot(data = gapminder, 
       mapping = aes(x = lifeExp)) +
  geom_histogram(binwidth = 3, 
                 fill = "maroon") + 
  facet_wrap(facets = vars(continent)) + # the most important line of the code
  labs(title = "Histogram of Life Expectancy",
       x = "Life Expectancy",
       y = "Count of Observations")

# Exercise 2 - Violin Plot
ggplot(data = gapminder, mapping = aes(x = continent, y = lifeExp)) +
  geom_violin() + # just change it to geom_violin()
  labs(title = "Distribution of Life Expectancy by Continent",
       x = "Continent",
       y = "Life Expectancy")

# Exercise 3 - Scatter Plot
ggplot(data = gapminder, 
       mapping = aes(x = gdpPercap, 
                     y = lifeExp,
                     color = continent)) + # add the line color = the_variable_you_want to make the plot colorful
  geom_point() + 
  geom_smooth(method = 'gam') + # the smoothing line
  labs(title = "Distribution of Life Expectancy",
       x = "Continent",
       y = "Life Expectancy")