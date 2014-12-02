select_feature <-function(rfdata)
{
    #library(randomForest)
    #library(dplyr)
    library(caret)

    rfdata = as.data.frame(rfdata)
    #     formula = as.formula(formula)
    trInd = createDataPartition(rfdata$Would_be_ST,p=0.8,list = FALSE)


    train_data = rfdata[trInd,]
    test_data = rfdata[-trInd,]
    col_Would_be_ST = grepl("Would_be_ST",colnames(rfdata))
    train_X = rfdata[, !col_Would_be_ST]
    train_Y = rfdata[,  col_Would_be_ST]

    library(doMC)
    registerDoMC(cores = 2)

    set.seed(1234)
    rf2 = rfe(train_X,train_Y,
              size = c(2:ncol(train_X)),
              rfeControl = rfeControl(functions = rfFuncs))
    rf2

    #     pred = predict(rf2,newdata = test_data[,-28])
    #     varImpPlot(rf2$finalModel)
    #     model = list()
    #     model$confusionMatrix=confusionMatrix(pred,test_data$Would_be_ST)
    #     model$model = rf2$finalModel

}
