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
rmse_1 <- dnn_performance_1$rmse
rmse_2 <- dnn_performance_2$rmse

rmse_1_bs_replicates <- draw_bootstrap_replicates(rmse_1, mean, 10000)
rmse_2_bs_replicates <- draw_bootstrap_replicates(rmse_2, mean, 10000)

rmse_1_ci <- confidence_interval(rmse_1_bs_replicates, ci = 0.95)
rmse_2_ci <- confidence_interval(rmse_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("DNN-1\n")
cat(paste("DNN-1 average RMSE:", round(mean(rmse_1)), "\n"))
cat(paste(
  "DNN-1 RMSE 95% confidence interval:",
  round(rmse_1_ci[1]),
  "through",
  round(rmse_1_ci[2])
))
cat("\n")
cat("DNN-2\n")
cat(paste("DNN-2 average RMSE:", round(mean(rmse_2)), "\n"))
cat(paste(
  "DNN-2 RMSE 95% confidence interval:",
  round(rmse_2_ci[1]),
  "through",
  round(rmse_2_ci[2])
))
