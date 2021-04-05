set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))
source(here("postprocessing/bootstrapping.R"))

#### INPUTS ####
rf_performance <-
  readRDS(here('postprocessing/performance_metrics/batch_performance//rf_performance.RDS'))


#### EXPERIMENT ####
rmse_1 <- rf_performance[rf_performance$Model == 'RF-1', 'rmse']
rmse_2 <- rf_performance[rf_performance$Model == 'RF-2', 'rmse']

rmse_1_bs_replicates <- draw_bootstrap_replicates(rmse_1, mean, 10000)
rmse_2_bs_replicates <- draw_bootstrap_replicates(rmse_2, mean, 10000)

rmse_1_ci <- confidence_interval(rmse_1_bs_replicates, ci = 0.95)
rmse_2_ci <- confidence_interval(rmse_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("RF-1\n")
cat(paste("RF-1 average RMSE:", round(mean(rmse_1)), "\n"))
cat(paste(
  "RF-1 RMSE 95% confidence interval:",
  round(rmse_1_ci[1]),
  "through",
  round(rmse_1_ci[2])
))
cat("\n")
cat("RF-2\n")
cat(paste("RF-2 average RMSE:", round(mean(rmse_2)), "\n"))
cat(paste(
  "RF-2 RMSE 95% confidence interval:",
  round(rmse_2_ci[1]),
  "through",
  round(rmse_2_ci[2])
))
