#### LIBS ####
library(here)
library(tidyverse)

#### INPUTS ####
tree_performance <-
  readRDS(here(
    'models/random_forest/results/number_of_trees_performance.RDS'
  ))
rf_performance <-
  readRDS(here('models/random_forest/results/rf_performance.RDS'))
tree_performance$sd <- 0
tree_performance[tree_performance$Model == 'RF-1', ]$sd <-
  sd(rf_performance[rf_performance$Model == 'RF-1',]$rmse)
tree_performance[tree_performance$Model == 'RF-2', ]$sd <-
  sd(rf_performance[rf_performance$Model == 'RF-2',]$rmse)


#### CHARTING ####
options(scipen = 999)
p <-
  ggplot(tree_performance,
         aes(
           x = n_trees,
           y = rmse,
           color = Model,
           fill = Model
         )) +
  geom_line() +
  geom_point() +
  geom_errorbar(aes(ymin = rmse - sd, ymax = rmse + sd),
                width = .2,
                position = position_dodge(0.05)) +
  xlab("Number of trees") +
  ylab("Root Mean Squared Error - Validation set") + 
  theme(axis.title=element_text(size=16)) +
  theme(legend.position = 'bottom', text = element_text(size = 16))
p

ggsave("number_of_trees.pdf", p)