set.seed(213)

#### LIBS ####
library(here)
library(tidyverse)
source(here("models/common_functions.R"))

#### DATA MODELING ####
## INPUT
train <- readRDS(here("data/data_processed/train.RDS"))
valid <- readRDS(here("data/data_processed/valid.RDS"))

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

y_train <- train[, Y]
y_valid <- valid[, Y]

#### MODEL HYPERPARAMETER TUNING ####
# Creating training grid
# Establish a list of possible values
mtry <- seq(3, 5, 1)
maxdepth <- seq(8, 22, 1)
minnode <- seq(1, 20)
splitrule <- c("variance")

# Create a data frame containing all combinations
hyper_grid <- expand.grid(
  mtry = mtry,
  maxdepth = maxdepth,
  minnode = minnode,
  splitrule = splitrule
)

# Generating models
# Number of potential models in the grid
num_models <- nrow(hyper_grid)

rmse_values <- vector(mode = "list", length = num_models)
for (i in 1:num_models) {
  print(sprintf("Training %sth model of %s", i, num_models))
  
  # Grabbing hyperparameters
  mtry <- hyper_grid$mtry[i]
  maxdepth <- hyper_grid$maxdepth[i]
  minnode <- hyper_grid$minnode[i]
  splitrule <- hyper_grid$splitrule[i]
  
  # Train a model and store in the list
  candidate_model <- ranger::ranger(
    formula = total_pax ~ .,
    data = train,
    num.trees = 300,
    mtry = mtry,
    max.depth = maxdepth,
    min.node.size = minnode,
    splitrule = splitrule
  )
  
  # Predicting
  pred <- predict(candidate_model$forest, valid)$predictions
  rmse_values[i] <- Metrics::rmse(actual = y_valid,
                                  predicted = pred)
}

rmse_df <-
  data.frame(rmse = matrix(
    unlist(rmse_values),
    nrow = length(rmse_values),
    byrow = TRUE
  ))
hyper_grid$rmse <- rmse_df$rmse
best_hyperparameters <- hyper_grid[which.min(rmse_values),]

#### OUTPUTS ####
jsonlite::write_json(
  x = as.list(best_hyperparameters),
  path = here('models/random_forest/rf_1/tuning/results/round_2.json'),
  auto_unbox = TRUE,
  pretty = 4
)
saveRDS(hyper_grid, here('models/random_forest/rf_1/tuning/results/round_2_grid.RDS'))
