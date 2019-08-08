##########################################################################
#                                  GAMs                                  #
##########################################################################


# Regression setting:

library(splines)
library(mgcv)
library(ISLR)
data(Auto)

n <- nrow(Auto)
set.seed(123)
train <- sample(1:n,round(n*2/3))

res <- gam(mpg~cylinders+s(displacement)+s(horsepower)+s(weight)+
             s(acceleration)+s(year)+factor(origin),data=Auto,subset=train)
# Why no smooth function for cylinders and origin?
summary(res)
