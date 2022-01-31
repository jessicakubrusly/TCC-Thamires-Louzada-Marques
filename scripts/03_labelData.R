# Read the data
setwd("~/TCC/Dados/Agrupados")
load("TrendingTopicsTwitterBrasil202109_2.RData")
data <- base3_2
rm(base3_2)

# Auxiliar objects to save the hashtags to be kept and their bias
cols <- colnames(data)
hashtags_gov <- c()
is_progov <- c()

# Function for the user to flag the hashtags (input-values function)
select_hashtags <- function(i, data){
  resp <- readline(prompt=paste0("Keep hashtag ", i, "      ", cols[i], "? (y/n) \n"))

  if(resp != "y" & resp != "n"){
    resp <- readline(prompt="Not a valid answer. Try again: ")
  }

  if(resp == "y"){
    hashtags_gov <<- c(hashtags_gov, i)

    pro <- readline(prompt=paste0("Is pro-gov      ", cols[i], "? (y/n)\n"))

    if(pro != "y" & pro != "n"){
      pro <- readline(prompt="Not a valid answer. Try again: ")
    }

    if(pro == "y"){
      is_progov <<- c(is_progov, TRUE)
    }else if(pro == "n"){
      is_progov <<- c(is_progov, FALSE)
    }
  }
}

# Apply the function to distinguish the hashtags orientation across all columns
hashtags_to_remove <- sapply(6:ncol(data), select_hashtags, data=data)

# Data frame with all selected hashtags and their orientation
pro_gov_info <- data.frame(hashtags=cols[hashtags_gov], is_progov)

#UniaoPeloBrasil
#BoicoteAGlobo
#3JPovoNasRuas
#EsquerdaCriminosa
#EuApoioVotoAuditavel
#TuiteUmFilmeComRachadinha
#LulaLadrão
#CagueiPraCPI
#QueremosVotoImpresso
#LiraAssinaImpeachment (mantida)
#FechaACPI
#OremPeloPresidente (mantida)
#QuemMandouMatarBolsonaro (mantida)
#VetaBolsonaro
#Dia1VaiSerGigante (voto impresso)
#VotoImpressoAuditavelJa
#Dia01VaiSerGIGANTE
#LulaOpovoTeOdeia
#DitaduraNuncaMais
#EsquerdaTerrorista
#LulaValeOuro
#7DeSetembroVaiSerGIGANTE
#ForaCorno

# Select from data only the favor/against government columns
data_clean <- data[hashtags_gov]

# Replace NA values by FALSE
data_clean[is.na(data_clean)] <- FALSE

# Remove rows with all values NA
data_clean <- data_clean[rowSums(!data_clean) != ncol(data_clean), ]



# # Tagging and creating the IS_PROGOV column
# progov_column <- c()
# 
# # Function to input the IS_PROGOV info for each observation
# create_progov_column <- function(i, data){
#   if(pro_gov_info$is_progov[i]){
#     values <- ifelse(data_clean[,i], TRUE, NA)
#     values <- values[which(!is.na(values))]
#     progov_column <<- c(progov_column, values)
#   }else{
#     values <- ifelse(data_clean[,i], FALSE, NA)
#     values <- values[which(!is.na(values))]
#     progov_column <<- c(progov_column, values)
#   }
# 
#   # If column is labeled as TRUE for pro_gov_info:
#   # We check the TRUE occurrences and the value will be TRUE
#   # If column is labeled as FALSE for pro_gov_info:
#   # We check the TRUE occurrences and the value will be FALSE
# }
# 
# # Apply the flagging function for each observation in the whole database
# sapply(1:ncol(data_clean), create_progov_column, data=data)


# TENTAR ENTENDER:
# > unique(data_clean$`#24JForaBolsonaro`)
# [1] FALSE
# > unique(data$`#24JForaBolsonaro`)
# [1] NA

aux <- c()

# Replace NA by false
# Remove rows with all columns FALSE

for(i in 1:nrow(data_clean)){
  print(i)
  for(j in 1:length(hashtags_gov)){
    if(data_clean[i,j]){
      if(pro_gov_info$is_progov[j]){
        aux <- c(aux, TRUE)
      }else{
        aux <- c(aux, FALSE)
      }
      # To say that a hashtag in j was found
      # And do not want to keep look for another hashtag
      # (Treating cases with more than 1 hashtag TRUE)
      break
    }
  }
}

# Adding the position column
data_clean$IS_PROGOV <- aux

# Merging the data back
data_clean6 <- cbind(data[rownames(data_clean),1:5], data_clean)

# Removing hashtags columns
data_clean6 <- data_clean6[,c(1:5, ncol(data_clean6))]

# Saves the labeled treated dataset
save(data_clean6, file="06dataclean.RData")

# Saves the environment
save.image(file="06DadosEnv.RData")

# Code to check inconsistency in pro_gov_info
# Gets rows where TRUE happens for more than 1 hashtag
# for(i in 1:nrow(data_clean)){
#   achei1 <- FALSE
#   achei2 <- FALSE
#   for(j in 1:9){
#     if(data_clean[i,j]){
#       if(!achei1){
#         achei1 <- TRUE
#       }else{
#         achei2 <- TRUE
#       }
#     }
#   }
#   if(achei1 & achei2){
#     print(i)
#   }
# }
# Those occurrences had the same bias, that is: 
# When #ForaBolsonaro is TRUE, the other TRUE hashtag is also against the 
# government. Ex.: #LiraAssinaImpeachment. Therefore, the stop criteria is valid.
