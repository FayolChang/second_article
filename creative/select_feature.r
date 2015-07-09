select_feature <-function(rfdata)
{
    #library(randomForest)
    library(plyr)
    library(dplyr)
    library(caret)

    rfdata = as.data.frame(rfdata)
    #     formula = as.formula(formula)
#     trInd = createDataPartition(rfdata$Would_be_ST,p=0.8,list = FALSE)
# 
# 
#     train_data = rfdata[trInd,]
#     test_data = rfdata[-trInd,]
#     col_Would_be_ST = grepl("Would_be_ST",colnames(rfdata))
#     train_X = rfdata[, !col_Would_be_ST]
#     train_Y = rfdata[,  col_Would_be_ST]
    col_Would_be_ST = grepl("Would_be_ST",colnames(rfdata))
    X = rfdata[, !col_Would_be_ST]
    y = rfdata[,  col_Would_be_ST]

    subsize = c(2:9,seq(from = 10,to = ncol(X),by = 5))
    library(doMC)
    registerDoMC(cores = 6)

    set.seed(1234)
    rf2 = rfe(X,y,
              size = subsize,
              rfeControl = rfeControl(functions = rfFuncs))
    rf2
}
