### intro to interactive plots

### static plots with ggplot2

library(tidyverse)

### create a scatter plot between the Sepal variables in iris

iris %>% 
  ggplot(mapping = aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(size = 4.5) +
  theme_bw()

my_ggplot_object <- iris %>% 
  ggplot(mapping = aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(size = 4.5, color = 'blue') +
  theme_bw()

my_ggplot_object

print( my_ggplot_object )

### zoom in with coord_cartesian() -- does NOT remove any data

my_ggplot_object +
  coord_cartesian(xlim = c(5, 6), ylim = c(2.5, 3))

### forcing the scale_ limits REMOVES data!!!!!!!!!!!!
my_ggplot_object +
  scale_x_continuous(limits = c(5, 6)) +
  scale_y_continuous(limits = c(2.5, 3))

### getting started with plotly
### https://plotly.com/ggplot2/getting-started/

library(plotly)

### create a ggplot2 object and assign to a variable

p <- iris %>% 
  ggplot(mapping = aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(size = 4.5, color = 'grey50') +
  theme_bw()

fig <- ggplotly(p)

p %>% class()

fig %>% class()

fig
