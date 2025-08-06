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


### Estimate pace ===========================

kmh_to_mkm <- function(kmh) {
  sekunden <- 3600/(kmh)
  tmp <- sekunden/60
  minuten <- floor(tmp)*60 
  c(minuten=floor(tmp), sekunden=sekunden - minuten)
  
}


### Estimate the haversine distance =========

estimate_haversine_distance <- function(lat1, lon1, lat2, lon2) {
  R <- 6371e3
  phi_1 <- lat1 * pi / 180
  phi_2 <- lat2 * pi / 180
  delta_phi <- (lat2-lat1) * pi/180
  delta_lambda <- (lon2-lon1) * pi / 180
  
  # Estimate the other parts
  a <- sin(delta_phi/2)^2 + cos(phi_1) * cos(phi_2) * sin(delta_lambda/2) * sin(delta_lambda/2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1-a))
  d <- R * c
  
  return(d)

}
### END =====================================
