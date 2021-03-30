library(Metrics)
library(tidyverse)

plot_prediction_actual_scatter <- function(prediction_df, set_category) {
  p <- ggplot(prediction_df) +
    geom_point(aes(x = actual, y = prediction),
               alpha = 0.5,
               color = "#66CC99") +
    ggtitle(stringr::str_glue("Prediction vs real value - ", set_category)) +
    geom_point(aes(x = actual, y = actual,), alpha=0.3, color = "#9999CC") +
    geom_line(aes(x = actual, y = actual,), alpha=0.2, color = "#9999CC") +
    ylab("Predição") +
    xlab("Valor real")
  
  return(p)
}

plot_prediction_actual_line <- function(prediction_df) {
  ggplot(prediction_df) +
    geom_point(aes(x = actual, y = prediction),
               alpha = 0.5,
               color = "#66CC99") +
    ggtitle("Prediction vs real value - test set") +
    geom_line(aes(x = actual, y = actual,), color = "#9999CC") +
    ylab("Prediction") +
    xlab("Real value")
}

plot_error_histogram <- function(error_df) {
  ## Histogram of error
  ggplot(error_df, aes(x = error)) +
    geom_histogram(bins = round(sqrt(nrow(error_df)))) +
    ggtitle("Error histogram") +
    ylab("Ocorrencies") +
    xlab("Absolute error") +
    xlim(-10000, 10000)
}

plot_error_density <- function(error_df) {
  ## Density of error
  ggplot(error_df, aes(error)) +
    geom_density() +
    geom_vline(xintercept = 0) +
    xlim(-10000, 10000)
}

print_performance_metrics <- function(y_train, pred_train, y_valid, pred_valid, y_test, pred_test) {
  cat("Train dataset: \n")
  cat("RMSE: ", rmse(y_train, pred_train),"\n")
  cat("MAE: ", mae(y_train, pred_train),"\n")
  cat("RAE: ", Metrics::rae(y_train, pred_train),"\n")
  cat("MAPE: ", Metrics::mape(y_train, pred_train),"\n")
  cat("\n")
  cat("Validation dataset: \n")
  cat("RMSE: ", rmse(y_valid, pred_valid),"\n")
  cat("MAE: ", mae(y_valid, pred_valid),"\n")
  cat("RAE: ", Metrics::rae(y_valid, pred_valid),"\n")
  cat("MAPE: ", Metrics::mape(y_valid, pred_valid),"\n")
  cat("\n")
  cat("Test dataset: \n")
  cat("RMSE: ", rmse(y_test, pred_test),"\n")
  cat("MAE: ", mae(y_test, pred_test),"\n")
  cat("RAE: ", Metrics::rae(y_test, pred_test),"\n")
  cat("MAPE: ", Metrics::mape(y_test, pred_test),"\n")
}

calculate_print_performance_metrics <- function(model, train, test, y_train, y_test) {
  pred_train <- predict(object = model, newdata = train)
  cat("Train dataset: \n")
  cat("RMSE: ", rmse(y_train, pred_train),"\n")
  cat("MAE: ", mae(y_train, pred_train),"\n")
  cat("RAE: ", Metrics::rae(y_train, pred_train),"\n")
  cat("MAPE: ", Metrics::mape(y_test, pred_train),"\n")
  
  pred_test <- predict(object = model, newdata = test)
  cat("\n")
  cat("Test dataset: \n")
  cat("RMSE: ", rmse(y_test, pred_test),"\n")
  cat("MAE: ", mae(y_test, pred_test),"\n")
  cat("RAE: ", Metrics::rae(y_test, pred_test),"\n")
  cat("MAPE: ", Metrics::mape(y_test, pred_test),"\n")
}




