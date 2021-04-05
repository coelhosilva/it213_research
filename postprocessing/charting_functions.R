library(tidyverse)


plot_rmse_distribution <- function(dataset, x_limits, y_limits) {
  options(scipen = 999)
  p <- ggplot(dataset, aes(rmse, color = Model, fill = Model)) +
    geom_density(alpha = 0.1) +
    geom_vline(xintercept = 0) +
    scale_x_continuous(limits = x_limits,
                       breaks = scales::pretty_breaks(n = 10)
                       # guide = guide_axis(angle=30)
    ) +
    scale_y_continuous(limits = y_limits,
                       breaks = scales::pretty_breaks(n = 10)) +
    theme(axis.text.x=element_text(angle=30, hjust=1)) +
    xlab("Root Mean Squared Error") +
    ylab("Root Mean Squared Error distribution") +
    theme(legend.position = 'bottom', text = element_text(size = 16))
  
  return(p)
}


plot_tree_performance <- function(tree_performance_dataset) {
  options(scipen = 999)
  p <-
    ggplot(tree_performance_dataset,
           aes(
             x = n_trees,
             y = rmse,
             color = Model,
             fill = Model
           )) +
    geom_line() +
    geom_point() +
    geom_errorbar(aes(ymin = rmse - sd, ymax = rmse + sd),
                  width = .2,
                  position = position_dodge(0.05)) +
    xlab("Number of trees") +
    ylab("Root Mean Squared Error - Validation set") + 
    theme(axis.title=element_text(size=16)) +
    theme(legend.position = 'bottom', text = element_text(size = 16))
  
  return(p)
}


plot_model_predictions <- function(prediction_model_1, prediction_model_2, actual_data, color_scale) {
  p <- ggplot(NULL) +
    geom_point(data = prediction_model_1, aes(x = actual, y = prediction, color = names(color_scale)[1]),
               alpha = 0.5,
    ) +
    geom_point(data = prediction_model_2, aes(x = actual, y = prediction, color = names(color_scale)[2]),
               alpha = 0.5,
    ) +
    geom_point(data = actual_data, aes(x = actual, y = actual, color = names(color_scale)[3]), alpha=0.3) +
    geom_line(data = actual_data, aes(x = actual, y = actual, color = names(color_scale)[3]), alpha=0.2) +
    scale_colour_manual(name="Model", values=color_scale) +
    scale_x_log10() + 
    scale_y_log10() +
    # ggtitle("Prediction vs real value - Test set") +
    # ylab("Total passengers - Prediction (Ŷ)") +
    ylab(latex2exp::TeX("Total passengers - Prediction ($\\hat{Y}$)")) +
    xlab("Total passengers - Actual value (Y)") +
    theme(legend.position = 'bottom', text = element_text(size=13))
  
  return(p)
}


plot_three_model_predictions <- function(prediction_model_1, prediction_model_2, prediction_model_3, actual_data, color_scale) {
  p <- ggplot(NULL) +
    geom_point(data = prediction_model_1, aes(x = actual, y = prediction, color = names(color_scale)[1]),
               alpha = 0.5,
    ) +
    geom_point(data = prediction_model_2, aes(x = actual, y = prediction, color = names(color_scale)[2]),
               alpha = 0.5,
    ) +
    geom_point(data = prediction_model_3, aes(x = actual, y = prediction, color = names(color_scale)[3]),
               alpha = 0.5,
    ) +
    geom_point(data = actual_data, aes(x = actual, y = actual, color = names(color_scale)[4]), alpha=0.3) +
    geom_line(data = actual_data, aes(x = actual, y = actual, color = names(color_scale)[4]), alpha=0.2) +
    scale_colour_manual(name="Model", values=color_scale) +
    scale_x_log10() + 
    scale_y_log10() +
    # ggtitle("Prediction vs real value - Test set") +
    # ylab("Total passengers - Prediction (Ŷ)") +
    ylab(latex2exp::TeX("Total passengers - Prediction ($\\hat{Y}$)")) +
    xlab("Total passengers - Actual value (Y)") +
    theme(legend.position = 'bottom', text = element_text(size=13))
  
  return(p)
}

plot_permutation_test <-
  function(df_perm_replicates,
           empirical_diff_means,
           x_limits,
           y_limits,
           x_label,
           x_annotation = NULL,
           y_annotation = NULL) {
  
  options(scipen = 999)
    
  if (is.null(x_annotation)) {
    x_annotation <- empirical_diff_means+5
  }
  if (is.null(y_annotation)) {
    y_annotation <- y_limits[2]/2
  }
  # color_outline <- "#025C54"
  # color_fill <- "#34C7BC"
  color_outline <- "#37464A"
  color_fill <- "#889192"
  
  p <- ggplot(df_perm_replicates, aes(difference_of_means)) +
    geom_histogram(
      aes(y = ..density..),
      alpha = 0.7,
      bins = 100,
      color = color_outline,
      fill = color_fill,
    ) +
    geom_vline(xintercept = empirical_diff_means) +
    annotate("text", x=x_annotation, y=y_annotation,
             label=paste("\nEmpirical difference of means: ", round(empirical_diff_means), sep=""),
             color = "black", angle=90) +
    scale_x_continuous(limits = x_limits,
                       breaks = scales::pretty_breaks(n = 10)) +
    scale_y_continuous(limits = y_limits,
                       breaks = scales::pretty_breaks(n = 10)) +
    xlab(x_label) +
    ylab("Probability Density Function (PDF)") +
    theme(legend.position = 'bottom', text = element_text(size = 12))

  return(p)
}

plot_training_history <- function(training_history_dataset) {
  options(scipen = 999)
  p <-
    ggplot(training_history_dataset,
           aes(
             x = epoch,
             y = value,
             color = Dataset,
             fill = Dataset
           )) +
    geom_line() +
    geom_point() +
    geom_errorbar(aes(ymin = value - sd, ymax = value + sd),
                  width = .2,
                  position = position_dodge(0.05)) +
    xlab("Epoch") +
    ylab("Huber loss - Training history") + 
    theme(axis.title=element_text(size=16)) +
    theme(legend.position = 'bottom', text = element_text(size = 16))
  
  return(p)
}