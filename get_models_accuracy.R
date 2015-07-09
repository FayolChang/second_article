

get_models_accuracy_testingdata = function(list_results)
{
    models_list = list_results[[1]]
    #去掉 bagg 模型
    models_list = models_list[-9]
    testX = list_results$test_X
    testY = list_results$test_y
    
    results = list()
    #index = 1
    for( model in models_list)
    {
        #cat("index = ",index,"\n")
        confusion_mat = confusionMatrix(predict(model,newdata=testX),testY)
        results[[model$method]] = confusion_mat$overall[1]
        #index = index+1
    }
    data.frame(accuracy = unlist(results))
}