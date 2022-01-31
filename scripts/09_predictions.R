#### Packages ####
library(caret)
library(pROC)

# Loading data
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC")
load("TermDocumentMatrix.RData")
load("PreProcessingObjects.RData")
load("TestingSample.RData")

# Applying pre-processing on test sample (does not create any new pre-processing, only the one 
# obtained from the training sample)
test_matrix_df <- preProcess(testing)

# Load models
load("Models.RData")

# Names the columns of teste data according to train data 
# (the columns order is already the same)
colnames(test_matrix_df) <- cols

#### Cross-Validation ####
#### > Classification Trees ####
#If the rpart object is a classification tree, then the default is to return 
#prob predictions, a matrix whose columns are the probability of the first, second, etc. class.
# Prediction
pred_cart <- predict(model_cart, test_matrix_df, type="class")
pred_cart_balanced <- predict(model_cart_balanced, test_matrix_df, type="class")

# Confusion matrix
cm_cart <- confusionMatrix(pred_cart, test_matrix_df$IS_PROGOV)
cm_cart_balanced <- confusionMatrix(pred_cart_balanced, test_matrix_df$IS_PROGOV)





#### > Random Forest ####
# Prediction
pred_rf <- predict(model_rf, test_matrix_df)
pred_rf_balanced <- predict(model_rf_balanced, test_matrix_df)

# Confusion matrix
cm_rf <- confusionMatrix(pred_rf, test_matrix_df$IS_PROGOV)
cm_rf_balanced <- confusionMatrix(pred_rf_balanced, test_matrix_df$IS_PROGOV)





#### > GBM ####
# Prediction
pred_gbm <- predict(model_gbm, test_matrix_df, n.trees=100, type="response")
pred_gbm_balanced <- predict(model_gbm_balanced, test_matrix_df, n.trees=100, type="response")

# ROC curve to get the classification threshold
roc_gbm <- roc(test_matrix_df$IS_PROGOV, pred_gbm)
gbm_threshold <- coords(roc_gbm, "best", ret = "threshold")

roc_gbm_balanced <- roc(test_matrix_df$IS_PROGOV, pred_gbm_balanced)
gbm_balanced_threshold <- coords(roc_gbm_balanced, "best", ret = "threshold")

# Classifying
pred_gbm <- ifelse(pred_gbm < gbm_threshold, 0, 1)
pred_gbm_balanced <- ifelse(pred_gbm_balanced < gbm_balanced_threshold, 0, 1)

# Confusion matrix
cm_gbm <- confusionMatrix(as.factor(pred_gbm), test_matrix_df$IS_PROGOV)
cm_gbm_balanced <- confusionMatrix(as.factor(pred_gbm_balanced), test_matrix_df$IS_PROGOV)





#### > XGBOOST ####
# Amostra diferenciada para o xgboost
# Transformamos a base em uma matriz
# Separamos a variável-resposta das demais
label <- as.matrix(test_matrix_df[160])
testing_xgboost <- as.matrix(test_matrix_df[-160])

# Prediction
pred_xgboost <- predict(model_xgboost, testing_xgboost)
pred_xgboost_balanced <- predict(model_xgboost_balanced, testing_xgboost)

# ROC curve to get the classification threshold
roc_xgboost <- roc(test_matrix_df$IS_PROGOV, pred_xgboost)
xgboost_threshold <- coords(roc_xgboost, "best", ret = "threshold")

roc_xgboost_balanced <- roc(test_matrix_df$IS_PROGOV, pred_xgboost_balanced)
xgboost_balanced_threshold <- coords(roc_xgboost_balanced, "best", ret = "threshold")

# Classifying
pred_xgboost <- ifelse(pred_xgboost < xgboost_threshold, 0, 1)
pred_xgboost_balanced <- ifelse(pred_xgboost_balanced < xgboost_balanced_threshold, 0, 1)

# Confusion matrix
cm_xgboost <- confusionMatrix(as.factor(pred_xgboost), as.factor(label))
cm_xgboost_balanced <- confusionMatrix(as.factor(pred_xgboost_balanced), as.factor(label))



#### Exporting ####
save(file="ValidationMetrics.RData", list = ls()[!grepl("cm_|t_", ls())])

