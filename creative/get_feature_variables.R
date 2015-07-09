get_feature_variables = function(times = 1)
{
    source("./creative/select_feature.r")
    source("./creative/getSamples2.r")
    source("./creative/getSamples3.R")
    source("./creative/getSamples4.R")
    
    #rfdata = getSample4(corps_with_eff)
    feature_selection_results = list()
    for(ind in 1:times)
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
    top05vars = Reduce(dplyr::intersect,vars5)
    top10vars = Reduce(dplyr::intersect,vars10)
    list(top05vars = top05vars,top10vars = top10vars)
}