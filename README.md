# Classification-of-Cancer-Causing-Genes

Situation: 
Cancer is a group of diseases involving abnormal cell growth with the potential to invade or spread to other parts of the body. Oncogenes (OGs) and tumor suppressor genes (TSGs) are two cancer driver genes that play a role in cancer. The OGs and TSGs work together to keep the balance between cell growth and apoptosis. The discovery of cancer driver genes is imperative for cancer prevention, diagnosis, and treatment.

Task:
In this project, we will use statistical methods to classify the genes into three different classes of genes: tumor suppressor genes (TSGs), oncogenes (OGs), or neutral genes (NGs). If we can have an accurate prediction of the class of genes, we can use this model to discover new TSGs and OGs, which will be very useful in cancer diagnosis.

Action:
1. Data Preprocessing 
There are 99 variables and 3177 observations in the data set, including 1 response variable “class”. There are 2840 NGs, 168 OGs, and 169 TSGs in the total of 3177 observations. 
1)	We noticed 99 variables can be divide into 5 categories, such as Mutation, Genomics, Phenotype, Function, and Epigenetics. 
2)	We deleted 12 columns that contained only 0 values since they would have no effect on predicting the response variable. 

2. Model Description 
1)	We used findCorrelation() function in the R caret package to excluded the variables that have an absolute correlation of 0.8 or above within each category. 
2)	After combining these sets of predictors, we built a linear model with them and selected the predictors that had a variance inflation factor (VIF) of less than 5 to minimize multicollinearity within the model. 
3)	We used the rfcv() function in the R randomForest library to perform 10-fold cross-validation for feature selection.
4)	We used K-nearest neighbor (KNN), Linear Discriminant Analysis (LDA), Quadratic Discriminant Analysis (QDA), and Multinomial Logistic Regression (LR) classification methods to classify each observation in the test dataset. After many trials, we consistently found that LDA was the best classification method using our model. 

Result:
Our best-performing model included 20 predictors with a validation accuracy of 0.93, which indicates that our model performed very well. Using this model, we can accurately predict the class of cancer driver genes. The use of this model would be a powerful tool in cancer diagnosis. 
