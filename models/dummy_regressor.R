# model class
dummyRegressor <- function(X, Y, ...) {
  model = structure(list(x = X, y = Y),
                    class = "dummyRegressorClass")
  return(model)
}

# predict method
predict.dummyRegressorClass = function(modelObject, test) {
  return(sample(modelObject$y,
                size = nrow(test),
                replace = TRUE))
}
