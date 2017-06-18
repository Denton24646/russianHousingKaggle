setwd("~/Kaggle/Sberbank")
install.packages("lazyeval")
library(dummies)
library(ggplot2) # Data visualization
library(readr) # CSV file I/O, e.g. the read_csv function
library(data.table)
library(caret)
library(randomForest)
train <- fread("train.csv")
test<-fread("test.csv")

train<-train[,-"id"]
macro<-fread("macro.csv")
train<-merge(train,macro,by="timestamp")
train[which(train[,"full_sq"]<train[,"life_sq"]),"life_sq"]<-NA
train[which(train[,"max_floor"]<train[,"floor"]),"floor"]<-NA
train[,"num_room"]<-round(train[,"num_room"])
train<-train[-which(train[,"build_year"]==0),]
train<-train[-which(train[,"build_year"]==1),]
missing <- data.frame(sapply(train, function(x) sum(is.na(x))*100/length(x)))
missing
missing$feature <- names(train)
missing$num <- c(1:nrow(missing))
colnames(missing) <- c("missing_ratio", "feature", "num")
na<-missing[missing$missing_ratio != 0,]
barplot(na$missing_ratio,names.arg =na$feature)
sparse_var<-missing[missing$missing_ratio>40,]
vect<-as.vector(sparse_var$num)
train<-as.data.table(train)
train<-train[,-vect,with=F]
dim(train)
natreatement<-function(x){
 x<-as.data.frame(x)
 vect<-names(which(sapply(x,is.numeric)))
 vect1<-sapply(x[,vect],function(y) mean(y,na.rm=T))
 vect1
 name<-names(vect1)
 for (i in 1:length(vect1)){
  x[which(is.na(x[,name[i]])),name[i]]<-vect1[i]
 }
 x<-na.omit(x)
}


train<-natreatement(train)
train<-as.data.table(train)
train<-train[,-"timestamp",with=F]

train<-dummy.data.frame(train)
#outliers detection 
#For missing values that lie outside the 1.5 * IQR limits
#we could cap it by replacing those observations outside the lower limit with the value of 5th %ile
#those that lie above the upper limit, with the value of 95th %ile. 
for(i in 1:ncol(train)){
 qnt <- quantile(train[,i], probs=c(.25, .75))
 caps <- quantile(train[,i], probs=c(.01, .99))
 H <- 1.5 * IQR(train[,i], na.rm = T)
 train[,i][train[,i] < (qnt[1] - H)] <- caps[1]
 train[,i][train[,i] > (qnt[2] + H)] <- caps[2]
 
}
#presence of Constant and almost constant predictors across samples which are uninformative and can break our model
#By default, a predictor is classified as near-zero variance if
#1)the percentage of unique values in the samples <10%
#2)when the frequency ratio>19(95/5)
insignificant<-nearZeroVar(train)
train<-as.data.table(train)
train<-train[,-insignificant,with=F]
dim(train)  
#reduction of Multicolinearity:to satisfy the no colinearity assumption of multiple linear regression 
#that assumes that the independent variables are not highly correlated with each other. 
train<-as.data.table(train)
dim(train)
correlationmatrix<-cor(train[,-"price_doc"])
highlyCorrelated <- findCorrelation(correlationmatrix, cutoff=0.8)
train<-train[,-colnames(correlationmatrix[,highlyCorrelated]),with=F]
dim(train)
#feature selection using Random Forest which combine many binary decision trees built using 
#several bootstrap samples coming from the learning sample L and choosing randomly at each
#node a subset of explanatory variables X
#the good performance of random forests related to the good quality of each tree together
#with the small correlation among the trees of the forest where the correlation between trees
#is defined as the ordinary correlation of predictions on so-called out-of-bag (OOB )samples.
#The OOB sample which is the set of observations which are not used for building the current tree
#is used to estimate the prediction error and then to evaluate variable importance.
#The importance of a given variable is the increasing in mean of the error of a tree (MSE for regression)
#in the forest when the observed values of this variable are randomly permuted in the OOB samples
completes <- complete.cases(train)
trControl <- trainControl(method='none')
rfmod <- train(price_doc ~ . ,
               method='rf',
               data=train[completes, ],
               trControl=trControl,
               tuneLength=1,
               importance=TRUE)
# visulaization of features importance
ggplot(varImp(rfmod), top = 50)
important<-rownames(varImp(rfmod)$importance)
#extrating the 50 most important features 
train<-as.data.table(train)
ftrain<-cbind(train[,intersect(names(train),important[1:50]),with=F],train[,"price_doc"])
model<-lm(log(price_doc)~.,data=ftrain)
summary(model)

#prediction
id<-test[,"id"]
test<-merge(test,macro,by="timestamp")
test<-dummy.data.frame(test)
test<-as.data.table(test)
test<-test[,names(ftrain[,-"price_doc"]),with=F]
test<-as.data.frame(test)
for (i in 1:ncol(test)){
 test[which(is.na(test[,i])),i]<-mean(test[,i],na.rm=T)
}
price<-predict(model,test)
price<-as.data.frame(price,header=T)
price<-cbind(id,exp(price))
colnames(price)<-c("id","price_doc")
write.csv(price,file="submission_1.csv",row.names = F)
