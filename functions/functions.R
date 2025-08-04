## Functions


###  Estiamte distance between points ======

estimate_distance <- function(x) {
  c(0, diff(x, lag=1))
}


### Estimate elapsed time ===================

estimate_elapsed_time <- function(x) {
  time_temp <- strptime(x, format = "%Y-%m-%d %H:%M:%S")
  time_temp <- as.numeric(time_temp)
  time_diff <- c(0, diff(time_temp, lag=1))
  return(time_diff)
}


### END =====================================
