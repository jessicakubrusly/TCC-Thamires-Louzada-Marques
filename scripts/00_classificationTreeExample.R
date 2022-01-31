set.seed(1)

n = 1000
X1 = runif(n)
X2 = runif(n)
plot(X1,X2)
Y = NULL

for(i in 1:n){
  if(X2[i]<0.4 && X1[i] < 0.4){
    #classe 1 com prob 0.99
    Y[i] = sample(c(0,1),size = 1,prob = c(0.01,0.99))
  }
  else{
    if(X1[i]>0.4 && X2[i] < 0.4){
      #classe 0 com prob 0.99
      Y[i] = sample(c(0,1),size = 1,prob = c(0.99,0.01))
    } else {
       if(X2[i]>0.4 && X1[i] < 0.4){
         #classe 0 com prob 0.99
         Y[i] = sample(c(0,1),size = 1,prob = c(0.99,0.01))
         } else {
          #classe 1 com prob 0.99
          Y[i] = sample(c(0,1),size = 1,prob = c(0.01,0.99))
         }
    }
  }
}

dados=data.frame(X1,X2,Y)
dados$Y <- ifelse(dados$Y == 0, "0", "1")
points(dados$X1[Y==1],dados$X2[Y==1],col="steelblue",pch=19)
points(dados$X1[Y==0],dados$X2[Y==0],col="tan2",pch=19)

library(rpart)
library(rpart.plot)

ctrl <- rpart.control(minsplit = 50)
arvore <- rpart(Y~., data=dados, control=ctrl)
rpart.plot(arvore, box.palette = c("tan2", "steelblue"))





