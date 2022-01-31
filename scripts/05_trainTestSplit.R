# Loads package
library(caret)

# Loading data
setwd("~/Faculdade/TCC/Dados/Agrupados")
load("GroupedCleanData.RData")

# Train-test split
{
  set.seed(117054003)
  
  inTrain <- createDataPartition(y=data$IS_PROGOV, p=0.75, list=F)
  training <- data[inTrain,]
  testing <- data[-inTrain,]
}

# Saving data
save(training, file="TrainSample.RData")
save(testing, file="TestingSample.RData")
