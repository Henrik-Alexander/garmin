### Correct DAvids data

# Create a new object
df_d <- gps_df

### Settings =========================================

# Get the time: https://www.rostocker-marathon-nacht.com/ergebnisse/
time <- list(hours=1, minutes=28, seconds=50)
time <- time$hours  * (60 * 60) + time$minutes * 60 + time$seconds 
  
# Which splits to correct: only after 19.8km
change_time <- ifelse(df_d$distance>19800, TRUE, FALSE)

# Step 1: Change the finishing time ===================

# Change the last time recording
df_d$time[nrow(df_d)] <- df_d$time[1] + time

# Step 2: Estimate the average pace on the segment ====

# Get the elapsed time on the segment
duration <- df_d$time[nrow(df_d)] - df_d$time[cumsum(change_time)==1]

# Get the distance of the segment in meter
distance <- df_d$distance[nrow(df_d)] - df_d$distance[cumsum(change_time)==1]

# Get the speed (m/s)
speed <- distance / (as.numeric(duration) * 60)

cat(speed*3.6, "km/h")
kmh_to_mkm(3.6*speed)

# Step 3: Change the times for the entire segment =====


for(i in which(change_time)) {
  
  cat(i, "\n")
  
  # Overwrite the time: time (t-1) + distance / speed
  df_d$time[i] <- (df_d$distance[i]-df_d$distance[i-1]) / speed
  
}

# Re-estimate the pace and the time ====================

# Re-estimate the distance 

# Re-estimate the elapsed time
df_d$time_difference <- estimate_elapsed_time(df_d$time)

# Estimate the speed of the segment
df_d$speed <- df_d$dist_diff/df_d$time_difference

## Check the results ==================================

# Plot the speed
ggplot(data=gps_df, aes(x=distance, y=3.6*dist_diff/time_difference, colour="Henrik")) +
  geom_line(linewidth=2, alpha=0.4) +
  geom_line(data=df_d, aes(x=distance, y=3.6*speed, colour="David"), linewidth=2, alpha=.4)

### END ###############################################