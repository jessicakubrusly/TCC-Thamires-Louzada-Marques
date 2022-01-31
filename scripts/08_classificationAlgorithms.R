#### Packages ####
#library(caret)
library(gbm)
library(xgboost)
library(rpart)
library(randomForest)



# Loading data
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC")
load("TermDocumentMatrix.RData")


# Column names error treatment
colnames(dt_matrix) <- cols
colnames(dt_matrix_balanced) <- cols

# Transformamos a base em uma matriz
# Separamos a variavel-resposta das demais para o XGBOOST
label <- as.matrix(dt_matrix[160])
training_xgboost <- as.matrix(dt_matrix[-160])

label_balanced <- as.matrix(dt_matrix_balanced[160])
training_xgboost_balanced <- as.matrix(dt_matrix_balanced[-160])



#### > Decision Tree ####
ctrl <- rpart.control(cp=0.0001)

{
  t_cart <- Sys.time()
  set.seed(117054003)
  model_cart <- rpart(IS_PROGOV ~ ., 
                      data=dt_matrix, 
                      control=ctrl)
  t_cart <- Sys.time() - t_cart
}
#rpart.plot::rpart.plot(model_cart)
beepr::beep(sound=4)


{
  t_cart_balanced <- Sys.time()
  set.seed(117054003)
  model_cart_balanced <- rpart(IS_PROGOV ~ ., 
                               data=dt_matrix_balanced, 
                               control=ctrl)
  t_cart_balanced <- Sys.time() - t_cart_balanced
}
beepr::beep(sound=4)


#### > GBM ####
# GBM does not accept the factor as entry. It returns NaNs. Transformed to 
# character. 
{
  t_gbm <- Sys.time()
  set.seed(117054003)
  model_gbm <- gbm(as.character(IS_PROGOV)~., 
                   data=dt_matrix, 
                   distribution="bernoulli", 
                   n.trees=100, 
                   verbose=FALSE)
  t_gbm <- Sys.time() - t_gbm
}
beepr::beep(sound=4)

{
  t_gbm_balanced <- Sys.time()
  set.seed(117054003)
  model_gbm_balanced <- gbm(as.character(IS_PROGOV)~., 
                            data=dt_matrix_balanced, 
                            distribution="bernoulli", 
                            n.trees=100, 
                            verbose=FALSE)
  t_gbm_balanced <- Sys.time() - t_gbm_balanced
}
beepr::beep(sound=4)




#### > XGBOOST ####
{
  t_xgboost <- Sys.time()
  set.seed(117054003)
  model_xgboost <- xgboost(data = training_xgboost, 
                           label = label,
                           gamma = 0, 
                           eta = 0.3, 
                           objective = "binary:logistic", 
                           verbose = FALSE, 
                           nrounds=100)
  t_xgboost <- Sys.time() - t_xgboost
}
beepr::beep(sound=4)

{
  t_xgboost_balanced <- Sys.time()
  set.seed(117054003)
  model_xgboost_balanced <- xgboost(data = training_xgboost_balanced, 
                                    label = label_balanced,
                                    gamma = 0, 
                                    eta = 0.3, 
                                    objective = "binary:logistic", 
                                    verbose = FALSE, 
                                    nrounds=100)
  t_xgboost_balanced <- Sys.time() - t_xgboost_balanced
}
beepr::beep(sound=4)



#### > Random Forest ####
{
  t_rf <- Sys.time()
  set.seed(117054003)
  model_rf <- randomForest(IS_PROGOV ~ ., 
                           data = dt_matrix, 
                           ntree = 100)
  t_rf <- Sys.time() - t_rf
}
beepr::beep(sound=4)

{
  t_rf_balanced <- Sys.time()
  set.seed(117054003)
  model_rf_balanced <- randomForest(IS_PROGOV ~ ., 
                                    data = dt_matrix_balanced, 
                                    ntree = 100)
  t_rf_balanced <- Sys.time() - t_rf_balanced
}
beepr::beep(sound=4)



#### Exports ####
# Removing exceeding objects
rm(ctrl, dt_matrix, dt_matrix_balanced, label, label_balanced, TM_matrix, 
   training_xgboost, training_xgboost_balanced, cols)

# Saving models
save.image(file="Models.RData")



