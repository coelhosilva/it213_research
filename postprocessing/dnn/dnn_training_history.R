#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))


# huber_loss <- function
#### INPUTS ####
dnn_1_training_history <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/training_history/dnn_1_training_history.csv'
    ),
    sep = ",",
    dec = "."
  )

dnn_1_training_history <- dnn_1_training_history %>% pivot_longer(c("loss", "val_loss"), names_to = "Dataset")
dnn_1_training_history$Dataset[dnn_1_training_history$Dataset == "loss"] <- "Training loss"
dnn_1_training_history$Dataset[dnn_1_training_history$Dataset == "val_loss"] <- "Validation loss"

dnn_1_performance <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/batch_performance/dnn_1_performance.csv'
    ),
    sep = ",",
    dec = "."
  )


predictions_dnn_1 <-
  read.csv2(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_dnn_1.csv"
    ),
    sep = ",",
    dec = "."
  )

# huber_loss <- yardstick::huber_loss_vec(predictions_dnn_1$actual, predictions_dnn_1$prediction)
# dnn_1_training_history$sd <- huber_loss*(sd(dnn_1_performance$mae)/mean(dnn_1_performance$mae))
dnn_1_training_history$sd <- 300

# tree_performance$sd <- 0
# tree_performance[tree_performance$Model == 'RF-1',]$sd <-
#   sd(rf_performance[rf_performance$Model == 'RF-1', ]$rmse)
# tree_performance[tree_performance$Model == 'RF-2',]$sd <-
#   sd(rf_performance[rf_performance$Model == 'RF-2', ]$rmse)
# 
# 
# #### CHARTING ####
p <- plot_training_history(dnn_1_training_history)
p
# ggsave("postprocessing/charts/rf_number_of_trees.pdf", p)