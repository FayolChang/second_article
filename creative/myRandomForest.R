myRandomForest <- function(num_vars,rfdata)
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
    for(formula in formulae)
    {
        fit  = train(as.formula(formula),
                     method = "rf",
                     trControl = trainControl(method = "cv",number = 10),
                     tuneLength = 8,
                     data = train_data)
        
        pred = predict(fit,newdata = test_data)
        model = list()
        model$Accuracy =confusionMatrix(pred,test_data$Would_be_ST)$overall[1]
        model$bestTune = fit$bestTune
        
        
        results[[index]] = model
        index = "With_eff"
    }
    results
}
