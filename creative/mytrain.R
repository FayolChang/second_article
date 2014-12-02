mytrain = function(rfdata,num_vars)
{
    
    
    library(caret)
    
    trainIndex = createDataPartition(rfdata$Would_be_ST,p=0.75,list = FALSE)
    
    train_data = rfdata[trainIndex,]
    test_data = rfdata[-trainIndex,]
    
#     col_Would_be_ST = grepl("Would_be_ST",colnames(rfdata))
#     train_X = train_data[, !col_Would_be_ST]
#     train_y = train_data[,  col_Would_be_ST]
#     
#     test_X = test_data[, !col_Would_be_ST]
#     test_y = test_data[, col_Would_be_ST]
    
    train_methods = c("svmRadial","svmLinear","rf","nb")
    
    var_eff = grepl("eff",num_vars)
    
    formula_without_eff = paste(c("Would_be_ST~"),
                                paste(num_vars[!var_eff],collapse = "+"))
    
    formula_with_eff = paste(c("Would_be_ST~"),
                             paste(c(num_vars[!var_eff],"eff"),collapse = "+"))
    
    fitControl2 <- trainControl(method = "adaptive_cv",
                                number = 10,
                                repeats = 5)
                                ## Estimate class probabilities
                                #classProbs = TRUE,
                                ## Evaluate performance using 
                                ## the following function
                                #summaryFunction = twoClassSummary,
                                ## Adaptive resampling information:
#                                 adaptive = list(min = 10,
#                                                 alpha = 0.05,
#                                                 method = "gls",
#                                                 complete = TRUE))
    
    models = list()
    index = 1
#     library(doMC)
#     registerDoMC(cores = 4)
    
    for(train_method in train_methods)
    {
        set.seed(825)
        fit_without_eff <- train(  as.formula(formula_without_eff),
                       method = train_method,
                       #trControl = fitControl2,
                       #preProc = c("center", "scale"),
                       tuneLength = 8,
                       #metric = "ROC",
                       data = rfdata)
        
        pred_without_eff = predict(fit_without_eff,newdata = test_data)
        

        set.seed(1234)
        fit_with_eff <- train(  as.formula(formula_with_eff),
                       method = train_method,
                       #trControl = fitControl2,
                       #preProc = c("center", "scale"),
                       tuneLength = 8,
                       #metric = "ROC",
                       data = rfdata)
        
        pred_with_eff = predict(fit_with_eff,newdata = test_data)
        
        tmp = data.frame(method = train_method,
        				Accuracy_without_eff =confusionMatrix(pred_without_eff,test_data$Would_be_ST)$overall[1],
        				Accuracy_with_eff =confusionMatrix(pred_with_eff,test_data$Would_be_ST)$overall[1])

        models[[index]] = tmp

        index = index + 1
        
    }

    do.call(rbind,models)

}