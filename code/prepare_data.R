

## Distance -----------------------------

# Estiamte the distance
gps_df$dist_diff <- estimate_distance(gps_df$distance)

# Estimate the time ---------------------

# time calculations
gps_df$time_difference <- estimate_elapsed_time(gps_df$time)

## Pace ----------------------------------

# Estimate the speed: m/s
gps_df$speed <- ifelse(gps_df$dist_diff==0, 0, 3.6 * (gps_df$dist_diff / gps_df$time_difference))

# Estimate the pace: min/km
gps_df$pace <- ifelse(gps_df$distance==0, 0, (3600/gps_df$speed) * (gps_df$dist_diff/1000))


### END ##################################