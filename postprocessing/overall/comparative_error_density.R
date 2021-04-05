library(here)
library(tidyverse)

error_df_rf_1 <-
  readRDS(here(
    "postprocessing/performance_metrics/error/error_df_rf_1.RDS"
  ))
error_df_rf_2 <-
  readRDS(here(
    "postprocessing/performance_metrics/error/error_df_rf_2.RDS"
  ))

error_df_gravity_1 <-
  readRDS(here(
    "postprocessing/performance_metrics/error/error_df_gravity_1.RDS"
  ))
error_df_gravity_2 <-
  readRDS(here(
    "postprocessing/performance_metrics/error/error_df_gravity_2.RDS"
  ))

error_df_dnn_1 <-
  read.table(
    here(
      "postprocessing/performance_metrics/error/error_df_dnn_1.csv"
    ),
    sep = ",",
    header = TRUE
  )
error_df_dnn_2 <-
  read.table(
    here(
      "postprocessing/performance_metrics/error/error_df_dnn_2.csv"
    ),
    sep = ",",
    header = TRUE
  )

error_df <-
  bind_rows(
    error_df_rf_1,
    error_df_rf_2,
    error_df_gravity_1,
    error_df_gravity_2,
    error_df_dnn_1,
    error_df_dnn_2
  )

## Density of error
p <- ggplot(error_df, aes(error, color=Model, fill=Model)) +
  geom_density(alpha=0.1)+
  geom_vline(xintercept = 0) + 
  scale_x_continuous(limits = c(-15000, 15000), breaks = scales::pretty_breaks(n = 10)) +
  scale_y_continuous(limits = c(0, 0.0004), breaks = scales::pretty_breaks(n = 10)) +
  xlab("Error") + 
  ylab("Error distribution") +
  theme(legend.position = 'bottom', text = element_text(size=20))
p

ggsave("postprocessing/charts/error_densities.pdf", p)