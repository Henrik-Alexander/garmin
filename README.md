04/08/2025

## Overview
This directory contains code to clean, plot, analyze and save data from [Garmin connect](https://connect.garmin.com/).


![alt text here](figures/map_run.jpeg)


## Code


- [Correct the GPS-data](code/correct_gps.R): This script can be used to correct GPS information. The filtering is done by pace and speed, which are assumed to be below 30m/s and faster than 10min/km.


## Functions

- [Helper functions](functions/functions.R): small helper functions
- [Graphic theme](functions/theme.R): create the graphic template
- [Save the data](functions/save_data.R): save the data



### 