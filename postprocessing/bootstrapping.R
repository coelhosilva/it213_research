bootstrap_replicate_1d <- function(data, func) {
  bs_sample <- sample(data, length(data), replace = TRUE)
  return(func(bs_sample))
}

draw_bootstrap_replicates <- function(data, func, size = 1000) {
  bs_replicates <- c()
  for (i in 1:size) {
    bs_replicates[i] <- bootstrap_replicate_1d(data, func)
  }
  return(bs_replicates)
}

confidence_interval <- function(data, ci = 0.95) {
  return(
    quantile(
      data,
      c((1 - ci) / 2, ci + ((1 - ci) / 2))
    )
  )
}
