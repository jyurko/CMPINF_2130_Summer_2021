### helper global script for the iris exploration app

library(tidyverse)

iris_numeric_names <- iris %>% 
  purrr::keep(is.numeric) %>% 
  names()
