set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/bootstrapping.R"))

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


#### EXPERIMENT ####
# Bootstrapping the confidence interval
mape_1 <- dnn_performance_1$mape
mape_2 <- dnn_performance_2$mape

mape_1_bs_replicates <- draw_bootstrap_replicates(mape_1, mean, 10000)
mape_2_bs_replicates <- draw_bootstrap_replicates(mape_2, mean, 10000)

mape_1_ci <- confidence_interval(mape_1_bs_replicates, ci = 0.95)
mape_2_ci <- confidence_interval(mape_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("DNN-1\n")
cat(paste("DNN-1 average MAPE:", round(mean(mape_1), 3), "\n"))
cat(paste(
  "DNN-1 MAPE 95% confidence interval:",
  round(mape_1_ci[1], 3),
  "through",
  round(mape_1_ci[2], 3)
))
cat("\n")
cat("DNN-2\n")
cat(paste("DNN-2 average MAPE:", round(mean(mape_2), 3), "\n"))
cat(paste(
  "DNN-2 MAPE 95% confidence interval:",
  round(mape_2_ci[1], 3),
  "through",
  round(mape_2_ci[2], 3)
))
