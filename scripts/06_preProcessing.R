#### PACKAGES ####
#library(stringi)
library(dplyr)
#library(tidytext)
#library(tidyr)
library(stopwords)
library(tm)
#library(textstem)
library(hashmap)
#library(text2vec)
#library(caret)

# Setting location for encoding purposes
Sys.setlocale("LC_ALL", "Portuguese_Brazil")

# Loading data
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC")
load("TrainingSample.RData")
data <- training

# Maybe creating an identifier column could help.
data$ID <- 1:nrow(data)

# Replacing accents
# Cannot be applied any longer because it was making, for example:
# país != pais ... pais -> pai (during lemmatization)
# data$TEXT <- stri_trans_general(data$TEXT, "Latin-ASCII")



#### CLEANING AND STANDARDIZING ####
# Removing emojis without removing accents
data$TEXT <- sapply(data$TEXT, function(x){intToUtf8(utf8ToInt(x)[-which(utf8ToInt(x)>100000)])})

# Creating the corpus object
# corpus <- VCorpus(VectorSource(data$TEXT))
corpus <- Corpus(VectorSource(data$TEXT))

# Check text before treatment
inspect(corpus[[1]])

# Tips for excluding characters
# cleanPosts <- function(text) {
#   clean_texts <- text %>%
#     gsub("<.*>", "", .) %>% # remove emojis
#     gsub("&amp;", "", .) %>% # remove &
#     gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", .) %>% # remove retweet entities
#     gsub("@\\w+", "", .) %>% # remove at people
#     hashgrep %>%
#     gsub("[[:punct:]]", "", .) %>% # remove punctuation
#     gsub("[[:digit:]]", "", .) %>% # remove digits
#     gsub("http\\w+", "", .) %>% # remove html links
#     iconv(from = "latin1", to = "ASCII", sub="") %>% # remove emoji and bizarre signs
#     gsub("[ \t]{2,}", " ", .) %>% # remove unnecessary spaces
#     gsub("^\\s+|\\s+$", "", .) %>% # remove unnecessary spaces
#     tolower
#   return(clean_texts)
# }

# Content transformer: function to make undesired characters into blank space
toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x))})

# Lower case
corpus <- tm_map(corpus, content_transformer(tolower))

# Removes &
corpus <- tm_map(corpus, toSpace, "&amp;")

# Removes retweet entities
corpus <- tm_map(corpus, toSpace, "(RT|via)((?:\\b\\W*@\\w+)+)")

# Removes html links
corpus <- tm_map(corpus, toSpace, "(s?)(f|ht)tp(s?)://\\S+\\b")

# Removes hashtags
corpus <- tm_map(corpus, toSpace, "\\#\\w*")

# Removes @
corpus <- tm_map(corpus, toSpace, "\\@\\w*")

# Function to remove emojis and bizarre signs
# It also removes accents => problem on lemmatization
# Solved on the primary dataset -- line 25
# rm_emojis <- content_transformer(function(x){iconv(gsub("\\n", " ", x), to="ASCII", sub="")})
# Removes emojis
# corpus <- tm_map(corpus, rm_emojis)

# Removes punctuation
corpus <- tm_map(corpus, removePunctuation)

# Removes numbers
corpus <- tm_map(corpus, removeNumbers)



#### STOPWORDS REMOVAL ####
# Stopwords array
stoplist <- stopwords("portuguese")
# Adding extra stopwords
stoplist <- c(stoplist, c("é", "pra", "tá", "neste", "nesta", "nestes", "nestas", 
                          "nesse", "nessa", "todo", "toda", "todos", "todas", 
                          "vc", "vcs", "aí", "desse", "dessa", "desses", "dessas", 
                          "deste", "desta", "destes", "destas", "lá", "cá", "aqui", 
                          "onde"))
# Removing accents from stoplist
# stoplist <- stri_trans_general(stoplist, "Latin-ASCII")
# Removes stopwords
corpus <- tm_map(corpus, removeWords, stoplist)

# Removes white space
corpus <- tm_map(corpus, stripWhitespace)

# Check text after treatment
inspect(corpus[[1]])
corpus[[1]][[1]]




#### LEMMATIZATION ####
# Dictionary of lemmas and derivated words in portuguese
lemma_dic <- read.delim(file="https://raw.githubusercontent.com/michmech/lemmatization-lists/master/lemmatization-pt.txt", 
                        header=FALSE, 
                        stringsAsFactors=FALSE, 
                        encoding="UTF-8")
names(lemma_dic) <- c("lemma", "token")

# Removing accents
#lemma_dic$lemma <- stri_trans_general(lemma_dic$lemma, "Latin-ASCII")
#lemma_dic$token <- stri_trans_general(lemma_dic$token, "Latin-ASCII")
# Removing repeated rows after accents removal
#lemma_dic <- unique(lemma_dic)

# Reordering columns
# lemma_dic <- lemma_dic[,2:1]

# Hashmap object
lemma_hm <- hashmap(lemma_dic$token, lemma_dic$lemma)

# Function to lemmatize words
lemma_tokenizer = function(x, lemma_hashmap, 
                           tokenizer = text2vec::word_tokenizer) {
  tokens_list = tokenizer(x)
  for(i in seq_along(tokens_list)) {
    tokens = tokens_list[[i]]
    replacements = lemma_hashmap[[tokens]]
    ind = !is.na(replacements)
    tokens_list[[i]][ind] = replacements[ind]
  }
  
  # paste together, return a vector
  sapply(tokens_list, (function(i){paste(i, collapse = " ")}))
}

# Testing function
#lemma_tokenizer("cancelado cancelada cancela tenta hum", lemma_hm)

# Lemmatizing
corpus <- tm_map(corpus, (function(x){lemma_tokenizer(x, lemma_hashmap=lemma_hm)}))

# Solving encoding issue
# test <- tm_map(corpus, iconv, to="UTF-8")

# The following code solves the encoding issue but creates the doc-term matrix error
# of multibyte strings
# corpus <- tm_map(corpus, content_transformer(function(x) iconv(x, 
#                                                                from="UTF-8", 
#                                                                to="latin1")))

# The following treatment is not the correct one (the correct is the commented above)
# But that was needed to solve the invalid multibyte string error when creating 
# the doc-term matrix
corpus <- tm_map(corpus, content_transformer(function(x) iconv(x, 
                                                               to="UTF-8")))

# Check encoding
corpus[[187]][[1]]




#### TERM-DOCUMENT MATRIX ####
# Creates the term-document matrix
TM_matrix <- DocumentTermMatrix(corpus, control=list(minDocFreq=2, 
                                                     minWordLength=2))
#12385 terms

TM_matrix <- removeSparseTerms(TM_matrix, 0.999)
#168 terms

dt_matrix <- as.data.frame(as.matrix(TM_matrix))

# Adding the flag variable 
dt_matrix$IS_PROGOV <- data$IS_PROGOV
dt_matrix$IS_PROGOV <- ifelse(data$IS_PROGOV, 1, 0)
# Gotta convert the variable to FACTOR for classification
dt_matrix$IS_PROGOV <- as.factor(dt_matrix$IS_PROGOV)





#### Correlation Analysis ####
# Correlation matrix
cor <- cor(dt_matrix[,-160])

# Correlation summary
summary(cor[upper.tri(cor)])

# Checking for variables with high correlation (> 75%)
findCorrelation(cor, cutoff = .75, name = T)
# There are no highly correlated variables to be removed from the dataset.




#### Linear Combination Analysis ####
findLinearCombos(dt_matrix[,-160])
# There are no variables which are linear combinations of each other to be removed. 



#### BALANCING DATA ####
# The dataset to be balanced
dt_matrix2 <- dt_matrix

# Data is not balanced => class "0" has higher frequency
table(dt_matrix2$IS_PROGOV)

# Splitting data in 2 data frames to balance and then join
dt_matrix2_1 <- filter(dt_matrix2, IS_PROGOV == 1)
head(dt_matrix2_1)
dim(dt_matrix2_1)

dt_matrix2_0 <- filter(dt_matrix2, IS_PROGOV == 0)
head(dt_matrix2_0)
dim(dt_matrix2_0)

# dt_matrix2_0 is bigger => some rows of it will be selected to create the balanced one
# k = the length dt_matrix2_0 will be after being randomly reduced (undersampling)
k <- nrow(dt_matrix2_1) 

# Randomly undersampling the class "0" dataset
{
  set.seed(117054003)
  dt_matrix2_0 <- dt_matrix2_0[sample(nrow(dt_matrix2_0), k), ]
}
dim(dt_matrix2_0)

# Joining the dataset splitted by the 2 classes -- after applying the 
# undersampling technique to the most frequent class
dt_matrix_balanced <- rbind(dt_matrix2_1, dt_matrix2_0)
dim(dt_matrix_balanced)
table(dt_matrix_balanced$IS_PROGOV)




#### preProcessing Function ####
# Based on the fact that the whole preprocessing steps need to be applied to the 
# test sample before validation, the preProcess function is created for this purpose.
preProcess <- function(data){
  # Loading required packaeges
  if(!require(dplyr)) install.packages("dplyr")
  if(!require(stopwords)) install.packages("stopwords")
  if(!require(tm)) install.packages("tm")
  if(!require(hashmap)) print("The archive hashmap_0.2.2.tar.gz can be downloaded on 'https://cran.r-project.org/src/contrib/Archive/hashmap/' and installed manually.")
  
  #### CLEANING AND STANDARDIZING ####
  # Removing emojis without removing accents
  data$TEXT <- sapply(data$TEXT, function(x){intToUtf8(utf8ToInt(x)[-which(utf8ToInt(x)>100000)])})
  
  # Creating the corpus object
  # corpus <- VCorpus(VectorSource(data$TEXT))
  corpus <- Corpus(VectorSource(data$TEXT))
  
  # Content transformer: function to make undesired characters into blank space
  toSpace <- content_transformer(function(x, pattern) {return (gsub(pattern, "", x))})
  
  # Lower case
  corpus <- tm_map(corpus, content_transformer(tolower))
  
  # Removes &
  corpus <- tm_map(corpus, toSpace, "&amp;")
  
  # Removes retweet entities
  corpus <- tm_map(corpus, toSpace, "(RT|via)((?:\\b\\W*@\\w+)+)")
  
  # Removes html links
  corpus <- tm_map(corpus, toSpace, "(s?)(f|ht)tp(s?)://\\S+\\b")
  
  # Removes hashtags
  corpus <- tm_map(corpus, toSpace, "\\#\\w*")
  
  # Removes @
  corpus <- tm_map(corpus, toSpace, "\\@\\w*")
  
  # Removes punctuation
  corpus <- tm_map(corpus, removePunctuation)
  
  # Removes numbers
  corpus <- tm_map(corpus, removeNumbers)
  
  
  
  #### STOPWORDS REMOVAL ####
  # Stopwords array
  stoplist <- stopwords("portuguese")
  # Adding extra stopwords
  stoplist <- c(stoplist, c("é", "pra", "tá", "neste", "nesta", "nestes", "nestas", 
                            "nesse", "nessa", "todo", "toda", "todos", "todas", 
                            "vc", "vcs", "aí", "desse", "dessa", "desses", "dessas", 
                            "deste", "desta", "destes", "destas", "lá", "cá", "aqui", 
                            "onde"))
  # Removing accents from stoplist
  # stoplist <- stri_trans_general(stoplist, "Latin-ASCII")
  # Removes stopwords
  corpus <- tm_map(corpus, removeWords, stoplist)
  
  # Removes white space
  corpus <- tm_map(corpus, stripWhitespace)
  
  
  
  #### LEMMATIZATION ####
  # Hashmap object
  lemma_hm <- hashmap(lemma_dic$token, lemma_dic$lemma)
  
  # Lemmatizing
  corpus <- tm_map(corpus, (function(x){lemma_tokenizer(x, lemma_hashmap=lemma_hm)}))
  
  corpus <- tm_map(corpus, content_transformer(function(x) iconv(x, 
                                                                 to="UTF-8")))
  
  
  
  
  #### TERM-DOCUMENT MATRIX ####
  # Creates the term-document matrix
  TM_matrix <- DocumentTermMatrix(corpus)
  
  dt_tm_matrix <- as.data.frame(as.matrix(TM_matrix))
  
  # Adding the flag variable 
  dt_tm_matrix$IS_PROGOV <- data$IS_PROGOV
  dt_tm_matrix$IS_PROGOV <- ifelse(data$IS_PROGOV, 1, 0)
  # Gotta convert the variable to FACTOR for classification
  dt_tm_matrix$IS_PROGOV <- as.factor(dt_tm_matrix$IS_PROGOV)
  
  # All the variables in the testing dataset are in the train dataset
  all(colnames(dt_matrix) %in% colnames(dt_tm_matrix))
  
  # Keeps only the variables which are in the TRAIN term-document matrix
  dt_tm_matrix <- dt_tm_matrix %>% 
    select(colnames(dt_matrix))
  
  
  # Returns the preProcessed term-document dataset
  return(dt_tm_matrix)
}




#### EXPORTING ####
# Saves the term-document matrix in matrix and data frame formats
save(TM_matrix, dt_matrix, dt_matrix_balanced, file="TermDocumentMatrix.RData")

# Saves data necessary for preprocessing
save(dt_matrix, lemma_dic, lemma_tokenizer, preProcess, file="PreProcessingObjects.RData")

