

## Create the folder ------------------------------


folders <- c("raw", "data", "code", "functions", "figures")
lapply(folders, function(folder) if(!file.exists(folder)) dir.create(folder))






###