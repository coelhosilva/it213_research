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
mape_1 <- rf_performance[rf_performance$Model == 'RF-1', 'mape']
mape_2 <- rf_performance[rf_performance$Model == 'RF-2', 'mape']

# Null hypothesis: both models have identical mae probability distributions.
# Test statistic: difference of means

# Compute difference of mean RMSE
empirical_diff_means <- diff_of_means(mape_1, mape_2)

# Draw 10,000 permutation replicates: perm_replicates
perm_replicates <-
  draw_permutation_replicates(mape_1, mape_2, diff_of_means, size = 10000)

df_perm_replicates <-
  data.frame(difference_of_means = perm_replicates)

p_value <-
  calculate_p_value(perm_replicates, empirical_diff_means, "gt")


#### OUTPUT P-VALUE ####
cat(paste("Calculated p-value:", p_value))


#### PLOT ####
x_limits <- c(-0.02, 0.02)
y_limits <- c(0, 900)
p <- plot_permutation_test(df_perm_replicates,
                           empirical_diff_means,
                           x_limits,
                           y_limits,
                           x_label = "Difference of means - Mean Average Percentage Error (MAPE)")
p
# ggsave("postprocessing/charts/rf_permutation_test_mape.pdf", p)
