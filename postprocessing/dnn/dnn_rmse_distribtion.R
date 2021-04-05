#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

#### INPUTS ####
dnn_performance_1 <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/batch_performance/dnn_1_performance.csv'
    ),
    sep = ",",
    dec = "."
  )
dnn_performance_2 <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/batch_performance/dnn_2_performance.csv'
    ),
    sep = ",",
    dec = "."
  )

dnn_performance <- rbind(dnn_performance_1, dnn_performance_2)

#### CHARTING ####
x_limits <- c(10000, 40000)
y_limits <- c(0, 0.0002)

p <- plot_rmse_distribution(dnn_performance, x_limits, y_limits)
p
ggsave("postprocessing/charts/dnn_rmse_distribution.pdf", p)
