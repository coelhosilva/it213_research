#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

predictions_rf_1 <-
  readRDS(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_rf_1.RDS"
    )
  )
predictions_rf_2 <-
  readRDS(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_rf_2.RDS"
    )
  )
predictions_actual <-
  data.frame(
    prediction = predictions_rf_1$actual,
    actual = predictions_rf_1$actual,
    Model = "Actual"
  )


color_scale <-
  c("RF-1" = "#FD635E",
    "RF-2" = "#02B8AA",
    "Actual" = "#9999CC")
p <-
  plot_model_predictions(predictions_rf_1,
                         predictions_rf_2,
                         predictions_actual,
                         color_scale)
p
ggsave("postprocessing/charts/rf_plot.pdf", p)
