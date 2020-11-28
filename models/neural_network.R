set.seed(213)

library(here)
library(tidyverse)
library(neuralnet)

CalcRSquared <- function(observed,estimated){
  r <- cor(observed,estimated)
  R2 <- r^2
  R2
}

CalcRMSE <- function(observed,estimated){
  res <- (observed - estimated)^2
  RMSE <- round(sqrt(mean(res)),3)
  RMSE
}

matriz_od <- readRDS(here("data/model_input/matriz_od_baseline_prepared.RDS"))

matriz_od <- matriz_od %>% filter(viagensTotais > 1000)
matriz_od_train <- matriz_od[,c("viagensTotais",
                                "pop_origem",
                                "pop_destino",
                                "ppc_origem",
                                "ppc_destino",
                                "distance_numeric")]

nn_1 <- neuralnet(viagensTotais~pop_origem+pop_destino+ppc_origem+ppc_destino+distance_numeric,
                  data=matriz_od_train,
                  hidden=c(5,3),
                  linear.output=TRUE
)

y_pred <- as.numeric(predict(nn_1, matriz_od_train))

cat("RMSE: ", CalcRMSE(matriz_od_train$viagensTotais, y_pred))

plot(matriz_od_train$viagensTotais, y_pred)
