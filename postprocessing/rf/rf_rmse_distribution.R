#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

#### INPUTS ####
rf_performance <-
  readRDS(
    here(
      'postprocessing/performance_metrics/batch_performance/rf_performance.RDS'
    )
  )

#### CHARTING ####
x_limits <- c(34000, 42000)
y_limits <- c(0, 0.0007)

p <- plot_rmse_distribution(rf_performance, x_limits, y_limits)
p
ggsave("postprocessing/charts/rf_rmse_distribution.pdf", p)