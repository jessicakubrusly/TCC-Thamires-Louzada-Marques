library(dplyr)

#### JULY ####
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Brutos")

files <- list.files()
files <- list.files(pattern = "072021")

load(files[1])
base <- tweets

# Join data from july
for(i in 2:length(files)){
  print(files[i])
  
  load(files[i])
  
  base <- dplyr::full_join(base, tweets)
}

# Part 1: first 15 days
base1_1 <- base %>% 
  filter(DATE_TIME >= "2021-07-01" & DATE_TIME <= "2021-07-15")
# Removes columns (hashtags) from other periods
base1_1 <- base1_1[,colSums(is.na(base1_1)) < nrow(base1_1)]

# Part 2: last 15 days
base1_2 <- base %>% 
  filter(DATE_TIME >= "2021-07-16" & DATE_TIME <= "2021-07-31")
# Removes columns (hashtags) from other periods
base1_2 <- base1_2[,colSums(is.na(base1_2)) < nrow(base1_2)]

# Saves splitted data -- each dataset size on github limit
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Agrupados")

save(base1_1, file = "TrendingTopicsTwitterBrasil202107_1.RData")
save(base1_2, file = "TrendingTopicsTwitterBrasil202107_2.RData")





#### AUGUST ####
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Brutos")

files <- list.files()
files <- list.files(pattern = "082021")

load(files[1])
base <- tweets

# Join data from august
for(i in 2:length(files)){
  print(files[i])
  
  load(files[i])
  
  base <- dplyr::full_join(base, tweets)
}

# Part 1: first 15 days
base2_1 <- base %>% 
  filter(DATE_TIME >= "2021-08-01" & DATE_TIME <= "2021-08-15")
# Removes columns (hashtags) from other periods
base2_1 <- base2_1[,colSums(is.na(base2_1)) < nrow(base2_1)]

# Part 2: last 15 days
base2_2 <- base %>% 
  filter(DATE_TIME >= "2021-08-16" & DATE_TIME <= "2021-08-31")
# Removes columns (hashtags) from other periods
base2_2 <- base2_2[,colSums(is.na(base2_2)) < nrow(base2_2)]

# Saves splitted data -- each dataset size on github limit
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Agrupados")

save(base2_1, file = "TrendingTopicsTwitterBrasil202108_1.RData")
save(base2_2, file = "TrendingTopicsTwitterBrasil202108_2.RData")





#### SETEMBRO ####
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Brutos")

files <- list.files()
files <- list.files(pattern = "092021|01102021")

load(files[1])
base <- tweets

for(i in 2:length(files)){
  print(files[i])
  
  load(files[i])
  
  base <- dplyr::full_join(base, tweets)
}

# Part 1: first 15 days
base3_1 <- base %>% 
  filter(DATE_TIME >= "2021-09-01" & DATE_TIME <= "2021-09-15")
# Removes columns (hashtags) from other periods
base3_1 <- base3_1[,colSums(is.na(base3_1)) < nrow(base3_1)]

# Part 2: last 15 days
base3_2 <- base %>% 
  filter(DATE_TIME >= "2021-09-16" & DATE_TIME <= "2021-10-01")
# Removes columns (hashtags) from other periods
base3_2 <- base3_2[,colSums(is.na(base3_2)) < nrow(base3_2)]

# Saves splitted data -- each dataset size on github limit
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Dados\\Agrupados")

save(base3_1, file = "TrendingTopicsTwitterBrasil202109_1.RData")
save(base3_2, file = "TrendingTopicsTwitterBrasil202109_2.RData")
