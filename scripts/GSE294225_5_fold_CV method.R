library(randomForest)
library(caret)
library(ggplot2)

ml_filtered$condition <- as.factor(ml_filtered$condition)

# 5-fold Cross-Validation configuration
train_control <- trainControl(method = "cv", 
                              number = 5, 
                              savePredictions = "all")

set.seed(73)
cv_model <- train(condition ~ ., 
                  data = ml_filtered, 
                  method = "rf", 
                  trControl = train_control,
                  ntree = 500)

print(cv_model)

library(caret)
library(ggplot2)

# Plot and Export
importance_scores <- varImp(cv_model, scale = TRUE)
print(head(importance_scores$importance, 20))

plot(importance_scores, top = 20, main = "Top Predictive Biomarkers (RA vs Healthy)")

write.csv(importance_scores$importance, file = "GSE294225_rf_biomarker_importance.csv")