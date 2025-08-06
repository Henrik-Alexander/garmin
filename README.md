04/08/2025

## Overview
This directory contains code to clean, plot, analyze and save data from [Garmin connect](https://connect.garmin.com/).

*Note that parts of the code are copied from [Stephen Royle ](https://www.r-bloggers.com/2025/05/a-pace-far-different-finding-best-running-pace-with-r/)*
![alt text here](figures/map_run.jpeg)




## Packages



## Code


- [Correct the GPS-data](code/correct_gps.R): This script can be used to correct GPS information. The filtering is done by pace and speed, which are assumed to be below 30m/s and faster than 10min/km.


## Functions

- [Helper functions](functions/functions.R): small helper functions
- [Graphic theme](functions/theme.R): create the graphic template
- [Save the data](functions/save_data.R): save the data



### 