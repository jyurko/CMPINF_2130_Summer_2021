### global script for the yacht lm compare app

library(tidyverse)

library(shiny)

library(coefplot)

library(broom)

### read in the data
data_url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/00243/yacht_hydrodynamics.data'

yacht <- readr::read_delim(data_url, delim = " ", col_names = FALSE)

yacht %>% head()

yacht <- yacht %>% mutate(X2 = as.numeric(X2))

yacht <- yacht %>% rename(y = X7)

### quick summary of the variables, this works easily becaues all
### variables are numeric
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

### store the names of the inputs
input_names <- yacht %>% 
  select(starts_with("X")) %>% 
  names()

### store the response name
output_name <- yacht %>% 
  select(!starts_with("X")) %>% 
  names()

### store functions to apply to the response in the histogram
output_transformations <- list(
  none = function(x){x},
  log = log,
  sqrt = sqrt,
  inverse = function(x){ 1/x }
)

output_display_label <- list(
  none = output_name,
  log = paste0("log(", output_name, ")"),
  sqrt = paste0('sqrt(', output_name, ')'),
  inverse = paste0('1 / ', output_name)
)

### store functions which undo the transformation
undo_output_transformation <- list(
  none = function(x){x},
  log = exp,
  sqrt = function(x){x^2},
  inverse = function(x){ 1/x }
)

### calculate the input means and scales
input_centers <- yacht %>% 
  select(all_of(input_names)) %>% 
  purrr::map_dbl(mean)

input_scales <- yacht %>% 
  select(all_of(input_names)) %>% 
  purrr::map_dbl(sd)

### make a function to allow augmenting the confidence interval
### AND prediction together
my_train_augment <- function(a_mod, train_data)
{
  a_mod %>% 
    broom::augment(data = train_data, 
                   se_fit = TRUE,
                   interval = "confidence") %>% 
    rename(conf_lwr = .lower, conf_upr = .upper) %>% 
    bind_cols(a_mod %>% 
                broom::augment(data = train_data,
                               se_fit = TRUE,
                               interval = 'prediction') %>% 
                select(pred_lwr = .lower, pred_upr = .upper))
}

### create a default input grid to visualize predictions
default_viz_grid <- expand.grid(X1 = median(yacht$X1),
                                X2 = seq(min(yacht$X2), max(yacht$X2), length.out = 3),
                                X3 = median(yacht$X3),
                                X4 = median(yacht$X4),
                                X5 = median(yacht$X5),
                                X6 = seq(min(yacht$X6), max(yacht$X6), length.out = 51),
                                KEEP.OUT.ATTRS = FALSE,
                                stringsAsFactors = FALSE) %>% 
  as.data.frame() %>% tibble::as_tibble()

### standardize the default prediction grid based on the training set
# default_viz_grid_ready <- default_viz_grid %>%
#   scale(center = input_centers,
#         scale = input_scales) %>%
#   as.data.frame() %>% tibble::as_tibble()

### create a function to allow augmenting the confidence interval and 
### prediction interval together
my_viz_augment <- function(a_mod, viz_data)
{
  a_mod %>% 
    broom::augment(newdata = viz_data, 
                   se_fit = TRUE,
                   interval = "confidence") %>% 
    rename(conf_lwr = .lower, conf_upr = .upper) %>% 
    bind_cols(a_mod %>% 
                broom::augment(newdata = viz_data,
                               se_fit = TRUE,
                               interval = 'prediction') %>% 
                select(pred_lwr = .lower, pred_upr = .upper))
}

### create a function to undo the standardization of the response
undo_stan <- function(x, m, s){ s * x + m }

### define functions to help create the prediction grid
make_one_vector_for_grid <- function(an_input, x_var, facet_var, num_facets, quant_use)
{
  x_values <- yacht %>% select(all_of(an_input)) %>% pull()
  
  
  if(an_input == x_var){
    # this is the x-axis variable use many points
    x_min <- x_values %>% min()
    x_max <- x_values %>% max()
    
    x_vec <- seq(x_min, x_max, length.out = 51)
  } else if(an_input == facet_var) {
    # this is the faceting variable use a finite number of values
    if(num_facets < 2){
      # use the median if a single facet is desired
      x_vec <- median(x_values)
    } else {
      # use multiple facets
      x_min <- x_values %>% min()
      x_max <- x_values %>% max()
      
      x_vec <- seq(x_min, x_max, length.out = num_facets)
    } 
  } else {
    # remaining variables just use a quantile
    x_vec <- quantile(x_values, quant_use)
  }
  
  x_vec
}

### iterate over all input variables to create the prediction grid
make_viz_grid_list <- function(all_inputs, x_var, facet_var, num_facets, quant_use)
{
  purrr::map(all_inputs,
             make_one_vector_for_grid,
             x_var = x_var,
             facet_var = facet_var,
             num_facets = num_facets,
             quant_use = quant_use)
}
