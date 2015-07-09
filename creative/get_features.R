get_features = function()
{
    source("./creative/select_feature.r")
    source("./creative/getSamples2.r")
    source("./creative/getSamples3.R")
    source("./creative/getSamples4.R")
    
    feature_selection_results = list()
    for(ind in 1:20)
    {
        rfdata = getSamples4(corps_with_eff)
        feature_selection_model <- select_feature(rfdata)
        tmp = list()
        tmp$optVariables = feature_selection_model$optVariables
        tmp$optsize = feature_selection_model$optsize
        
        feature_selection_results[[ind]] = tmp
    }
    
    optvariables_list = lapply(X = feature_selection_results,function(x){x[[1]]})
    
    optvariables = do.call(cbind,optvariables_list)
    
    vars5 = lapply(optvariables_list,function(x)x[1:5])
    vars10 = lapply(optvariables_list,function(x)x[1:10])
    
    list(top05vars = Reduce(dplyr::intersect,vars5),
               top10vars = Reduce(dplyr::intersect,vars10))
    
}