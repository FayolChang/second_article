getSample2 = function(corps)
{
    library(dplyr)
    #分组随机抽取等量样本
    #算DEA
    stCorps_observations = corps %>% 
        filter(Would_be_ST == "YES") %>%
        summarise(n = n())
    stCorps_observations = as.numeric(stCorps_observations)
    
    #set.seed(1234)
    grouped_corps = corps %>%
        group_by(Would_be_ST,year) %>%
        do(sample_n(.,size = 100,replace = TRUE))
    
    
    source("./src/DEA.R")
    source("./creative/sbm.gurobi.r")
    
    cols_abc = grepl("^A|B|C",names(grouped_corps))
    
    grouped_corps$eff = CalculateDEAEfficiency(grouped_corps[,cols_abc],sbm.gurobi)
    
    grouped_corps%>%
        select(starts_with("T"),eff,Would_be_ST)
}