mytrainv2 <- function(num_vars,rfdata,method)
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
    
#     library(doMC)
#     registerDoMC(4)
    
    index = "Without_eff"
    for(formula in formulae)
    {
        fit  = train(as.formula(formula),
                     method = "svmRadial",
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



    for(train_method in train_methods[1:2])
    {
        set.seed(825)
        fit_without_eff <- train(  as.formula(formula_without_eff),
                                   method = train_method,
                                   #trControl = fitControl2,
                                   trControl = trainControl(method = "cv",number = 10),
                                   #preProc = c("center", "scale"),
                                   tuneLength = 8,
                                   #metric = "ROC",
                                   data = rfdata)
        
        pred_without_eff = predict(fit_without_eff,newdata = test_data)
        
        
        set.seed(1234)
        fit_with_eff <- train(  as.formula(formula_with_eff),
                                method = train_method,
                                #trControl = fitControl2,
                                preProc = c("center", "scale"),
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





}
