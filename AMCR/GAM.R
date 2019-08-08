################################################################################# 
# GAMs:
################################################################################# 

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
summary(res)

plot(res)

pred <- predict(res,Auto[-train,])
plot(Auto$mpg[-train],pred)
abline(c(0,1))
sqrt(mean((Auto$mpg[-train]-pred)^2))
#[1] 2.939358

res1 <- gam(sqrt(mpg)~s(horsepower)+s(weight)+s(horsepower)+
              s(acceleration)+s(year)+factor(origin),data=Auto,subset=train)
summary(res1)

plot(res1)

pred1 <- (predict(res1,Auto[-train,]))^2
plot(Auto$mpg[-train],pred1)
abline(c(0,1))
sqrt(mean((Auto$mpg[-train]-pred1)^2))
#[1] 2.892192



# Further tuning with shrinking:
# null space penalization with select=TRUE
res <- gam(mpg~cylinders+s(displacement,k=9)+s(horsepower,k=9)+s(weight,k=9)+
             s(acceleration,k=9)+s(year,k=9)+factor(origin),method="REML",select=TRUE,
             data=Auto,subset=train)
summary(res)
plot(res)
pred <- predict(res,Auto[-train,])
sqrt(mean((Auto$mpg[-train]-pred)^2))
#2.875356

# shrinkage smoothers "cs" and "ts"
res <- gam(mpg~cylinders+s(displacement,bs="ts")+s(horsepower,bs="ts")+s(weight,bs="ts")+
             s(acceleration,bs="ts")+s(year,bs="ts")+factor(origin),method="REML",
           select=TRUE,data=Auto,subset=train)
summary(res)
#plot(res)
pred <- predict(res,Auto[-train,])
sqrt(mean((Auto$mpg[-train]-pred)^2))
# 2.882016



