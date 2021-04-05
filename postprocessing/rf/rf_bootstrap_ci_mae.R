set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/bootstrapping.R"))

#### INPUTS ####
rf_performance <-
  readRDS(
    here(
      'postprocessing/performance_metrics/batch_performance//rf_performance.RDS'
    )
  )


#### EXPERIMENT ####
mae_1 <- rf_performance[rf_performance$Model == 'RF-1', 'mae']
mae_2 <- rf_performance[rf_performance$Model == 'RF-2', 'mae']

mae_1_bs_replicates <- draw_bootstrap_replicates(mae_1, mean, 10000)
mae_2_bs_replicates <- draw_bootstrap_replicates(mae_2, mean, 10000)

mae_1_ci <- confidence_interval(mae_1_bs_replicates, ci = 0.95)
mae_2_ci <- confidence_interval(mae_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("RF-1\n")
cat(paste("RF-1 average MAE:", round(mean(mae_1)), "\n"))
cat(paste(
  "RF-1 MAE 95% confidence interval:",
  round(mae_1_ci[1]),
  "through",
  round(mae_1_ci[2])
))
cat("\n")
cat("RF-2\n")
cat(paste("RF-2 average MAE:", round(mean(mae_2)), "\n"))
cat(paste(
  "RF-2 MAE 95% confidence interval:",
  round(mae_2_ci[1]),
  "through",
  round(mae_2_ci[2])
))
