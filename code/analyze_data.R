###
# Project: Garmin
# Purpose: Analyze garmin data
# Author: Henrik-Alexander Schubert
# Date: 2025/08/04
###


## Create the average data ===================

# Estimate the cumulative distance
df_sf$cum_distance <- cumsum(df_sf$dist_diff)

# Estimate the average pace: weight by distance
sum(df_sf$pace * (df_sf$dist_diff/sum(df_sf$dist_diff, na.rm=T)), na.rm=T)

## Analyze the training ====================

# Function of distance and effort
model <- lm(heart_rate ~ cum_distance + poly(speed, 2)  + cum_distance * poly(speed, 2), data=df_sf)

summary(model)

# Predict the data
sim_data <- expand.grid(cum_distance = seq(0, max(df_sf$cum_distance), by=20),
                        speed = seq(5, 25, by=0.25))

# Predict the hear rate
sim_data$predicted_hr <- predict(model, sim_data)


# Plot the result
ggplot(sim_data, aes(x=speed, y=cum_distance/1000, fill=predicted_hr)) +
  geom_tile() +
  scale_fill_viridis_c(option="magma") +
  scale_x_continuous("Speed (m/s)", expand=c(0, 0)) +
  scale_y_continuous("Distance (km)", n.breaks=10, expand=c(0, 0))

# Plot the result
ggplot(sim_data, aes(x=speed, y=cum_distance/1000, fill=cut(predicted_hr, breaks=c(0, 120, 140, 160, 180, 205, 400), labels=c(paste("Zone", 1:5), "Too fast"), include.lowest=T))) +
  geom_tile() +
  scale_fill_viridis_d("Zones", option="magma", direction=-1) +
  scale_x_continuous("Speed (m/s)", expand=c(0, 0), minor_breaks = 5:25) +
  scale_y_continuous("Distance (km)", n.breaks=10, expand=c(0, 0), minor_breaks = 0:40) +
  guides(fill=guide_legend(position="bottom")) +
  guides(
    x = guide_axis(minor.ticks = TRUE),
    y = guide_axis(minor.ticks = TRUE)
  )



### END ####################################