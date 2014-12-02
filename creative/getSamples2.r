getSample2 = function(corps_with_eff)
{
    library(dplyr)
    #分组随机抽取等量样本
    num_of_ST = with(corps_with_eff,sum(Would_be_ST=="YES"))
    set.seed(1234)
    tmp = corps_with_eff %>%
        group_by(Would_be_ST) %>%
        do(sample_n(.,size = num_of_ST,replace = FALSE)) %>%
        select(starts_with("F"),eff,Would_be_ST)
}