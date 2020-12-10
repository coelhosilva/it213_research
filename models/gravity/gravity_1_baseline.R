set.seed(213)

library(here)
library(tidyverse)
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
model_gravity <- glm(
  viagensTotais ~ log(pop_origem)+log(pop_destino)+log(ppc_origem)+log(ppc_destino)+log(distancia),
  na.action = na.exclude,
  family = poisson(link = "log"),
  data = train
)

predict_gravity <- function(model, dataset) {
  k <- model$coefficients[1]
  beta_1 <- model$coefficients[2]
  beta_2 <- model$coefficients[3]
  beta_3 <- model$coefficients[4]
  beta_4 <- model$coefficients[5]
  beta_5 <- model$coefficients[6]
  
  y_pred <- (
    exp(k)*
      exp(beta_1*log(dataset$pop_origem))*
      exp(beta_2*log(dataset$pop_destino))*
      exp(beta_3*log(dataset$ppc_origem))*
      exp(beta_4*log(dataset$ppc_destino))*
      exp(beta_5*log(dataset$distancia))
  )
  
  return(y_pred)
}

# RESULTS ASSESSMENT
## Predicting
y_train <- train$viagensTotais
y_train_pred <- predict_gravity(model_gravity, train)

y_test <-test$viagensTotais
y_test_pred <- predict_gravity(model_gravity, test)

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

## Histogram of error
ggplot(error_actual_df, aes(x = error_actual)) + 
  geom_histogram(bins=round(sqrt(nrow(error_actual_df)))) +
  ggtitle("Histograma do erro") +
  ylab("Ocorrências") + 
  xlab("Erro absoluto") + 
  xlim(-10000,10000)

## Density of error
ggplot(error_actual_df, aes(error_actual)) +
  geom_density() +
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

# Saving model error
save_model_error <- FALSE
if(save_model_error) {
  error_actual_df$model <- "Gravity-1"
  saveRDS(error_actual_df, "error_df_gravity1.RDS")
}