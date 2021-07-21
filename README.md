# CMPINF 2130 Summer 2021

In-class programming examples are light on comments and discussion text. Please see the lecture recordings on Canvas for the discussion around each example.

## Week 01
* Course introduction
* Overview of major goals and themes
* Introduce basic R syntax and compare with basic Python syntax
* Compare basic R data types to basic Python data types

## Week 02
* Review Python lists, dictionaries, and Pandas DataFrames
* Introduce R vectors, lists, and data.frame
* Introduce tidyverse, data manipulation with dplyr
* Introduce the forward-pipe operator, %>%
* Introduce ggplot2, aesthetic mappings, and the aes() function

## Week 03
* Review Pandas groupby() and compare to dplyr group_by()
* Calculate correlation coefficients per group
* geom_point (scatter plot) aesthetics in depth: color, shape, size, and alpha
* fill vs color and size vs stroke in ggplot2
* Discrete (categorical) color scales
* Continuous sequential and diverging color scales
* Discretizing continuous variables
* Facets (subplots) in ggplot2 vs Seaborn
* Introduction to text, line, path, and smooth in ggplot2
* Optional: creating hockey shot maps using Penguins/Islanders playoff game shot data

## Week 04
* Group specific trend lines and the group aesthetic in ggplot2
* Group specific trend lines in Seaborn with sns.lmplot()
* continuous and discrete color palettes in Seaborn
* tidyverse group_by() %>% summarize() pipelines
* Pandas groupby().aggregate() chains 
* Introduction to statistical transformations via counts
* Bar charts in ggplot2 and Seaborn
* Combinations of categorical variables with fill
* Heat maps for combinations of categorical variables

## Week 05
* Bar charts ordered by ascending/descending counts
* Bar charts with proportions
* Lumping low frequency values of categorical variables
* Histograms vs density plots for continuous variables
* Review of quantiles
* Introduction to eCDF

## Week 06
* Review histograms and density plots via rug and frequency polygons  
* Introduced functional programming concepts via purrr::map()  
* Continuous variable distributions grouped by categorical variables  
* Continuous variable summary statistics grouped by categorical variables - BOXPLOTS!  
* Boxplots vs violin plots, stripplots vs beeswarm splots  
* Introduction to rain cloud plots  

## Week 07
* Review quantiles and boxplots via geom_linerange()  
* Compare violin plots, joy/ridge plots, and rain cloud plots  
* Summarize and compare averages across groups
* Review standard error on the mean and confidence intervals
* Correlation plots and ordering correlation plots via hierarchical clustering  

## Week 08
* Correlation plots grouped by categorical variables in Seaborn and ggplot2  
* 2D histograms and 2D density estimates in Seaborn and ggplot2  
* pair plots in Seaborn and ggplot2  
* joint distributions + marginals in Seaborn (jointplot) and ggplot2  
* reshaping data with tidyverse

## Week 09
* Intro to plotly in R with ggplotly()  
* Working with ggplotly() in RMarkdown  
* Intro to R Shiny for dynamic and reactive web-based visualizations  
  * ui.R vs server.R vs global.R scripts  
  * side bar vs main panels in sidebarLayout()
  * input and output reserved keywords  
  * sliderInput(), checkboxInput(), and selectInput() arguments and uses  
  * renderPlot() vs plotOutput()  
* Demonstration R Shiny apps:
  * Explore old faithful data set with histograms, scatter plots, and density estimates
  * Explore iris data set with user dynamic control of scatter plot x, y, and color aesthetics

## Week 10
* Quick intro to text analylsis with tidytext
  * one-token-per-row format: word and bigram
  * Visualizing word counts with bar charts
  * Visualizing word-relationships with network graphs via ggraph and tidygraph
* Quick intro to maps (spatial data)
  * Organizing map data as boundary points of a polygon  
  * Visualizing countries, states, and counties with geom_polygon()  
  * Intro to Simple Features and the sf package and working with geom_sf()
  * Interactive maps with tmap
* Intro to visualizing models
  * Linear model coefficient plots with coefplot  
  * Comparing regression models
