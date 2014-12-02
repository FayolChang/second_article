##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title cleaning the data
##' @param feature_data 
##' @param dea_data 
##' @param ImplementST_data 
##' @return a dataframe including:dea_data and feature,ST
##' @author fujitsu
clean_data <- function(feature_data,dea_data,ImplementST_data)
{
    
    #本函数功能：
    #1.合并年末数据：feature，dea， 并加ST标签
    #2.去掉feature数据中的一些变量
    
    
    require(lubridate)
    require(dplyr)
    require(caret)
    
    
    ##去掉零方差，高度相关的列
    #因为DEA中的某些列和用来预测的features中有相关，这里选择把
    #那些相关的去掉，然后选择以T开头的列
    get_pred_data = function(dea_and_features_data)
    {
        col_num_near_zero_var = nearZeroVar(dea_and_features_data)
        if(length(col_num_near_zero_var) != 0)
            dea_and_features_data = dea_and_features_data[,-col_num_near_zero_var]
        
        large_cor = findCorrelation(cor(dea_and_features_data),cutoff = 0.7)
        
        dea_and_features_data = dea_and_features_data[,-large_cor]
        
        combo = findLinearCombos(dea_and_features_data)
        if(!is.null(combo$remove))
            dea_and_features_data = dea_and_features_data[,-combo$remove]
        

        #这里的features和DEA列中数据以及自己都没有相关或者共线性
        dea_and_features_data %>%
        select(starts_with("T"))
        
    }
    
    
    #feature_data 数据，每年有4个分别为每个季度末
    #我们这里只取年末的，即12-31
    feature_data_1231 = feature_data %>%
        filter(grepl("12-31",Accper)) %>%
        mutate(year = year(Accper))
    
    #合并feature_data 和 dea数据
    ML_DEA_data = dea_data %>% 
        inner_join(feature_data_1231)
    
    
    #   先选出每年的stkcd，unique
    stkcd = ML_DEA_data %>%
        mutate(year = as.factor(year)) %>%
        group_by(year) %>%
        select(Stkcd)
    
    ##
    ##
    ##
    unique_stkcd = with(stkcd,tapply(Stkcd,year,unique))
    #   因为要预测2年后是否会被ST，如08年的数据，就要预测11年是否被ST
    #   所以我需要的企业代码要在08，09，10,11年中都存在
    stkcd08to11 = Reduce(dplyr::intersect,unique_stkcd[1:4])
    stkcd09to12 = Reduce(dplyr::intersect,unique_stkcd[2:5])
    stkcd10to13 = Reduce(dplyr::intersect,unique_stkcd[3:6])
    
    #T-3年的数据
    data2008 = ML_DEA_data %>%
        filter(year == 2008,Stkcd %in% stkcd08to11)%>%
        left_join(ImplementST_data) %>%
        mutate(Would_be_ST = ifelse(is.na(Would_be_ST),"NO","YES")) %>%
        mutate(Would_be_ST = as.factor(Would_be_ST))
    
    data2009 = ML_DEA_data %>%
        filter(Accper == "2009-12-31",Stkcd %in% stkcd09to12)%>%
        left_join(ImplementST_data) %>%
        mutate(Would_be_ST = ifelse(is.na(Would_be_ST),"NO","YES")) %>%
        mutate(Would_be_ST = as.factor(Would_be_ST))
    
    data2010 = ML_DEA_data %>%
        filter(Accper == "2010-12-31",Stkcd %in% stkcd10to13)%>%
        left_join(ImplementST_data) %>%
        mutate(Would_be_ST = ifelse(is.na(Would_be_ST),"NO","YES")) %>%
        mutate(Would_be_ST = as.factor(Would_be_ST))
    
    
    merged_data = do.call(rbind,list(data2008,data2009,data2010))
    merged_data = merged_data %>%
        select(-Accper)
    
    
    cols_with_manyNAs = colSums(is.na(merged_data))>1000
    lessNA = merged_data[,!cols_with_manyNAs]
    noNAs = lessNA[complete.cases(lessNA),]
    
    
    
    ## NoNAs中以A、B、C列开始的是用于计算DEA的，某些列的相关性很强
    ## 分成2步骤：DEA和Pred：
    ## DEA:负数->正数
    ## Pred：去掉一些列
    
    dea_data = noNAs %>%
        select(starts_with("A"),starts_with("B"),starts_with("C"))

    starts_with_T_data = noNAs %>%
        select(starts_with("T"))

    dea_and_features_data = cbind(dea_data,starts_with_T_data)
    
    ## 下面用于筛选预测变量，筛去方差小的，相关性强的，多重共线性的
    ## 也就是去掉一些列
    processed_pred_data = get_pred_data(dea_and_features_data)
    
    corps = cbind(Stkcd = noNAs$Stkcd,
                               year = noNAs$year,
                               dea_data,
                               processed_pred_data,
                               Would_be_ST=noNAs$Would_be_ST)

    as.tbl(corps)
}

