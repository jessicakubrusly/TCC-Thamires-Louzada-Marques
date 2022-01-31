#### Pacotes ####
library(dplyr)
library(rtweet)

# # access tokens, ids, secrets
api_key <- "INSERT_HERE"
api_secret_key <- "INSERT_HERE"

app_name <- "INSERT_HERE"

access_token <- "INSERT_HERE"
access_token_secret <- "INSERT_HERE"

# establishes the connection creating token
create_token(
  app = app_name,
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)

# gets existing token without needing browser authentication
get_token()

# gets trends worldwide
aux <- trends_available()

# gets brazil woeid (Where On Earth IDentifier)
woeid <- aux$woeid[which(aux$name == "Brazil")]

# gets #top50 brazil trending topics
trends <- get_trends(woeid=woeid)

# filters the hashtags from the trendings
trends <- trends %>% 
  filter(grepl("#", trend)) %>% 
  select(trend) %>% 
  pull()

# changes object to the query pattern
trends_query <- paste0(trends, collapse=" OR ")

# gets databse
tweets <- search_tweets(q=trends_query, 
                        n=18000, 
                        include_rts=FALSE, 
                        #`-filter` = "replies",
                        lang="pt")
# opcao retryonratelimit para mais de 18000

# select variables and change names
tweets <- tweets %>% 
  select(DATE_TIME = created_at, 
         USERNAME = screen_name, 
         TEXT = text, 
         TEXT_WIDTH = display_text_width, 
         IS_QUOTE = is_quote)

# creates logical column only for the presence/absence of the trending hashtags
# since it could have more hashtags out of our search
used_hashtags <- sapply(1:length(trends), FUN=function(x) grepl(trends[x], tweets$TEXT))
colnames(used_hashtags) <- trends

tweets <- cbind(tweets, used_hashtags)

# filename to save
filename <- paste0("TwitterData_", 
                   strftime(Sys.time(), format="%d%m%Y_%H"), 
                   "h.RData")

# exporting dataset
setwd("C:/Users/thami/OneDrive/Documentos/Faculdade/TCC/Dados")
save(tweets, file=filename)
