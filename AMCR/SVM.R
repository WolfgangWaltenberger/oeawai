########################################################################
# SVM
########################################################################

library(e1071)

# nice tutorial, also for imbalanced groups:
# http://www.di.fc.ul.pt/~jpn/r/svm/svm.html

###################################################################################
# bank data:
#http://archive.ics.uci.edu/ml/datasets/Bank+Marketing
d <- read.csv2("bank.csv")

set.seed(123)
train <- sample(nrow(d), 3000)

(costs <- table(d$y[train]))
costs[1] <- 1
costs[2] <- 10
resSVM <- svm(y ~ ., data=d, subset=train,class.weights=costs)
predSVM <- predict(resSVM,newdata=d[-train,])
TAB1 <- table(d$y[-train],predSVM)
TAB1
1-sum(diag(TAB1))/sum(TAB1)

# tune:
resSVMt <- tune.svm(y ~ ., data=d[train,],gamma=2^(-3:-1),cost=2^(-1:3),kernel="radial",
class.weights=costs)
resSVMt
plot(resSVMt,d[train,])

resSVMtt <- svm(y ~ ., data=d[train,], gamma=2^-3,cost=2^1,kernel="radial",
  class.weights=costs)
predSVMtt <- predict(resSVMtt,newdata=d[-train,])
TAB1 <- table(predSVMtt,d$y[-train])
TAB1
# predSVM   no  yes
#     no  1212   76
#     yes  131  102
1-sum(diag(TAB1))/sum(TAB1)








