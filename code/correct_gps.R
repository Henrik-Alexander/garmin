###
# Project: Garmin
# Purpose: Correct GPS data
# Author: Henrik-Alexander Schubert
# Date: 2025/08/04
###

library(XML)
library(trackeR)
library(leaflet)
library(tidyverse)
library(sf)
library(lubridate)
library(units)
library(mapview)

# Load the fucntions
source("functions/functions.R")
source("functions/theme.R")
source("functions/save_data.R")

## Code is based on:
# https://www.r-bloggers.com/2025/05/a-pace-far-different-finding-best-running-pace-with-r/

### Load the file =======================

gps_df <- htmlTreeParse(file=list.files("raw", full.names = T),
                        useInternalNodes = TRUE)

### Extract the details =================

# Read the data
gps_df <- readGPX(file=list.files("raw", full.names = T))


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

## Clean the data ============================

# Removobserva
select_observations <- gps_df$speed < 25 & gps_df$pace < 10
gps_df <- gps_df[select_observations, ]

# Estiamte the distance
gps_df$dist_diff <- estimate_distance(gps_df$distance)

# time calculations
gps_df$time_difference <- estimate_elapsed_time(gps_df$time)

# Create a simple features object
df_sf <- st_as_sf(gps_df, coords= c("longitude", "latitude"),
                  crs=4326)

## Create the average data ===================

# Estimate the cumulative distance
df_sf$cum_distance <- cumsum(df_sf$dist_diff)

# Estimate the average pace: weight by distance
sum(df_sf$pace * (df_sf$dist_diff/sum(df_sf$dist_diff, na.rm=T)), na.rm=T)

## Simple feature ============================

# Plot the elevation
ggplot(df_sf, aes(colour=pace)) +
  geom_sf() +
  scale_colour_gradient2(low="#e66101", high="#5e3c99")


# Plot the elevation profile
ggplot(df_sf, aes(x=cum_distance/1000, y=altitude)) +
  geom_hline(yintercept=0) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x, bs = "cs")) +
  geom_line(alpha=0.5) +
  scale_x_continuous(n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Alitude", n.breaks=20)


# Plot the elevation profile
ggplot(df_sf, aes(x=cum_distance/1000, y=speed)) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x, bs = "cs")) +
  geom_line(alpha=0.5) +
  scale_x_continuous(n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Speed (m/s)")

# Plot the heart profile
ggplot(df_sf, aes(x=cum_distance/1000, y=heart_rate)) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x, bs = "cs")) +
  geom_line(alpha=0.5) +
  scale_x_continuous(n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Speed (m/s)", limits=c(39, 195), expand=c(0, 0))


## Analyze the relationships ===============

# Plot the heart profile
ggplot(df_sf, aes(x=log(speed), y=heart_rate)) +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm")

## Analyze the training ====================

# Function of distance and effort
model <- lm(heart_rate ~ cum_distance + speed + poly(speed, 2) + cum_distance * speed + cum_distance * poly(speed, 2), data=df_sf)

summary(model)

# Predict the data
sim_data <- expand.grid(cum_distance = seq(0, 41000, by=20),
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

# Plot in leaflet ============================

# Create the kilometer markers


# Plot the race
map <- leaflet() %>% 
  addTiles() %>% 
  addPolylines(data=gps_df, lat =~latitude, lng=~longitude,
               color = ~"black", opacity = 0.8, weight = 3) %>% 
  addCircles(data=gps_df, lat =~latitude, lng=~longitude,
               color = "#000000", opacity = 0.8, weight = 3)

mapshot(map, file="figures/map_run.pdf")
mapshot(map, file="figures/map_run.jpeg")


# Save the filtered data ===================

write_file(str_remove(list.files("raw"), ".gpx"), 
           dataset=gps_df,
           title="Running Rostock corrected")


### END #################################