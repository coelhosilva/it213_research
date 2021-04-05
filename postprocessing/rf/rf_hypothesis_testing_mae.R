#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))
source(here("postprocessing/permutation_test.R"))

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

# Null hypothesis: both models have identical mae probability distributions.
# Test statistic: difference of means

# Compute difference of mean RMSE
empirical_diff_means <- diff_of_means(mae_1, mae_2)

# Draw 10,000 permutation replicates: perm_replicates
perm_replicates <-
  draw_permutation_replicates(mae_1, mae_2, diff_of_means, size = 10000)

df_perm_replicates <-
  data.frame(difference_of_means = perm_replicates)

p_value <-
  calculate_p_value(perm_replicates, empirical_diff_means, "gt")


#### OUTPUT P-VALUE ####
cat(paste("Calculated p-value:", p_value))


#### PLOT ####
x_limits <- c(-500, 1000)
y_limits <- c(0, 0.04)
p <- plot_permutation_test(df_perm_replicates,
                           empirical_diff_means,
                           x_limits,
                           y_limits,
                           x_label = "Difference of means - Mean Absolute Error (MAE)")
p
# ggsave("postprocessing/charts/rf_permutation_test_mae.pdf", p)
