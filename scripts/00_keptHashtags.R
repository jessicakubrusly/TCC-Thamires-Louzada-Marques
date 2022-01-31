#### Packages ####
library(gdata)
library(openxlsx)

# Setting working directory
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC\\Agrupados")

# Environment objects from the moment when the hashtags were kept
objects <- list.files(getwd(), pattern="DadosEnv")

# Objects to save all hashtags and their labels
hashtags_info <- c()
is_progov_info <- c()

# Keeping the hashtags labeled datasets
for(i in objects){
  print(i)
  load(i)
  
  # Saving the information
  hashtags_info <- c(hashtags_info, as.character(pro_gov_info$hashtags))
  is_progov_info <- c(is_progov_info, pro_gov_info$is_progov)
  
  # Keeping only the needed objects
  keep(hashtags_info, is_progov_info, objects, sure=TRUE)
}
beepr::beep(sound=4)

# Data frame with the hashtags and their classification
hashtags <- data.frame(hashtag = hashtags_info, 
                       is_progov = is_progov_info)


#### Exporting ####
write.xlsx(hashtags, file="hashtags.xlsx")

