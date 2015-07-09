get_variable_importance = function()
{
    library(caret)
    source("./creative/getSamples4.R")
    spl = getSamples4(corps_with_eff)
    gbmFit = train(Would_be_ST~.,data = spl,method = "gbm")
    plot(gbmFit,type = c("g", "o"))
    
    variable_importance = varImp(gbmFit,scale = FALSE)
    plot(variable_importance,top=10)
}