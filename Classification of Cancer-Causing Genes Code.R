set.seed(1)

cancer <- read.csv("training.csv")

# Find the predictors that have the top 49 values of positive correlation with class 1 and 2
cor_1 <- order(cor(cancer$class == 1, cancer), decreasing = TRUE)[2:50]
cor_2 <- order(cor(cancer$class == 2, cancer), decreasing = TRUE)[2:50]

# The column indies of the predictors that both in the top 49 values of correlation with class 1 and 2
cor_id <- cor_1[which(cor_1 %in% cor_2)]

# Create new dataset with predictors that have high positive correlation with class 1 and 2
cor_cancer <- cancer[, c(cor_id, 99)]

# Create a new dataset that without multicollinearity
library(car)
cor_cancer_lm <- lm(class ~ . , data = cor_cancer) 
summary(cor_cancer_lm)

# Select predictors with VIF < 5
cor_cancer_sb <- subset(cor_cancer, select = c(which(vif(cor_cancer_lm) < 5)))
cor_cancer_sb <- data.frame(cor_cancer_sb, "class" = cancer$class)

cor_cancer_lm_sl <- lm(class ~ . , data = cor_cancer_sb) 
summary(cor_cancer_lm_sl)

# Need to change the class level 0/1/2 to character to use caret package
cor_cancer_sb$class <- as.factor(cor_cancer_sb$class) 
levels(cor_cancer_sb$class) <- c("a","b","c")

# Split training dataset into 70 training, 30 validation
library(caret)
trainIndex <- createDataPartition(cor_cancer_sb$class, p = 0.7, list = FALSE)
cancer.training <- cor_cancer_sb[trainIndex,] 
cancer.test <- cor_cancer_sb[-trainIndex,]

# Conduct 10-fold Cross Validation
train_control <- trainControl(method = "cv", number = 10, classProbs = TRUE,
                              savePredictions = TRUE)
# Fit a LDA model
LDAfit <- train(class ~ .,
                data = cancer.training, method = "lda",
                preProc = c("center", "scale"), trControl = train_control)

# Evaluate LDA using 10-fold Cross Validation
LDAfit

# Evaluate using ROC curve
library(MLeval)

res <- evalm(list(LDAfit), gnames = c('LDA'))
res$roc

# Evaluate using confusion matrix
predLDA <- predict(LDAfit, newdata = cancer.test) 
confusionMatrix(data = predLDA, reference = cancer.test$class)

# Load the test data
cancer_test <- read.csv("test.csv")

# Output the test result using the LDA model
predLDA_TS <- predict(LDAfit, newdata = cancer_test) 
cancer_test$class <- predLDA_TS

# Change the levels of class back to 0/1/2
levels(cancer_test$class) <- c(0, 1, 2) 
LDA_output <- cancer_test[, c(1, 99)]