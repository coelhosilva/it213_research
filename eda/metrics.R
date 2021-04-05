library(here)
library(tidyverse)

#### DATA INPUT ####
matriz_od <-
  arrow::read_parquet(here("data/data_processed/od_matrix_complete.parquet"))

matriz_od_filtered <-
  matriz_od %>% filter(total_pax > 1000) %>% filter(distance_km > 200)

#### STATISTICS ####
routes_ratio <- nrow(matriz_od_filtered) / nrow(matriz_od)
total_pax_ratio <-
  sum(matriz_od_filtered$total_pax) / sum(matriz_od$total_pax)

#### OUTPUT ####
cat("% of total routes evaluated: ", round(100*routes_ratio),"%\n", sep = "")
cat("% of total passengers evaluated: ", round(100*total_pax_ratio),"%\n", sep="")