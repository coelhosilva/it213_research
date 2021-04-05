library(here)
library(tidyverse)
options(scipen = 999)

# DATA INPUT
matriz_od <-
  arrow::read_parquet(here("data/data_processed/od_matrix_complete.parquet"))

p <- ggplot(matriz_od) +
  stat_ecdf(aes(x = total_pax), geom = "step") +
  ylab("F(number of passengers)") +
  xlab("Number of passengers") +
  geom_vline(xintercept = 1000) +
  scale_x_log10(n.breaks = 6) +
  scale_y_continuous(limits = c(0, 1),
                     breaks = scales::pretty_breaks(n = 10)) +
  theme(text = element_text(size = 20))
p
# ggsave("ecdf_en.pdf", p)