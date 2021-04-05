set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)

#### DATA PARTITIONING ####
od_matrix <-
  data.frame(arrow::read_parquet(here(
    "data/data_processed/od_matrix_complete.parquet"
  )))

od_matrix <-
  od_matrix %>% subset(total_pax > 1000 & distance_km > 200)

## Train test splits
training_interval <- caret::createDataPartition(y = od_matrix$total_pax,
                                                p = 0.7,
                                                list = FALSE)

train <- od_matrix[training_interval, ]
valid_test <- od_matrix[-training_interval, ]

valid_interval <- caret::createDataPartition(y = valid_test$total_pax,
                                             p = 0.5,
                                             list = FALSE)
valid <- valid_test[valid_interval, ]
test <- valid_test[-valid_interval, ]


#### EXPORTING ####
export <- FALSE
if (export) {
  saveRDS(train, here("data/data_processed/train.RDS"))
  saveRDS(valid, here("data/data_processed/valid.RDS"))
  saveRDS(test, here("data/data_processed/test.RDS"))
  arrow::write_parquet(train, here("data/data_processed/train.parquet"))
  arrow::write_parquet(valid, here("data/data_processed/valid.parquet"))
  arrow::write_parquet(test, here("data/data_processed/test.parquet"))
}
