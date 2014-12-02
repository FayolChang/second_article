myNaiveBayes <- function(num_vars,rfdata)
{
    library(caret)
    
    var_eff = grepl("eff",num_vars)
    
    formula_without_eff = paste(c("Would_be_ST~"),
                                paste(num_vars[!var_eff],collapse = "+"))
    
    formula_with_eff = paste(c("Would_be_ST~"),
                             paste(c(num_vars[!var_eff],"eff"),collapse = "+"))
    
    formulae = c(formula_without_eff,formula_with_eff)
    trainIndex = createDataPartition(rfdata$Would_be_ST,p=0.8,list = FALSE)
    
    train_data = rfdata[trainIndex,]
    test_data = rfdata[-trainIndex,]
    
    results = list()
    
    library(doMC)
    registerDoMC(2)
    
    index = "Without_eff"
    
    
    
    fitControl2 <- trainControl(method = "adaptive_cv",
                                number = 10,
                                repeats = 5,
                                ## Estimate class probabilities
                                classProbs = TRUE,
                                ## Evaluate performance using 
                                ## the following function
                                summaryFunction = twoClassSummary,
                                ## Adaptive resampling information:
                                adaptive = list(min = 10,
                                                alpha = 0.05,
                                                method = "gls",
                                                complete = TRUE))
    for(formula in formulae)
    {
        #         fit  = train(as.formula(formula),
        #                      method = "svmRadial",
        #                      trControl = trainControl(method = "cv",number = 10),
        #                      preProcess = c("center","scale"),
        #                      tuneGrid = paramGrid,
        #                      data = train_data)
        
        set.seed(825)
        fit <- train(as.formula(formula),
            method = "nb",
            trControl = fitControl2,
            tuneLength = 8,
            data = train_data,
            metric = "ROC")
        
        pred = predict(fit,newdata = test_data)
        model = list()
        model$Accuracy =confusionMatrix(pred,test_data$Would_be_ST)$overall[1]
        model$bestTune = fit$bestTune
        
        
        results[[index]] = model
        index = "With_eff"
    }
    results
}
