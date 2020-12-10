library(here)
library(tidyverse)

error_df_rf1 <- readRDS(here("/models/errors/error_df_rf1.RDS"))
error_df_rf2 <- readRDS(here("/models/errors/error_df_rf2.RDS"))
error_df_gravity1 <- readRDS(here("/models/errors/error_df_gravity1.RDS"))
error_df_gravity2 <- readRDS(here("/models/errors/error_df_gravity2.RDS"))
error_df_dnn1 <- read.table(here("/models/errors/dnn_baseline/dnn_error.csv"), sep=",", header = TRUE)
error_df_dnn1 <- error_df_dnn1 %>% 
  subset(select=c(error_actual))
error_df_dnn1$model <- "DNN-1"
error_df_dnn2 <- read.table(here("/models/errors/dnn_econ/dnn_error.csv"), sep=",", header = TRUE)
error_df_dnn2 <- error_df_dnn2 %>% 
  subset(select=c(error_actual))
error_df_dnn2$model <- "DNN-2"

error_df <- bind_rows(error_df_rf1, error_df_rf2, error_df_gravity1, error_df_gravity2, error_df_dnn1, error_df_dnn2)
error_df <- error_df %>% rename(Modelo=model)
## Density of error
p <- ggplot(error_df, aes(error_actual, color=Modelo, fill=Modelo)) +
  # Add a density curve
  # geom_density(aes(y=..scaled..))+
  geom_density(alpha=0.1)+
  # Add a vertical line through zero
  geom_vline(xintercept = 0) + 
  # ylim(0, 0.0003) +
  scale_x_continuous(limits = c(-15000, 15000), breaks = scales::pretty_breaks(n = 10)) +
  scale_y_continuous(limits = c(0, 0.0003), breaks = scales::pretty_breaks(n = 10)) +
  xlab("Erro") + 
  ylab("Distribuição do erro")
ggsave("densities.pdf", p)