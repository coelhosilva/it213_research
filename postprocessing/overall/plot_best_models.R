#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

predictions_dnn_1 <-
  read.csv2(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_dnn_1.csv"
    ),
    sep = ",",
    dec = "."
  )
predictions_rf_2 <-
  readRDS(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_rf_2.RDS"
    )
  )
predictions_gravity_2 <-
  readRDS(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_gravity_2.RDS"
    )
  )

predictions_actual <-
  data.frame(
    prediction = predictions_dnn_1$actual,
    actual = predictions_dnn_1$actual,
    Model = "Actual"
  )


color_scale <-
  c(
    "Gravity-2" = "#FD635E",
    "RF-2" = "#02B8AA",
    "DNN-1" = "#303636",
    "Actual" = "#9999CC"
  )
p <-
  plot_three_model_predictions(
    predictions_gravity_2,
    predictions_rf_2,
    predictions_dnn_1,
    predictions_actual,
    color_scale
  )
p
ggsave("postprocessing/charts/best_models_plot.pdf", p)
