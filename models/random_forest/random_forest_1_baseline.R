set.seed(213)

library(here)
library(tidyverse)
library(randomForest)
library(Metrics)

# DATA INPUT
matriz_od <- readRDS(here("data/model_input/matriz_od_aerea_br_econ.RDS"))

# DATA PREP
matriz_od <- matriz_od %>%
  filter(
    viagensTotais > 1000
    ) %>%
  subset(
    select=-c(codigo_ibge_destino,
              codigo_ibge_origem,
              idmunicipioorigem,
              idmunicipiodestino,
              municipioorigem,
              municipiodestino
              )
    )

matriz_od <- matriz_od[,c("viagensTotais",
                          "pop_origem",
                          "pop_destino",
                          "distancia",
                          "ppc_origem",
                          "ppc_destino")]

## Train test splits
training_interval <- caret::createDataPartition(
  y=matriz_od$viagensTotais,
  p=0.8,
  list=FALSE
  )

train <- matriz_od[training_interval,]
test <- matriz_od[-training_interval,]

# MODEL FITTING
rf_res <- tuneRF(
  x = subset(
    train,
    select = -viagensTotais
    ),
  y = train$viagensTotais,
  ntreeTry = 500,
  doBest = TRUE
  )

# RESULTS ASSESSMENT
## Predicting
y_train <- train$viagensTotais
y_train_pred = round(predict(rf_res, train), 0)

y_test <-test$viagensTotais
y_test_pred <- round(predict(rf_res, test), 0)

## Defining predictions and errors
prediction_df <- tibble(
  actual = y_test,
  prediction = y_test_pred
  )

error_actual_df <- tibble(
  error_actual = y_test_pred - y_test
  )

# OUTPUTS
## Plotting predictions
ggplot(prediction_df) +
  geom_point(aes(x = actual, y = prediction), alpha=0.5, color="#66CC99") + 
  ggtitle("Predição vs valor real - conjunto de teste") + 
  geom_line(aes(x = actual, y=actual,), color="#9999CC") + 
  ylab("Predição") + 
  xlab("Valor real")

# Another way to visualize predictions
ggplot(prediction_df, aes(actual, prediction)) +
  # Add a smoothed line
  geom_smooth() +
  # Add a line at actual = predicted
  geom_abline(intercept = 0, slope = 1) + 
  ylim(0, 800000)

## Histogram of error
ggplot(error_actual_df, aes(x = error_actual)) + 
  geom_histogram(bins=round(sqrt(nrow(error_actual_df)))) +
  ggtitle("Histograma do erro") +
  ylab("Ocorrências") + 
  xlab("Erro absoluto") + 
  xlim(-10000,10000)

## Density of error
ggplot(error_actual_df, aes(error_actual)) +
  # Add a density curve
  geom_density() +
  # Add a vertical line through zero
  geom_vline(xintercept = 0) + 
  xlim(-10000,10000)


## Priting error measurements
print("Train dataset")
cat("RMSE: ", rmse(y_train, y_train_pred))
cat("MAE: ", mae(y_train, y_train_pred))
cat("RAE: ", Metrics::rae(y_train, y_train_pred))

print("Test dataset")
cat("RMSE: ", rmse(y_test, y_test_pred))
cat("MAE: ", mae(y_test, y_test_pred))
cat("RAE: ", Metrics::rae(y_test, y_test_pred))

cat("RAE: ", Metrics::rae(y_test, y_test_pred))

# Saving model error
save_model_error <- FALSE
if(save_model_error) {
  error_actual_df$model <- "RF-1"
  saveRDS(error_actual_df, "error_df_rf1.RDS")
}
