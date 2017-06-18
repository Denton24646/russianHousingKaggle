# Script to take most import feature selections from the train dataset and integrate them with VIF adjusted macro features
# check if score improves by adding some macro features

# merge train and macro datasets keeping only selected features

train_original <- read.csv("train.csv", header = TRUE)
test_timestamp <- read.csv("test.csv", header = TRUE)

important_features <- colnames(ftrain)

important_features <- append(important_features, "timestamp")

important_features_df <- data.frame(important_features)

train_important_features <- train_original[,important_features]

common_cols <- intersect(colnames(train_original),colnames(ftrain))
common_cols<- append(common_cols, "timestamp")

common_cols
?subset
train_cols <- train_original[, colnames(train_original) %in% common_cols]
?merge

complete_train <- merge(x=train_cols, y=macro, by = "timestamp") 

write.csv(complete_train, "complete_train.csv")

#merge test and macro to get complete test set

test_features <- test[,colnames(test_timestamp) %in% colnames(complete_train_imp)]
test_features$timestamp <- test_timestamp$timestamp

complete_test <- merge(x=test_features, y=macro, by = "timestamp")

complete_test$museum_visitis_per_100_cap <- NULL

#test_common_cols <- intersect(colnames(test_timestamp),colnames(complete_train_imp))
#test_common_cols



# deal with NA's in completed training set
?mice
library(mice)
complete_train_imp <- mice(complete_train[,-1], m=1, method='cart', maxit = 3, printFlag=TRUE)


summary(complete_train_imp)

complete_train_imp <- complete(complete_train_imp,1)

write.csv(complete_train_imp, "complete_train_imp.csv")

complete_train_imp$museum_visitis_per_100_cap <- NULL

write.csv(complete_test, "complete_test.csv")
complete_test_final <- complete_test
complete_test_final$apartment_build <- NULL
complete_test_final$timestamp <- NULL
complete_test_final$bandwidth_sports <- NULL

write.csv(complete_test_final, "complete_test_final.csv")

complete_train_imp_final <- complete_train_imp

complete_train_imp_final$apartment_build <- NULL
complete_train_imp_final$bandwidth_sports <- NULL
complete_train_imp_final$income_per_cap <- NULL
complete_test_final$income_per_cap <- NULL

#run RF Model
?randomForest
RF_model <- randomForest(price_doc ~., data = complete_train_imp_final,
             ntree = 100,
           #  mtry = 10,
           #  maxnodes = 10 ,
             do.TRACE = TRUE)
summary(RF_model)
print(RF_model)
varImpPlot(RF_model,
           sort = T,
           main="Variable Importance",
           n.var=10)
?predict

prediction_RF <- predict(RF_model,complete_test_final
                         ,type="response")

prediction_df<-data.frame(prediction_RF)

prediction_sub<-cbind(test_timestamp$id,prediction_df$prediction_RF)

colnames(prediction_sub)<-c("id","price_doc")
write.csv(prediction_sub,file="submission_RF.csv",row.names = F)


