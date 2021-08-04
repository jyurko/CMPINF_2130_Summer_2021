### working with parallel coordinates plot

library(tidyverse)

iris %>% glimpse()

### reshape iris into long-format, check rows per variable
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Species")) %>% 
  count(name)

### make a stripplot style figure
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Species")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_point() +
  theme_bw()

### compare with a boxplot created from the long-format data
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Species")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_boxplot(fill = 'grey') +
  theme_bw()

### combine points with the box
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Species")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_point() +
  geom_boxplot(fill = 'grey', alpha = 0.35) +
  theme_bw()

### identify a row in the original data set, start out with a smaller dataset
### color each marker based on the rowid
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  filter(rowid < 6) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_point(size = 8,
             mapping = aes(color = rowid)) +
  scale_color_viridis_c() +
  theme_bw()

### use jitter to show the different points
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  filter(rowid < 6) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_jitter(size = 8,
              mapping = aes(color = rowid)) +
  scale_color_viridis_c() +
  theme_bw()

### connect the rows together with lines
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  filter(rowid < 6) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.5,
            mapping = aes(group = rowid,
                          color = rowid)) +
  geom_point(size = 8,
             mapping = aes(color = rowid)) +
  scale_color_viridis_c() +
  theme_bw()

### show all observations, and we won't color by the rowid
iris %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.5,
            mapping = aes(group = rowid)) +
  geom_point(size = 2) +
  theme_bw()

### scale or normalize all numeric variables such that the MINIMUM
### equals 0 and the MAXIMUM equals 1
transform_function <- function(x){
  (x - min(x)) / (max(x) - min(x))
}

iris %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::as_tibble() %>% 
  summary()

iris %>% summary()

### confirm the transformation with boxplots
iris %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Species")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_boxplot(fill = 'dodgerblue') +
  theme_bw()

### make the stripplot with the nromalized variables and connect each
### observation with a line
iris %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.5,
            mapping = aes(group = rowid)) +
  geom_point(size = 2) +
  theme_bw()

### color the lines by the Species
iris %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::as_tibble() %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c('rowid', 'Species')) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.5,
            mapping = aes(group = rowid,
                          color = Species)) +
  geom_point(size = 2,
             mapping = aes(color = Species)) +
  ggthemes::scale_color_colorblind() +
  theme_bw() +
  theme(legend.position = "top")

### parallel coordinates with more variables with the wine data

wine_url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data"

wine <- readr::read_csv(wine_url,
                        col_names = c("Cultivar", "Alcohol", "Malic_acid",
                                      "Ash", "Alcalinity_of_ash",
                                      "Magnesium", "Total_phenols",
                                      "Flavanoids", "Nonflavanoid_phenols",
                                      "Proanthocyanin", "Color_intensity",
                                      "Hue", "OD280_OD315_of_diluted_wines",
                                      "Proline"))

wine %>% 
  mutate(Cultivar = factor(Cultivar)) %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Cultivar")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.1,
            mapping = aes(group = rowid)) +
  theme_bw()

wine %>% 
  mutate(Cultivar = factor(Cultivar)) %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Cultivar")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.1,
            mapping = aes(group = rowid)) +
  coord_flip() +
  theme_bw()

### color by Cultivar
wine %>% 
  mutate(Cultivar = factor(Cultivar)) %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Cultivar")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.1,
            mapping = aes(group = rowid,
                          color = Cultivar)) +
  coord_flip() +
  ggthemes::scale_color_colorblind() +
  theme_bw() +
  theme(legend.position = "top")

### include facets
wine %>% 
  mutate(Cultivar = factor(Cultivar)) %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Cultivar")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.1,
            mapping = aes(group = rowid,
                          color = Cultivar)) +
  facet_grid( . ~ Cultivar ) +
  coord_flip() +
  ggthemes::scale_color_colorblind(guide = "none") +
  theme_bw() +
  theme(legend.position = "top")

### change the transparency
wine %>% 
  mutate(Cultivar = factor(Cultivar)) %>% 
  mutate_if(is.numeric, transform_function) %>% 
  tibble::rowid_to_column() %>% 
  pivot_longer(!c("rowid", "Cultivar")) %>% 
  ggplot(mapping = aes(x = name, y = value)) +
  geom_line(size = 1.1,
            mapping = aes(group = rowid,
                          color = Cultivar),
            alpha = 0.3) +
  facet_grid( . ~ Cultivar ) +
  coord_flip() +
  ggthemes::scale_color_colorblind(guide = "none") +
  theme_bw() +
  theme(legend.position = "top")

### there is a package that helps out 

### https://yaweige.github.io/ggpcp/

### to install ggpcp we first need devtools

# install.packages("devtools")

### then we need to install from github

# install.packages("yaweige/ggpcp", build_vignettes = TRUE)

### you only need to install once

library(ggpcp)

### 
iris %>% 
  mutate(Species = factor(Species)) %>% 
  ggplot(mapping = aes(vars = vars(Species, starts_with("Petal."), starts_with("Sepal.")))) +
  geom_pcp_box(boxwidth = 0.1, fill = 'grey70') +
  geom_pcp(mapping = aes(color = Species)) +
  geom_pcp_label(color = 'red') +
  ggthemes::scale_color_colorblind() +
  theme_bw() +
  theme(legend.position = "top")
