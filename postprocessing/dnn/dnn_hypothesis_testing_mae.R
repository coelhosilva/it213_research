set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))
source(here("postprocessing/permutation_test.R"))

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
mae_1 <- dnn_performance_1$mae
mae_2 <- dnn_performance_2$mae

# Null hypothesis: both models have identical rmse probability distributions.
# Test statistic: difference of means

# Compute difference of mean RMSE
empirical_diff_means <- diff_of_means(mae_1, mae_2)

# Draw 10,000 permutation replicates: perm_replicates
perm_replicates <-
  draw_permutation_replicates(mae_1, mae_2, diff_of_means, size = 10000)

df_perm_replicates <-
  data.frame(difference_of_means = perm_replicates)

p_value <-calculate_p_value(perm_replicates, empirical_diff_means, "gt")


#### OUTPUT P-VALUE ####
cat(paste("Calculated p-value:", p_value))


#### PLOT ####
x_limits <- c(-1000, 1000)
y_limits <- c(0, 0.005)
p <- plot_permutation_test(df_perm_replicates,
                           empirical_diff_means,
                           x_limits,
                           y_limits,
                           x_label = "Difference of means - Mean Absolute Error (MAE)",
                           y_annotation=0.0038)
p
# ggsave("postprocessing/charts/dnn_permutation_test_mae.pdf", p)
