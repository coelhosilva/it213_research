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
predictions_dnn_2 <-
  read.csv2(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_dnn_2.csv"
    ),
    sep = ",",
    dec = "."
  )

predictions_actual <-
  data.frame(
    prediction = predictions_dnn_1$actual,
    actual = predictions_dnn_1$actual,
    Model = "Actual"
  )


color_scale <-
  c("DNN-1" = "#FD635E",
    "DNN-2" = "#02B8AA",
    "Actual" = "#9999CC")
p <-
  plot_model_predictions(predictions_dnn_1,
                         predictions_dnn_2,
                         predictions_actual,
                         color_scale)
p
ggsave("postprocessing/charts/dnn_plot.pdf", p)
