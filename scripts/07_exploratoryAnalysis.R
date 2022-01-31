#### PACKAGES ####
library(wordcloud2)
library(dplyr)
library(ggplot2)

# Loading data
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC")
load("TermDocumentMatrix.RData")

# Correcting data encoding problems
which(Encoding(colnames(dt_matrix)) == "UTF-8")
colnames(dt_matrix)[38] <- "país"
colnames(dt_matrix)[56] <- "manifestação"
colnames(dt_matrix)[72] <- "ninguém"
colnames(dt_matrix)[77] <- "corrupção"
colnames(dt_matrix)[78] <- "não"
colnames(dt_matrix)[84] <- "atenção"
colnames(dt_matrix)[90] <- "ladrão"
colnames(dt_matrix)[111] <- "amanhã"
colnames(dt_matrix)[115] <- "abençoar"
colnames(dt_matrix)[118] <- "capitão"
colnames(dt_matrix)[125] <- "amém"
colnames(dt_matrix)[126] <- "força"
colnames(dt_matrix)[131] <- "vídeo"
colnames(dt_matrix)[140] <- "notícia"
colnames(dt_matrix)[148] <- "crédito"
colnames(dt_matrix)[151] <- "forçar"
colnames(dt_matrix)[159] <- "oração"

# Updating data with the column names edited
cols <- colnames(dt_matrix)
save(dt_matrix, dt_matrix_balanced, TM_matrix, cols, file="TermDocumentMatrix.RData")

#### Classes Barplot ####
# Favor vs against bar plot
# Data
barplot_data <- dt_matrix %>%
  group_by(IS_PROGOV) %>%
  count()
barplot_data$IS_PROGOV <- ifelse(barplot_data$IS_PROGOV == 1, "Favorável", "Contrário")
barplot_data$percent <- barplot_data$n/sum(barplot_data$n)

# Plot
bp <- ggplot(barplot_data, aes(x=IS_PROGOV, y=percent, label=scales::percent(percent))) + 
  geom_bar(stat="identity", width=0.3, fill="dodgerblue4") + 
  labs(x = "Posicionamento", 
       y = "Proporção") + 
  geom_text(position = position_dodge(width = .9),    # move to center of bars
            vjust = -0.5,    # nudge above top of bar
            size = 4, 
            color = "gray30") + 
  theme_minimal() + 
  theme(text=element_text(family="serif", face="bold", size=22, color="gray30")) + 
  scale_y_continuous(labels = scales::percent)

# Saving barplot
ggsave("barplot_pos.png", plot=bp, height=10, width=10)



#### Wordcloud ####
# Splitting favor vs against data
dt_pro <- dt_matrix %>%
  filter(IS_PROGOV == 1)

dt_against <- dt_matrix %>%
  filter(IS_PROGOV == 0)


# Takes too long to run (>7hours) -- gave up
# library(performanceEstimation)
# t0 <- Sys.time()
# # Time difference of 7.26954 hours
# dt_matrix2 <- smote(IS_PROGOV ~ .,
#                     data = dt_matrix,
#                     perc.over = 1)
# t1 <- Sys.time() - t0
# print(t1)
# beepr::beep(sound=4)
#save(dt_matrix2, file="dt_matrix_balanceado_SMOTE.RData")

# Worcloud - pro gov
pro_words_freq <- sort(colSums(dt_pro[-160]), decreasing=TRUE)
pro_words <- data.frame(word=names(pro_words_freq), freq=pro_words_freq)
wordcloud2(data=pro_words, size=1.6, color="random-dark")

# Worcloud - against gov
against_words_freq <- sort(colSums(dt_against[-160]), decreasing=TRUE)
against_words <- data.frame(word=names(against_words_freq), freq=against_words_freq)
wordcloud2(data=against_words, size=1.6, color="random-dark")




#### Sentiment Analysis ####
senses_dic <- read.delim(file="https://raw.githubusercontent.com/Pedro-Thales/SentiWordNet-PT-BR/master/SentiWord%20Pt-BR%20v1.0b.txt", 
                         header=TRUE, 
                         stringsAsFactors=FALSE, 
                         encoding="UTF-8", 
                         skip=14)
# Removing first column
senses_dic[1] <- NULL

# Removing repeated rows
senses_dic <- senses_dic %>%
  group_by(Termo) %>%
  #arrange(Termo) %>%
  slice(1)

# Sentiments - pro
# Extracts top 50 most frequents
pro_words <- pro_words %>% 
  arrange(-freq) %>% 
  top_n(50)

# Joins
pro_senses <- left_join(pro_words, senses_dic, by=c("word"="Termo")) %>%
  na.omit() %>%
  arrange(-freq)

# Sentiments - against
# Extracts top 50 most frequents
against_words <- against_words %>% 
  arrange(-freq) %>% 
  top_n(50)

# Joins
against_senses <- left_join(against_words, senses_dic, by=c("word"="Termo")) %>%
  na.omit() %>%
  arrange(-freq) 

# WAS NOT APPLIED BECAUSE KEPT GIVING THE SAME RESULT: 
# New column to give a position to each word, following the criteria:
# If the positiviness = negativeness, then neutral
# Else if positiviness > negativeness, then positive
# Else if positiviness < negativeness, then negative
# pro_senses <- pro_senses %>% 
#   mutate(
#     Sentiment = case_when(
#       PosScore == NegScore ~ "Neutro", 
#       PosScore > NegScore ~ "Positivo", 
#       PosScore < NegScore ~ "Negativo"
#     )
#   )
# 
# against_senses <- against_senses %>% 
#   mutate(
#     Sentiment = case_when(
#       PosScore == NegScore ~ "Neutro", 
#       PosScore > NegScore ~ "Positivo", 
#       PosScore < NegScore ~ "Negativo"
#     )
#   )

# Creating data with sentiments totals for each group
sentiment_data <- data.frame(Posicionamento=c(rep("Favorável", 2), rep("Contrário", 2)), 
                             Sentimento=rep(c("Positivo", "Negativo"), 2), 
                             Total=c(sum(pro_senses$PosScore), 
                                     sum(pro_senses$NegScore), 
                                     sum(against_senses$PosScore), 
                                     sum(against_senses$NegScore)))

# Plot
bp_sent <- ggplot(sentiment_data, aes(x=Posicionamento, y=Total, fill=Sentimento)) + 
  geom_col(width=0.3) + 
  labs(y = "Soma dos Scores de Sentimentos", 
       x = "Posicionamento") + 
  coord_flip() + 
  scale_fill_manual(values=c("lightgoldenrod", "lightblue")) + 
  scale_y_continuous(breaks=seq(0,8,1), limits=c(0,8)) + 
  theme_minimal() + 
  theme(text=element_text(family="serif", face="bold", size=23, color="gray30"))

# Saving barplot
ggsave("barplot_sentiment.png", plot=bp_sent, width=12, height=7)
  