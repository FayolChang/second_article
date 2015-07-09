mytrain_with_eff = function(num_vars)
{
    library(plyr)
    library(dplyr)
    library(caret)
    
# 	library(doMC)
# 	registerDoMC(cores = 4)
    
    
    
    source("./creative/getSamples4.R")
    spl = getSamples4(corps_with_eff)
    
    all_vars = c("Would_be_ST",num_vars)
    
    spl = spl[,names(spl) %in% all_vars]
    
    vars_no_eff = !(names(spl) %in% c("eff","Would_be_ST"))
    
    vars_with_eff = !(names(spl) %in% c("Would_be_ST"))
    
    X_no_eff = spl[,vars_no_eff]
    
    X_with_eff = spl[,vars_with_eff]
    
    y = spl[,grepl("Would_be_ST",names(spl))]
    
    
    trainIndex = createDataPartition(spl$Would_be_ST,p=0.7,list = FALSE)
    
    train_X_no_eff = X_no_eff[trainIndex,]
    
    train_X_with_eff = X_with_eff[trainIndex,]
    
    train_y = y[trainIndex]
    
    test_X_no_eff = X_no_eff[-trainIndex,]
    
    test_X_with_eff = X_with_eff[-trainIndex,]
    
    test_y = y[-trainIndex]
    
    
    #train_methods = c("svmRadial","svmLinear","rf","nb","rpart","plr","nnet")
    #train_methods = c("svmRadial","svmLinear","rf","nb")
    train_methods = c("rpart","nnet")
    
    
    fitControl <- trainControl(method = "repeatedcv",
                               number = 5,
                               repeats = 5,
                               classProbs = TRUE,
                               summaryFunction = twoClassSummary)
    
    
    
    
    
    tuneLength = 12
    
    train_models = list()
    for ( train_method in train_methods )
    {
        #tuneLength = 24
        if(train_method == 'rf')
            tuneLength = 4
#         else if(train_method == 'ada')
#             tuneLength = 9
        set.seed(rbinom(n = 1,size = 10000,prob = 0.2))
        model <- train(x = train_X_with_eff,
                       y = train_y,
                       method = train_method,
                       trControl = fitControl,
                       preProc = c("center", "scale"),
                       tuneLength = tuneLength,
                       metric = "ROC")
        cat(paste("Model",train_method,"has been trained!"),"\n")
        train_models[[train_method]] = model
    }
    
    
    
    ##bag
    set.seed(rbinom(n = 1,size = 10000,prob = 0.2))
    model_bag <- train(x = train_X_with_eff,
                       y = train_y,
                       method = 'bag',
                       trControl = fitControl,
                       preProc = c("center", "scale"),
                       tuneLength = tuneLength,
                       metric = "ROC",
                       bagControl = bagControl(fit = ctreeBag$fit,
                                               predict = ctreeBag$pred,
                                               aggregate = ctreeBag$aggregate))
    
    
    
    train_models[['bag']] = model_bag
    
    #         pred_no_eff = predict(Fit_no_eff,newdata = test_X_no_eff)
    #         
    #         Fit_with_eff = train(x = train_X_with_eff,
    #                              y = train_y,
    #                              method = train_method,
    #                              trControl = fitControl,
    #                              preProc = c("center", "scale"),
    #                              tuneLength = 8)
    #         pred_with_eff = predict(Fit_with_eff,newdata = test_X_with_eff)
    #         
    #         tmp = data.frame(method = train_method,
    #                          Accuracy_without_eff =confusionMatrix(pred_no_eff,test_y)$overall[1],
    #                          Accuracy_with_eff =confusionMatrix(pred_with_eff,test_y)$overall[1])
    #         results[[index]] = tmp
    #         index = index + 1
    #         
    #     }
    #     do.call("rbind",results)
    list(models_with_eff = train_models, 
         test_X = test_X_with_eff,
         test_y = test_y)
    
}