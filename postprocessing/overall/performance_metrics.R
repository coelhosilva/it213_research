#### LIBS ####
library(here)
library(tidyverse)

#### INPUTS ####
rf_performance <-
  readRDS(
    here(
      'postprocessing/performance_metrics/batch_performance/rf_performance.RDS'
    )
  )
rf_performance_1 <- rf_performance[rf_performance$Model == 'RF-1', ]
rf_performance_2 <- rf_performance[rf_performance$Model == 'RF-2', ]

dnn_performance_1 <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/batch_performance/dnn_1_performance.csv'
    ),
    sep = ",",
    dec = "."
  )
dnn_performance_2 <-
  read.csv2(
    here(
      'postprocessing/performance_metrics/batch_performance/dnn_2_performance.csv'
    ),
    sep = ",",
    dec = "."
  )

dnn_performance <- rbind(dnn_performance_1, dnn_performance_2)

gravity_1_predictions <-
  readRDS(
    here(
      'postprocessing/performance_metrics/predictions/test_predictions_gravity_1.RDS'
    )
  )

gravity_2_predictions <-
  readRDS(
    here(
      'postprocessing/performance_metrics/predictions/test_predictions_gravity_2.RDS'
    )
  )

#### PERFORMANCE METRICS ####
# rmses <- c()
# maes <- c()
# mapes <- c()
# N_Y <- 784
# for (i in nrow(dnn_performance_1)) {
#   rmses <- c(rmses, rep(dnn_performance_1$rmse[i], N_Y))
#   maes <- c(maes, rep(dnn_performance_1$mae[i], N_Y))
#   mapes <- c(mapes, rep(dnn_performance_1$mape[i], N_Y))
# }

gravity_metrics <- data.frame(gravity_1 = c(round(Metrics::rmse(gravity_1_predictions$actual, gravity_1_predictions$prediction)), 
                         round(Metrics::mae(gravity_1_predictions$actual, gravity_1_predictions$prediction)),
                         Metrics::mape(gravity_1_predictions$actual, gravity_1_predictions$prediction)
                         ),
           gravity_2 = c(
             round(Metrics::rmse(gravity_2_predictions$actual, gravity_2_predictions$prediction)),
             round(Metrics::mae(gravity_2_predictions$actual, gravity_2_predictions$prediction)),
             Metrics::mape(gravity_2_predictions$actual, gravity_2_predictions$prediction)
           )
)
gravity_metrics$delta <- gravity_metrics$gravity_2/gravity_metrics$gravity_1 - 1
gravity_metrics$delta[3] = gravity_metrics$gravity_2[3] - gravity_metrics$gravity_1[3]

cat("Gravity-1\n")
cat(paste("Gravity-1 RMSE:", round(Metrics::rmse(gravity_1_predictions$actual, gravity_1_predictions$prediction))), "\n")
cat(paste("Gravity-1 MAE:", round(Metrics::mae(gravity_1_predictions$actual, gravity_1_predictions$prediction))), "\n")
cat(paste("Gravity-1 MAPE:", round(Metrics::mape(gravity_1_predictions$actual, gravity_1_predictions$prediction), 3)), "\n")
cat("\n")
cat("Gravity-2\n")
cat(paste("Gravity-2 RMSE:", round(Metrics::rmse(gravity_2_predictions$actual, gravity_2_predictions$prediction))), "\n")
cat(paste("Gravity-2 MAE:", round(Metrics::mae(gravity_2_predictions$actual, gravity_2_predictions$prediction))), "\n")
cat(paste("Gravity-2 MAPE:", round(Metrics::mape(gravity_2_predictions$actual, gravity_2_predictions$prediction), 3)), "\n")

cat("\n")
cat("RF-1\n")
cat(paste("RF-1 RMSE:", round(mean(rf_performance_1$rmse)), "\n"))
cat(paste("RF-1 MAE:", round(mean(rf_performance_1$mae)), "\n"))
cat(paste("RF-1 MAPE:", round(mean(rf_performance_1$mape), 3), "\n"))
cat("\n")
cat("RF-2\n")
cat(paste("RF-2 RMSE:", round(mean(rf_performance_2$rmse)), "\n"))
cat(paste("RF-2 MAE:", round(mean(rf_performance_2$mae)), "\n"))
cat(paste("RF-2 MAPE:", round(mean(rf_performance_2$mape), 3), "\n"))

rf_metrics <- data.frame(
  rf_1 = c(
    round(mean(rf_performance_1$rmse)),
    round(mean(rf_performance_1$mae)),
    mean(rf_performance_1$mape)
  ),
  rf_2 = c(
    round(mean(rf_performance_2$rmse)),
    round(mean(rf_performance_2$mae)),
    mean(rf_performance_2$mape)
  )
)
rf_metrics$delta <- rf_metrics$rf_2/rf_metrics$rf_1 - 1
rf_metrics$delta[3] = rf_metrics$rf_2[3] - rf_metrics$rf_1[3]

cat("\n")
cat("DNN-1\n")
cat(paste("DNN-1 RMSE:", round(mean(dnn_performance_1$rmse)), "\n"))
cat(paste("DNN-1 MAE:", round(mean(dnn_performance_1$mae)), "\n"))
cat(paste("DNN-1 MAPE:", round(mean(dnn_performance_1$mape), 3), "\n"))
cat("\n")
cat("DNN-2\n")
cat(paste("DNN-2 RMSE:", round(mean(dnn_performance_2$rmse)), "\n"))
cat(paste("DNN-2 MAE:", round(mean(dnn_performance_2$mae)), "\n"))
cat(paste("DNN-2 MAPE:", round(mean(dnn_performance_2$mape), 3), "\n"))
