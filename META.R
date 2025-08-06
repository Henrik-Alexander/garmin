###
# Project: Garmin
# Purpose: META
# Author: Henrik-Alexander Schubert
# Date: 2025/08/04
###

rm(list = ls()); gc(T)

# Load the different packages
library(XML)
library(trackeR)
library(leaflet)
library(tidyverse)
library(sf)
library(lubridate)
library(units)
library(mapview)
library(webshot)

# Load the fucntions
source("functions/functions.R")
source("functions/theme.R")
source("functions/save_data.R")

## Create the folder ------------------------------

folders <- c("raw", "data", "code", "functions", "figures")
lapply(folders, function(folder) if(!file.exists(folder)) dir.create(folder))

### Load the file =======================
# 
# gps_df <- htmlTreeParse(file=list.files("raw", full.names = T),
#                         useInternalNodes = TRUE)

# Read the data
gps_df <- readGPX(file=list.files("raw", full.names = T))

### Prepare the data ====================

source("code/prepare_data.R")

### Correct the data ===================

source("code/correct_gps.R")

### Create SF =========================

# Create a simple features object
df_sf <- st_as_sf(gps_df, coords= c("longitude", "latitude"),
                  crs=4326)

# Re-estimate the distances
df_sf <- df_sf |> 
  mutate(distance = st_distance(geometry, lead(geometry)))

# Re-create the coordinates
df_sf[, c("longitude", "latitude")] <- st_coordinates(df_sf)

# Prepare data again
source("code/prepare_data.R")

### Visualize the data ================

source("code/visualize.R")

# Save the filtered data ===================

write_file(str_remove(list.files("raw"), ".gpx"), 
           dataset=gps_df,
           title="Running Rostock corrected")


# Correact David's data ====================

source("code/correct_david.R")


### END ###################################