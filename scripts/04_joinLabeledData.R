# Loads the databases
setwd("C:/Users/Thamires.Marques/Documents/TCC/Dados/Agrupados")
clean_databases <- list.files(getwd(), pattern="dataclean")
sapply(clean_databases, load, envir=.GlobalEnv)

# Joins the data into 1 data frame
data <- do.call(rbind, mget(ls(pattern="data_clean")))

# Changes row names
rownames(data) <- 1:nrow(data)

# Removes the individual objects
rm(list=ls(pattern="clean"))

# Saving joined data from all months
save(data, file="GroupedCleanData.RData")
