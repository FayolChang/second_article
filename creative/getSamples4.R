getSamples4 = function(corps_with_eff)
{
    library(plyr)
    library(dplyr)
    #分组随机抽取等量样本
    num_of_ST = with(corps_with_eff,sum(Would_be_ST=="YES"))
    set.seed(1234)
    cheat = corps_with_eff %>%
        dplyr::filter(Would_be_ST == "NO",eff>=0.0001) %>%
        do(sample_n(.,size = num_of_ST,replace = FALSE)) %>%
        dplyr::select(starts_with("F"),eff,Would_be_ST)
    
    st = corps_with_eff %>%
        dplyr::filter(Would_be_ST == "YES") %>%
        dplyr::select(starts_with("F"),eff,Would_be_ST)
   as.data.frame( rbind(cheat,st) ) 
}