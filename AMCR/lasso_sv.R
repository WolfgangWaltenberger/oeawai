##########################################################################
#                          Lasso Regression                              #
##########################################################################

# Linear model:

library(ISLR)
data("Hitters")
d <- na.omit(Hitters)
names(d)
d$Salary <- log(d$Salary)
# Why take the log of Salary?

n <- nrow(d)

set.seed(123)
train <- sample(1:n,round(n/2))
test <- c(1:n)[-train]
