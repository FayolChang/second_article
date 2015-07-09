mytrainv3 = function(num_vars)
{
    library(plyr)
    library(dplyr)
    library(caret)
    
    source("./creative/getSamples4.R")
    spl = getSamples4(corps_with_eff)
    
    all_vars = c("Would_be_ST",num_vars)
    
    spl = spl[,names(spl) %in% all_vars]
    
    vars_no_eff = !(names(spl) %in% c("eff","Would_be_ST"))
    
    vars_with_eff = !(names(spl) %in% c("Would_be_ST"))

    X_no_eff = spl[,vars_no_eff]

    X_with_eff = spl[,vars_with_eff]
    

    y = spl[,grepl("Would_be_ST",names(spl))]
    
    
#     var_eff = grepl("eff",num_vars)
#     
#     formula_without_eff = paste(c("Would_be_ST~"),
#                                 paste(num_vars[!var_eff],collapse = "+"))
#     
#     formula_with_eff = paste(c("Would_be_ST~"),
#                              paste(c(num_vars[!var_eff],"eff"),collapse = "+"))
#     
#     formulae = c(formula_without_eff,formula_with_eff)
    
    trainIndex = createDataPartition(spl$Would_be_ST,p=0.7,list = FALSE)
    
    train_X_no_eff = X_no_eff[trainIndex,]

    train_X_with_eff = X_with_eff[trainIndex,]

    train_y = y[trainIndex]

    test_X_no_eff = X_no_eff[-trainIndex,]
    
    test_X_with_eff = X_with_eff[-trainIndex,]
    
    test_y = y[-trainIndex]
    
    
    #train_methods = c("svmRadial","svmLinear","rf","nb","C5.0","ada","bag","logreg","nnet")
    #train_methods = c("svmRadial","svmLinear","rf","nb")
   train_methods = c("multinom")
    
    
    fitControl <- trainControl(method = "repeatedcv",
                                number = 10,
                               repeats = 5)

    index = 1
    results = list()
    for ( train_method in train_methods )
    {
        set.seed(825)
        Fit_no_eff <- train(x = train_X_no_eff,
                        y = train_y,
                        method = train_method,
                        trControl = fitControl,
                        preProc = c("center", "scale"),
                        tuneLength = 8)
        pred_no_eff = predict(Fit_no_eff,newdata = test_X_no_eff)
        
        Fit_with_eff = train(x = train_X_with_eff,
                             y = train_y,
                             method = train_method,
                             trControl = fitControl,
                             preProc = c("center", "scale"),
                             tuneLength = 8)
        pred_with_eff = predict(Fit_with_eff,newdata = test_X_with_eff)
        
        tmp = data.frame(method = train_method,
                         Accuracy_without_eff =confusionMatrix(pred_no_eff,test_y)$overall[1],
                         Accuracy_with_eff =confusionMatrix(pred_with_eff,test_y)$overall[1])
        results[[index]] = tmp
        index = index + 1
        
    }
    do.call("rbind",results)
}