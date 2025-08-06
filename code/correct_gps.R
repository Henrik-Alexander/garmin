###
# Project: Garmin
# Purpose: Correct GPS data
# Author: Henrik-Alexander Schubert
# Date: 2025/08/04
###




## Clean the data ============================

# Remov observations
select_observations <- gps_df$speed < 28 & gps_df$pace < 10
gps_df <- gps_df[select_observations, ]



### END #################################