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
mae_1 <- dnn_performance_1$mae
mae_2 <- dnn_performance_2$mae

mae_1_bs_replicates <- draw_bootstrap_replicates(mae_1, mean, 10000)
mae_2_bs_replicates <- draw_bootstrap_replicates(mae_2, mean, 10000)

mae_1_ci <- confidence_interval(mae_1_bs_replicates, ci = 0.95)
mae_2_ci <- confidence_interval(mae_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("DNN-1\n")
cat(paste("DNN-1 average MAE:", round(mean(mae_1)), "\n"))
cat(paste(
  "DNN-1 MAE 95% confidence interval:",
  round(mae_1_ci[1]),
  "through",
  round(mae_1_ci[2])
))
cat("\n")
cat("DNN-2\n")
cat(paste("DNN-2 average MAE:", round(mean(mae_2)), "\n"))
cat(paste(
  "DNN-2 MAE 95% confidence interval:",
  round(mae_2_ci[1]),
  "through",
  round(mae_2_ci[2])
))
