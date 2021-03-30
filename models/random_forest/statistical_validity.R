set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)

#### DATA MODELING ####
## INPUT
train <- readRDS(here("data/model_input/train.RDS"))
test <- readRDS(here("data/model_input/test.RDS"))

## PREP
X_1 <- c(
  "population_origin",
  "population_destination",
  "distance_km",
  "gdp_per_capita_origin",
  "gdp_per_capita_destination"
)

X_2 <- c(
  "population_origin",
  "population_destination",
  "distance_km",
  "gdp_per_capita_origin",
  "gdp_per_capita_destination",
  "THEIL_origin",
  "THEIL_destination"
)

Y <- "total_pax"

used_vars_1 <- append(X_1, Y)
used_vars_2 <- append(X_2, Y)

train_1 <- train[, used_vars_1]
test_1 <- test[, used_vars_1]

train_2 <- train[, used_vars_2]
test_2 <- test[, used_vars_2]

y_train <- train[, Y]
y_test <- test[, Y]

#### MODEL TRAINING - REBUILDING ####
rf_1 <-
  jsonlite::read_json(here("models/random_forest/rf_1/best_model.json"))
rf_2 <-
  jsonlite::read_json(here("models/random_forest/rf_2/best_model.json"))

rounds <- 1500

test_rf_1_rmse <- vector(mode = "numeric", length = rounds)
test_rf_1_mae <- vector(mode = "numeric", length = rounds)
test_rf_1_rae <- vector(mode = "numeric", length = rounds)
test_rf_1_mape <- vector(mode = "numeric", length = rounds)
test_rf_1_bias <- vector(mode = "numeric", length = rounds)
test_rf_1_mdae <- vector(mode = "numeric", length = rounds)
test_rf_1_percent_bias <- vector(mode = "numeric", length = rounds)
test_rf_1_smape <- vector(mode = "numeric", length = rounds)
test_rf_2_rmse <- vector(mode = "numeric", length = rounds)
test_rf_2_mae <- vector(mode = "numeric", length = rounds)
test_rf_2_rae <- vector(mode = "numeric", length = rounds)
test_rf_2_mape <- vector(mode = "numeric", length = rounds)
test_rf_2_bias <- vector(mode = "numeric", length = rounds)
test_rf_2_mdae <- vector(mode = "numeric", length = rounds)
test_rf_2_percent_bias <- vector(mode = "numeric", length = rounds)
test_rf_2_smape <- vector(mode = "numeric", length = rounds)

for (i in 1:rounds) {
  print(sprintf("Evaluating %sth model group of %s", i, rounds))
  model_1 <- ranger::ranger(
    formula = total_pax ~ .,
    data = train_1,
    num.trees = 500,
    mtry = rf_1$mtry,
    max.depth = rf_1$maxdepth,
    min.node.size = rf_1$minnode,
    splitrule = rf_1$splitrule
  )
  
  model_2 <- ranger::ranger(
    formula = total_pax ~ .,
    data = train_2,
    num.trees = 500,
    mtry = rf_2$mtry,
    max.depth = rf_2$maxdepth,
    min.node.size = rf_2$minnode,
    splitrule = rf_2$splitrule
  )
  
  test_rf_1_rmse[i] <-
    Metrics::rmse(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_mae[i] <-
    Metrics::mae(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_rae[i] <-
    Metrics::rae(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_mape[i] <-
    Metrics::mape(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_bias[i] <-
    Metrics::bias(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_mdae[i] <-
    Metrics::mdae(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_percent_bias[i] <-
    Metrics::percent_bias(actual = y_test, predict(model_1$forest, test_1)$predictions)
  test_rf_1_smape[i] <-
    Metrics::smape(actual = y_test, predict(model_1$forest, test_1)$predictions)
  
  
  test_rf_2_rmse[i] <-
    Metrics::rmse(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_mae[i] <-
    Metrics::mae(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_rae[i] <-
    Metrics::rae(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_mape[i] <-
    Metrics::mape(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_bias[i] <-
    Metrics::bias(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_mdae[i] <-
    Metrics::mdae(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_percent_bias[i] <-
    Metrics::percent_bias(actual = y_test, predict(model_2$forest, test_2)$predictions)
  test_rf_2_smape[i] <-
    Metrics::smape(actual = y_test, predict(model_2$forest, test_2)$predictions)
  
}

rf_performance_side <- data.frame(
  rf_1_rmse = test_rf_1_rmse,
  rf_1_mae = test_rf_1_mae,
  rf_1_rae = test_rf_1_rae,
  rf_1_mape = test_rf_1_mape,
  rf_1_bias = test_rf_1_bias,
  rf_1_mdae = test_rf_1_mdae,
  rf_1_percent_bias = test_rf_1_percent_bias,
  rf_1_smape = test_rf_1_smape,
  rf_2_rmse = test_rf_2_rmse,
  rf_2_mae = test_rf_2_mae,
  rf_2_rae = test_rf_2_rae,
  rf_2_mape = test_rf_2_mape,
  rf_2_bias = test_rf_2_bias,
  rf_2_mdae = test_rf_2_mdae,
  rf_2_percent_bias = test_rf_2_percent_bias,
  rf_2_smape = test_rf_2_smape
)

rf_1_performance <- data.frame(
  rmse = test_rf_1_rmse,
  mae = test_rf_1_mae,
  rae = test_rf_1_rae,
  mape = test_rf_1_mape,
  bias = test_rf_1_bias,
  mdae = test_rf_1_mdae,
  percent_bias = test_rf_1_percent_bias,
  smape = test_rf_1_smape
)
rf_1_performance$Model <- "RF-1"

rf_2_performance <- data.frame(
  rmse = test_rf_2_rmse,
  mae = test_rf_2_mae,
  rae = test_rf_2_rae,
  mape = test_rf_2_mape,
  bias = test_rf_2_bias,
  mdae = test_rf_2_mdae,
  percent_bias = test_rf_2_percent_bias,
  smape = test_rf_2_smape
)
rf_2_performance$Model <- "RF-2"

rf_performance <- bind_rows(rf_1_performance, rf_2_performance)

#### OUTPUTS ####
saveRDS(rf_performance,
        here('models/random_forest/results/rf_performance.RDS'))
