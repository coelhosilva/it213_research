#### FUNCTIONS ####
permutation_sample <- function(data_1, data_2) {
  data <- append(data_1, data_2)
  permuted_data <- sample(data, length(data), replace = FALSE)
  permuted_sample_1 <- permuted_data[1:length(data_1)]
  permuted_sample_2 <-
    permuted_data[(length(data_1) + 1):length(data)]
  
  return(list(permuted_sample_1, permuted_sample_2))
}

draw_permutation_replicates <-
  function(data_1, data_2, func, size = 1) {
    permutation_replicates <- vector(mode = "numeric", length = size)
    for (i in 1:size) {
      permuted_samples <- permutation_sample(data_1, data_2)
      permutation_sample_1 <- permuted_samples[[1]]
      permutation_sample_2 <- permuted_samples[[2]]
      permutation_replicates[i] <-
        func(permutation_sample_1, permutation_sample_2)
    }
    
    return(permutation_replicates)
  }

diff_of_means <- function(data_1, data_2) {
  return(mean(data_1) - mean(data_2))
}

calculate_p_value <-
  function(permutation_replicates,
           empirical_statistic,
           operator = "gt") {
    if (operator == "gt") {
      p_value <-
        sum(perm_replicates >= empirical_diff_means) / length(perm_replicates)
    } else if (operator == "lt") {
      p_value <-
        sum(perm_replicates <= empirical_diff_means) / length(perm_replicates)
    } else {
      p_value = "undefined"
    }
    return(p_value)
  }