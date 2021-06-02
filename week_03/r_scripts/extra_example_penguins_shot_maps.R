### create hockey shot maps with tidyverse

library(tidyverse)

### readin the already compiled data set for the penguins

pens_playoff <- readr::read_csv("week_03/r_scripts/pens_playoff_shots_2021.csv",
                                col_names = TRUE)

pens_playoff %>% names()

pens_playoff %>% glimpse()

### the shots are labeled as events

pens_playoff %>% count(event)

pens_playoff %>% count(game_id)

pens_playoff %>% count(teamCode)

### create a vector for the unique game_ids
pens_game_ids <- pens_playoff %>% 
  select(game_id) %>% 
  distinct() %>% 
  pull()

### focus on a single game and look at the x and y coordinates for all shots
### in the game
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point() +
  theme_bw()

### manipulate the coordinate axes, we want to force the x-and y-axis to
### be equal
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point() +
  coord_equal() +
  theme_bw()

### let's now color the markers based on the Team that made the shot
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = teamCode)) +
  coord_equal() +
  theme_bw()

### move the legend to the top of the figure
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = teamCode)) +
  coord_equal() +
  theme_bw()+
  theme(legend.position = "top")

### checking the period that the shot occured in
pens_playoff %>% count(period)

### use facets to reperesnt the periods the shots were taken in
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = teamCode)) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  theme_bw()+
  theme(legend.position = "top")

### the teamcolors package has all colors for various sports leagues

library(teamcolors)

league_pal('nhl', which = 1)

league_pal('nhl', which = 2)

### use a join to enable using the actual team colors

team_name_info <- tibble::tibble(
  nick_name = c("PIT", "NYI"),
  full_name = c("Pittsburgh Penguins", "New York Islanders")
)

pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  count(teamCode, full_name)

### use a marker that has both fill and color stroke to use the primary and
### secondary colors
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name),
             shape = 21, size = 3, stroke = 1) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual(values = league_pal('nhl', which = 2)) +
  scale_fill_manual(values = league_pal('nhl', which = 1)) +
  theme_bw()+
  theme(legend.position = "top")

### let's focus on a single period
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name),
             shape = 21, size = 6.5, stroke = 1.5) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  theme_bw()+
  theme(legend.position = "top")

### use the marker shape to tell us whether shot was a goal or not
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event),
             size = 6.5, stroke = 1.5) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  theme_bw()+
  theme(legend.position = "top")

### we can have greater contorl over the guide through the guides() function
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event),
             size = 6.5, stroke = 1.5) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### lastly lets' include the marker size to help denote a goal vs a miss
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event)) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### lastly set the transparency so we can focus on the goals
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### include the name of the player who scored the goal as text
pens_playoff %>% count(shooterName)


pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(mapping = aes(label = shooterName)) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### we can make this easier to read by removing overlapping text

pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(mapping = aes(label = shooterName),
            check_overlap = TRUE) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### by "nudging" the text vertically or horizontally
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(mapping = aes(label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### overide the parent data set
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(data = pens_playoff %>% 
              filter(game_id %in% pens_game_ids[1]) %>% 
              left_join(team_name_info,
                        by = c("teamCode" = "nick_name")) %>% 
              filter(period == 1) %>% 
              filter(event == "GOAL"),
            mapping = aes(label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### finally show all periods again
pens_playoff %>% 
  filter(game_id %in% pens_game_ids[1]) %>% 
  left_join(team_name_info,
            by = c("teamCode" = "nick_name")) %>% 
  # filter(period == 1) %>% 
  ggplot(mapping = aes(x = xCord, y = yCord)) +
  geom_point(mapping = aes(color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(data = pens_playoff %>% 
              filter(game_id %in% pens_game_ids[1]) %>% 
              left_join(team_name_info,
                        by = c("teamCode" = "nick_name")) %>% 
              # filter(period == 1) %>% 
              filter(event == "GOAL"),
            mapping = aes(label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  coord_equal() +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme_bw()+
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))


### use the sportyR

library(sportyR)

sportyR::geom_baseball("mlb")

sportyR::geom_soccer('fifa', touchline_length = 100, goal_line_length = 75)

sportyR::geom_hockey('nhl')

### assign the hockey rink to an object
nhl_rink <- sportyR::geom_hockey('nhl')

print( nhl_rink )

### add what we did previously, BUT we must assign the data to each geom directly
nhl_rink +
  geom_point(data = pens_playoff %>% 
               filter(game_id %in% pens_game_ids[1]) %>% 
               left_join(team_name_info,
                         by = c("teamCode" = "nick_name")) %>% 
               filter(period == 1),
             mapping = aes(x = xCord, y = yCord,
                           color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(data = pens_playoff %>% 
              filter(game_id %in% pens_game_ids[1]) %>% 
              left_join(team_name_info,
                        by = c("teamCode" = "nick_name")) %>% 
              filter(period == 1) %>%
              filter(event == "GOAL"),
            mapping = aes(x = xCord, y = yCord,
                          label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

### assign this plot to an object
one_period_shot_map <- nhl_rink +
  geom_point(data = pens_playoff %>% 
               filter(game_id %in% pens_game_ids[1]) %>% 
               left_join(team_name_info,
                         by = c("teamCode" = "nick_name")) %>% 
               filter(period == 1),
             mapping = aes(x = xCord, y = yCord,
                           color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(data = pens_playoff %>% 
              filter(game_id %in% pens_game_ids[1]) %>% 
              left_join(team_name_info,
                        by = c("teamCode" = "nick_name")) %>% 
              filter(period == 1) %>%
              filter(event == "GOAL"),
            mapping = aes(x = xCord, y = yCord,
                          label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

ggsave("week_03/r_scripts/one_playoff_game_period_map.pdf", plot = one_period_shot_map)

### add in all periods
one_game_shot_map <- nhl_rink +
  geom_point(data = pens_playoff %>% 
               filter(game_id %in% pens_game_ids[1]) %>% 
               left_join(team_name_info,
                         by = c("teamCode" = "nick_name")),
             mapping = aes(x = xCord, y = yCord,
                           color = full_name,
                           fill = full_name,
                           shape = event,
                           size = event,
                           alpha = event)) +
  geom_text(data = pens_playoff %>% 
              filter(game_id %in% pens_game_ids[1]) %>% 
              left_join(team_name_info,
                        by = c("teamCode" = "nick_name")) %>% 
              filter(event == "GOAL"),
            mapping = aes(x = xCord, y = yCord,
                          label = shooterName),
            check_overlap = TRUE,
            nudge_y = -3) +
  facet_wrap( ~ period, ncol = 1, labeller = "label_both") +
  scale_color_manual("Team", values = league_pal('nhl', which = 2)) +
  scale_fill_manual("Team", values = league_pal('nhl', which = 1)) +
  scale_shape_manual("",
                     values = c("GOAL" = 24,
                                "MISS" = 22,
                                "SHOT" = 21)) +
  scale_size_manual("",
                    values = c("GOAL" = 6.0,
                               "MISS" = 2.0,
                               "SHOT" = 4.25)) +
  scale_alpha_manual("",
                     values = c("GOAL" = 1.0,
                                "MISS" = 0.5,
                                "SHOT" = 0.5)) +
  theme(legend.position = "top") +
  guides(color = guide_legend(override.aes = list(shape = 24, size = 5.5)))

print( one_game_shot_map )

ggsave("week_03/r_scripts/one_playoff_game_map.pdf", plot = one_game_shot_map)
