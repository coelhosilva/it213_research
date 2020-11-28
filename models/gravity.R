set.seed(213)

library(here)
library(tidyverse)

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

# Construção do modelo
uncosim <- glm(viagensTotais ~ log(pop_origem)+log(pop_destino)+log(ppc_origem)+log(ppc_destino)+log(distance_numeric),
               na.action = na.exclude,
               family = poisson(link = "log"),
               data = matriz_od_train
)

y_pred <- round(fitted(uncosim), 0)

cat("R²: ", CalcRSquared(matriz_od_train$viagensTotais, y_pred))
cat("RMSE: ", CalcRMSE(matriz_od_train$viagensTotais, y_pred))

plot(matriz_od_train$viagensTotais, y_pred)
