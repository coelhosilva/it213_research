#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

#### INPUTS ####
tree_performance <-
  readRDS(
    here(
      'postprocessing/performance_metrics/training_history/number_of_trees_performance.RDS'
    )
  )
rf_performance <-
  readRDS(
    here(
      'postprocessing/performance_metrics/batch_performance/rf_performance.RDS'
    )
  )
tree_performance$sd <- 0
tree_performance[tree_performance$Model == 'RF-1',]$sd <-
  sd(rf_performance[rf_performance$Model == 'RF-1', ]$rmse)
tree_performance[tree_performance$Model == 'RF-2',]$sd <-
  sd(rf_performance[rf_performance$Model == 'RF-2', ]$rmse)


#### CHARTING ####
p <- plot_tree_performance(tree_performance)
p
ggsave("postprocessing/charts/rf_number_of_trees.pdf", p)