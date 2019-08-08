# Linear model:

library(ISLR)
data("Hitters")
d <- na.omit(Hitters)
names(d)
d$Salary <- log(d$Salary)

n <- nrow(d)

set.seed(124)
train <- sample(1:n,round(n/2))
test <- c(1:n)[-train]

# Least-squares regression:
reslm <- lm(Salary~.,data=d,subset=train)
summary(reslm)

predlm <- predict(reslm,newdata=d[test,])
plot(d$Salary[test],predlm,xlab="Measured y",ylab="Predicted y")
abline(c(0,1))

# MSE:
mean((d$Salary[test]-predlm)^2)



# Lasso regression with glmnet
library(glmnet)
res <- glmnet(data.matrix(d[train,-19]),d[train,19])
# plot results
plot(res)
res.cv <- cv.glmnet(data.matrix(d[train,-19]),d[train,19])
plot(res.cv)
# choose optimal coefs
coef(res.cv,s="lambda.1se")
# compute predicted y values on test set
ypred <- predict(res.cv, newx=data.matrix(d[test,-19]),s="lambda.1se")
# plot the measured y values against the predicted y values for the optimal model
plot(d[test,19], ypred, xlab = "Measured y", ylab = "Predicted y")
abline(c(0,1))

# MSE:
mean((d$Salary[test]-ypred)^2)

