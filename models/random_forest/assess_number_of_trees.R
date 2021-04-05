set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("models/common_functions.R"))

#### DATA MODELING ####
## INPUT
train <- readRDS(here("data/model_input/train.RDS"))
valid <- readRDS(here("data/model_input/valid.RDS"))

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
valid_1 <- valid[, used_vars_1]

train_2 <- train[, used_vars_2]
valid_2 <- valid[, used_vars_2]

y_train <- train[, Y]
y_valid <- valid[, Y]

#### MODEL TRAINING ####
## Insert model training code here.
rf_1 <-
  jsonlite::read_json(here("models/random_forest/rf_1/best_model.json"))
rf_2 <-
  jsonlite::read_json(here("models/random_forest/rf_2/best_model.json"))

n_trees <- seq(1, 1000, 10)
n <- length(n_trees)

rmse_rf_1 <- vector(mode = "numeric", length = n)
rmse_rf_2 <- vector(mode = "numeric", length = n)

for (i in 1:n) {
  print(sprintf("Training %sth model group out of %s", i, n))
  
  model_1 <- ranger::ranger(
    formula = total_pax ~ .,
    data = train_1,
    num.trees = n_trees[i],
    mtry = rf_1$mtry,
    max.depth = rf_1$maxdepth,
    min.node.size = rf_1$minnode,
    splitrule = rf_1$splitrule
  )
  
  model_2 <- ranger::ranger(
    formula = total_pax ~ .,
    data = train_2,
    num.trees = n_trees[i],
    mtry = rf_2$mtry,
    max.depth = rf_2$maxdepth,
    min.node.size = rf_2$minnode,
    splitrule = rf_2$splitrule
  )
  
  # Predicting
  rmse_rf_1[i] <- Metrics::rmse(actual = y_valid,
                                predicted = predict(model_1$forest, valid_1)$predictions)
  rmse_rf_2[i] <- Metrics::rmse(actual = y_valid,
                                predicted = predict(model_2$forest, valid_2)$predictions)
}

rf_1_tree_performance <-
  data.frame(n_trees = n_trees, rmse = rmse_rf_1)
rf_1_tree_performance$Model <- "RF-1"

rf_2_tree_performance <-
  data.frame(n_trees = n_trees, rmse = rmse_rf_2)
rf_2_tree_performance$Model <- "RF-2"

tree_performance <-
  bind_rows(rf_1_tree_performance, rf_2_tree_performance)

saveRDS(
  tree_performance,
  here(
    'postprocessing/performance_metrics/training_history/number_of_trees_performance.RDS'
  )
)
