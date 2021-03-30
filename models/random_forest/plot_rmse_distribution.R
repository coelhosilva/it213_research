#### LIBS ####
library(here)
library(tidyverse)

#### INPUTS ####
rf_performance <- readRDS(here('models/random_forest/results/rf_performance.RDS'))

#### CHARTING ####
options(scipen = 999)
p <- ggplot(rf_performance, aes(rmse, color = Model, fill = Model)) +
  # Add a density curve
  # geom_density(aes(y=..scaled..))+
  geom_density(alpha = 0.1) +
  # Add a vertical line through zero
  geom_vline(xintercept = 0) +
  # ylim(0, 0.0003) +
  scale_x_continuous(limits = c(32000, 42000),
                     breaks = scales::pretty_breaks(n = 10)
                     # guide = guide_axis(angle=30)
  ) +
  scale_y_continuous(limits = c(0, 0.0010),
                     breaks = scales::pretty_breaks(n = 10)) +
  theme(axis.text.x=element_text(angle=30, hjust=1)) +
  xlab("Root Mean Squared Error") +
  ylab("RMSE distribution") +
  theme(legend.position = 'bottom', text = element_text(size = 20))
p