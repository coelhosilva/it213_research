set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("models/common_functions.R"))

#### DATA MODELING ####
## MODEL NAME
MODEL_NAME <- "Gravity-2"

## INPUT
train <- readRDS(here("data/data_processed/train.RDS"))
valid <- readRDS(here("data/data_processed/valid.RDS"))
test <- readRDS(here("data/data_processed/test.RDS"))

## PREP
X <- c(
  "population_origin",
  "population_destination",
  "distance_km",
  "gdp_per_capita_origin",
  "gdp_per_capita_destination",
  "THEIL_origin",
  "THEIL_destination"
)
Y <- "total_pax"
used_vars <- append(X, Y)

train <- train[, used_vars]
valid <- valid[, used_vars]
test <- test[, used_vars]

y_train <- train[, Y]
y_valid <- valid[, Y]
y_test <- test[, Y]

#### MODEL TRAINING ####
## Insert model training code here.
model <- glm(
  total_pax ~ log(distance_km) +
    log(population_origin) + log(population_destination) +
    log(gdp_per_capita_origin) + log(gdp_per_capita_destination) +
    log(THEIL_origin) + log(THEIL_destination),
  na.action = na.exclude,
  family = poisson(link = "log"),
  data = train
)

#### PREDICTING ####
## Defining Ŷ
y_train_pred <- predict(model, train, type = "response")
y_valid_pred <- predict(model, valid, type = "response")
y_test_pred <- predict(model, test, type = "response")

## Defining predictions and errors
prediction_df_valid <- tibble(actual = y_valid,
                              prediction = y_valid_pred)
prediction_df_test <- tibble(actual = y_test,
                             prediction = y_test_pred)
error_df_valid <- tibble(error = y_valid_pred - y_valid)
error_df_test <- tibble(error = y_test_pred - y_test)

#### OUTPUTS ####
# Plotting charts
plot_prediction_actual_scatter(prediction_df_valid, "validation set")
plot_prediction_actual_scatter(prediction_df_test, "test set")
plot_error_histogram(error_df_valid)
plot_error_density(error_df_valid)
plot_error_histogram(error_df_test)
plot_error_density(error_df_test)

# Performance metrics
print_performance_metrics(y_train,
                          y_train_pred,
                          y_valid,
                          y_valid_pred,
                          y_test,
                          y_test_pred)

# Saving model error
save_model_error <- FALSE
if (save_model_error) {
  MODEL_NAME_FILE_FRIENDLY <-
    stringr::str_replace(stringr::str_to_lower(MODEL_NAME), "-", "_")
  prediction_df_test$Model <- MODEL_NAME
  error_df_test$Model <- MODEL_NAME
  saveRDS(error_df_test,
          paste("error_df_", MODEL_NAME_FILE_FRIENDLY, ".RDS", sep = ""))
  saveRDS(
    prediction_df_test,
    paste("test_predictions_", MODEL_NAME_FILE_FRIENDLY, ".RDS", sep = "")
  )
}
