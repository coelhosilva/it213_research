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
mape_1 <- rf_performance[rf_performance$Model == 'RF-1', 'mape']
mape_2 <- rf_performance[rf_performance$Model == 'RF-2', 'mape']

mape_1_bs_replicates <- draw_bootstrap_replicates(mape_1, mean, 10000)
mape_2_bs_replicates <- draw_bootstrap_replicates(mape_2, mean, 10000)

mape_1_ci <- confidence_interval(mape_1_bs_replicates, ci = 0.95)
mape_2_ci <- confidence_interval(mape_2_bs_replicates, ci = 0.95)


#### OUTPUT CONFIDENCE INTERVALS ####
cat("RF-1\n")
cat(paste("RF-1 average MAPE:", round(mean(mape_1), 3), "\n"))
cat(paste(
  "RF-1 MAPE 95% confidence interval:",
  round(mape_1_ci[1], 3),
  "through",
  round(mape_1_ci[2], 3)
))
cat("\n")
cat("RF-2\n")
cat(paste("RF-2 average MAPE:", round(mean(mape_2), 3), "\n"))
cat(paste(
  "RF-2 MAPE 95% confidence interval:",
  round(mape_2_ci[1], 3),
  "through",
  round(mape_2_ci[2], 3)
))
