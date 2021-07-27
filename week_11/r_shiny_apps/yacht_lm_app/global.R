### the global script for the yacht lm application

library(tidyverse)

library(shiny)

library(coefplot)

library(broom)

### load in the yacht data
data_url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/00243/yacht_hydrodynamics.data'

yacht <- readr::read_delim(data_url, delim = " ", col_names = FALSE)

### clean the data
yacht <- yacht %>% mutate(X2 = as.numeric(X2))

yacht <- yacht %>% rename(y = X7)

### make a table that summarizes information about the variables
var_overview <- yacht %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid")) %>% 
  group_by(name) %>% 
  summarise(`Rows` = n(),
            `Unique values` = n_distinct(value),
            `Missing values` = sum(is.na(value)),
            `Minimum` = min(value),
            `Median` = median(value),
            `Maximum` = max(value)) %>% 
  ungroup()

### store the input and the output names
input_names <- yacht %>% 
  select(starts_with("X")) %>% 
  names()

output_names <- yacht %>% 
  select(!starts_with("X")) %>% 
  names()

### create a list that stores the transformations we could apply
### to the response
output_transformations <- list(
  none = function(x){x},
  log = log,
  sqrt = sqrt,
  inverse = function(x){ 1/x }
)

### practice applying a transformation programmaticaly
# yacht %>% 
#   mutate_at(output_names, log)

### calculate the input means and scales
input_centers <- yacht %>% 
  select(all_of(input_names)) %>% 
  purrr::map_dbl(mean)

input_scales <- yacht %>% 
  select(all_of(input_names)) %>% 
  purrr::map_dbl(sd)

