# Classification trees:

library(rpart)

d <- read.csv2("bank.csv")
n <- nrow(d)
train_size <- 3000                     # has taken 3000 observations
set.seed(230)
train <- sample(n,train_size)
test <- c(1:n)[-train]


# 1a)
d_tree <- rpart(y ~.,data=d[train,], cp=0.005, xval=20)
d_tree
# 1b)

plot(d_tree)
text(d_tree)
# seems to be an overfit since there are to many knots and further investigations are needed
# duration seems to be a important seperation variable

# 1c)

b1_pred <- predict(d_tree,d[test,],type="class")
b1_tab <- table(d[test,]$y,b1_pred)
b1_tab
mcr <- 1 - sum(diag(b1_tab)) / sum(b1_tab)
mcr
# missclassification rate of ~11.8 %

# 1d)
printcp(d_tree)
# root node error of 0.10567 which is around 11 like our missclassification rate
# cp        ... the complexity parameter in every step
# nsplit    ... number of splits in the recent tree
# xerror    ... error according to the lost of information by classifiying
# xstd      ... standard error of the xerror


plotcp(d_tree)
# minima are marked with red bullets and the optimal cp is at the yellow bullet, which is the first within the area of
# the minima + 1 standard error
# so the optimal is at 0.0283912 according to the plot and printcp

# 1e)
d_tree2 <- prune(d_tree,cp=0.0283912)
plot(d_tree2)
text(d_tree2)
# this tree is much less complex to the initial tree and only duration, poutcome and martial are the splitting variables

# 1f)
b2_pred <- predict(d_tree2,d[test,],type="class")
b2_tab <- table(d[test,]$y,b2_pred)
b2_tab
mcr2 <- 1 - sum(diag(b2_tab)) / sum(b2_tab)
mcr2
# missclassification rate of ~11.7 % (first ~11.8%), therefore a little improvement of the missclass. rate could be observed
# and also the intepretation of this tree is much easier than the initial tree


#####################################################################################
# Random Forests


## fit random forest on training data
m_forest <- randomForest(y ~ ., data=d, subset=train,importance=TRUE)
plot(m_forest)
varImpPlot(m_forest)
m_pred <- predict(m_forest, d[test,], type="class")
m_table <- table(d[test, "y"], m_pred)
m_table
#     m_pred
#        no  yes
#  no  1309   34
#  yes  114   64

(m_mcr <- 1 - sum(diag(m_table))/sum(m_table))

# but: "yes"-clients wrong:
114/(114+64)
#[1] 0.6404494

# undersampling:
table(d$y)
#   no   yes 
# 4000   521  

# sample from "no":
sel <- c(1:nrow(d))
selno <- sample(sel[d$y=="no"],sum(d$y=="yes"))
dn <- rbind(d[d$y=="yes",],d[selno,])
table(dn$y)
#  no  yes 
# 521  521

set.seed(123)
samp <- sample(nrow(dn),round(nrow(dn)*2/3))
m_forest <- randomForest(y ~ ., data=dn, subset=samp)
m_pred <- predict(m_forest, dn[-samp,], type="class")
m_table <- table(dn[-samp, "y"], m_pred)
m_table
#     m_pred
#     no  yes
# no  138  27
# yes  26 156
m_mcr <- 1 - sum(diag(m_table))/sum(m_table)
m_mcr
#[1] 0.1527378

# now: "yes"-clients wrong:
26/(26+156)
#[1] 0.1428571


#######################
# or: modify cutoff:
# changes majority decision to a different voting
res <- randomForest(y~.,data=d,subset=train,cutoff=c(0.8,0.2),
                    importance=TRUE)
pred <- predict(res,d[-train,])
(TAB <- table(d$y[-train],pred))
(mcl <- 1-sum(diag(TAB))/sum(TAB))
(TAB[2,1]/sum(TAB[2,]))
varImpPlot(res)

#######################
# or: modify sampsize:
# takes randomly (with replacement) these numbers of samples to grow each tree
minsize <- min(table(d$y[train]))
res <- randomForest(y~.,data=d,subset=train,
                    sampsize=c("no" = minsize,"yes" = minsize))
pred <- predict(res,d[-train,])
(TAB <- table(d$y[-train],pred))
(mcl <- 1-sum(diag(TAB))/sum(TAB))
(TAB[2,1]/sum(TAB[2,]))


                                                                     


