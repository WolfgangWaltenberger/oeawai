#########################################################################
#                                  SVM                                  #
#########################################################################

# Nice tutorial, also for imbalanced groups:
# http://www.di.fc.ul.pt/~jpn/r/svm/svm.html

library(e1071)

# bank data:
# http://archive.ics.uci.edu/ml/datasets/Bank+Marketing
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

# misclassification rate:
1-sum(diag(TAB1))/sum(TAB1)