#### LIBS ####
library(here)
library(tidyverse)
source(here("postprocessing/charting_functions.R"))

predictions_gravity_1 <-
  readRDS(
    here(
      "postprocessing/performance_metrics/predictions/test_predictions_gravity_1.RDS"
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
    prediction = predictions_gravity_1$actual,
    actual = predictions_gravity_1$actual,
    Model = "Actual"
  )


color_scale <-
  c("Gravity-1" = "#FD635E",
    "Gravity-2" = "#02B8AA",
    "Actual" = "#9999CC")
p <-
  plot_model_predictions(predictions_gravity_1,
                         predictions_gravity_2,
                         predictions_actual,
                         color_scale)
p
ggsave("postprocessing/charts/gravity_plot.pdf", p)
