library(randomForest)
library(caret) 

ml_df$condition <- as.factor(ml_df$condition)

# 2 train/test split (75% train, 25% test)

set.seed(73)
train_index <- createDataPartition(ml_df$condition, p = 0.75, list = FALSE)

train_data <- ml_df[train_index, ]
test_data  <- ml_df[-train_index, ]

x_train <- as.matrix(train_data[, !(colnames(train_data) %in% "condition")])
y_train <- train_data$condition

set.seed(73)
rf_model <- randomForest(x = x_train, 
                         y = y_train, 
                         ntree = 500, 
                         importance = TRUE)

test_predictions <- predict(rf_model, newdata = test_data)

conf_matrix <- table(Actual = test_data$condition, Predicted = test_predictions)
print(conf_matrix)

# 6. Calculate Test Accuracy
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(paste("Out-of-Sample Test Accuracy:", round(accuracy * 100, 2), "%"))