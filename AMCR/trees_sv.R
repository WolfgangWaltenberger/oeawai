########################################################################
#                          Tree-based methods                          #
########################################################################

# Classification trees:

library(rpart)

# bank data:
# http://archive.ics.uci.edu/ml/datasets/Bank+Marketing

d <- read.csv2("bank.csv")
n <- nrow(d)
train_size <- 3000                     # has taken 3000 observations
set.seed(230)
train <- sample(n,train_size)
test <- c(1:n)[-train]

# 1a)
d_tree <- rpart(y ~.,data=d[train,], cp=0.005, xval=20)
d_tree


# Random forests

library(randomForest)

m_forest <- randomForest(y ~ ., data=d, subset=train,importance=TRUE)
plot(m_forest)
varImpPlot(m_forest)
