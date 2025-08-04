###
# Project: Garmin
# Purpose: Correct GPS data
# Author: Henrik-Alexander Schubert
# Date: 2025/08/04
###


## Analyze the relationships ===============

# Plot the heart profile
ggplot(df_sf, aes(x=log(speed), y=heart_rate)) +
  geom_point(alpha=0.5) +
  geom_smooth(method="lm")


## Simple feature ============================

# Create groupsings
df_sf$group <- NA
df_sf$change <- ifelse(abs(df_sf$speed - df_sf$speed[c(2:nrow(df_sf), nrow(df_sf))]) > df_sf$speed/0.01, 1, 0)

df_line <- df_sf %>% 
  st_combine() %>% 
  st_cast("LINESTRING")


# Plot the elevation
ggplot(df_sf, aes(colour=pace)) +
  geom_sf() +
  geom_sf(data=df_sf, colour="black") +
  scale_colour_gradient2(low="#e66101", high="#5e3c99")

# Plot the elevation profile
ggplot(df_sf, aes(x=cum_distance/1000, y=altitude)) +
  geom_hline(yintercept=0) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x, bs = "cs")) +
  geom_line(alpha=0.5) +
  scale_x_continuous("Distance (km)", n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Alitude (m)", n.breaks=20)  +
  guides(
    x = guide_axis(minor.ticks = TRUE),
    y = guide_axis(minor.ticks = TRUE)
  )


# Plot the elevation profile
ggplot(df_sf, aes(x=cum_distance/1000, y=speed)) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x)) +
  geom_line(alpha=0.5) +
  scale_x_continuous(n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Speed (m/s)", expand=c(0, 0))+
  guides(
    x = guide_axis(minor.ticks = TRUE),
    y = guide_axis(minor.ticks = TRUE)
  )

# Plot the heart profile
ggplot(df_sf, aes(x=cum_distance/1000, y=heart_rate)) +
  geom_smooth(method="gam", se=F, formula = y ~ s(x, bs = "cs")) +
  geom_line(alpha=0.5) +
  scale_x_continuous("Distance (km)", n.breaks=20, limits = c(0, max(df_sf$cum_distance)/1000), expand=c(0, 0)) +
  scale_y_continuous("Heart rate (beats/minute)", expand=c(0, 0), n.breaks=20) +
  guides(
    x = guide_axis(minor.ticks = TRUE),
    y = guide_axis(minor.ticks = TRUE)
  )


# Plot in leaflet ============================


# Plot the race
map <- leaflet() %>% 
  addTiles() %>% 
  addPolylines(data=gps_df, lat =~latitude, lng=~longitude,
               color = ~"black", opacity = 0.8, weight = 3) %>% 
  addCircles(data=gps_df, lat =~latitude, lng=~longitude,
             color = "#000000", opacity = 0.8, weight = 3)

mapshot(map, file="figures/map_run.pdf")
mapshot(map, file="figures/map_run.jpeg")


### END ######################################