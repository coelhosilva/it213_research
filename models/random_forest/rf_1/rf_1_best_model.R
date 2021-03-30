set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("models/common_functions.R"))

#### DATA MODELING ####
## INPUT
train <- readRDS(here("data/model_input/train.RDS"))
valid <- readRDS(here("data/model_input/valid.RDS"))
test <- readRDS(here("data/model_input/test.RDS"))

## PREP
X <- c(
  "population_origin",
  "population_destination",
  "distance_km",
  "gdp_per_capita_origin",
  "gdp_per_capita_destination"
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
best_model_hyperparameters <-
  jsonlite::read_json(here('models/random_forest/rf_1/best_model.json'))

model <- ranger::ranger(
  formula = total_pax ~ .,
  data = train,
  num.trees = 500,
  mtry = best_model_hyperparameters$mtry,
  max.depth = best_model_hyperparameters$maxdepth,
  min.node.size = best_model_hyperparameters$minnode,
  splitrule = best_model_hyperparameters$splitrule
)

#### PREDICTING ####
## Defining Ŷ
y_train_pred <- predict(model$forest, train)$predictions
y_valid_pred <- predict(model$forest, valid)$predictions
y_test_pred <- predict(model$forest, test)$predictions

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
  error_actual_df$model <- "MODEL-NAME"
  saveRDS(error_actual_df, "error_df_MODEL_NAME.RDS")
}
