##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title cleaning the data
##' @param feature_data 
##' @param dea_data 
##' @param st_data 
##' @return a dataframe including:dea_data and feature,ST
##' @author fujitsu
clean_data <- function(feature_data,dea_data,st_data)
{
    
    #本函数功能：
    #1.合并年末数据：feature，dea， 并加ST标签
    #2.去掉feature数据中的一些变量
    
    
    #require(lubridate)
    require(dplyr)
    require(caret)
    
    #合并feature_data 和 dea_data 
    feature_DEA_data = dea_data %>% 
        inner_join(feature_data) %>%
        mutate(year = lubridate::year(Accper))%>%
        select(-Accper,-Indcd,-Typrep)
    
   
   stkcd_and_year = data.frame(Stkcd = feature_DEA_data[,1],
                               year = feature_DEA_data[,ncol(feature_DEA_data)],
                               stringsAsFactors = FALSE)
   
   ml_dea = feature_DEA_data[,-c(1,ncol(feature_DEA_data))]
#    ml_dea_names = names(ml_dea)
   ml_dea = apply(ml_dea,2,as.numeric)
   ml_dea = as.data.frame(ml_dea)
   #names(ml_dea) = ml_dea_names
   dea_and_features_data = cbind(stkcd_and_year,ml_dea)
   
   
   #   第一步是找出3年里面同时存在的企业，这样会消去很多行，
# 可能恰好把NA比较多的行给消去了，所以第一步要做这个
   #   先选出每年的stkcd，unique
   stkcd = dea_and_features_data %>%
       mutate(year = as.factor(year)) %>%
       group_by(year) %>%
       select(Stkcd)
   
   ##
   ##
   ##
   unique_stkcd = with(stkcd,tapply(Stkcd,year,unique))
   #   因为要预测2年后是否会被ST，如08年的数据，就要预测11年是否被ST
   #   所以我需要的企业代码要在08，09，10,11年中都存在

    index = 1
    stkcd_4years = list() #i.e. 04-07,05-08,...
    mydata = list() # i.e. data2004,data2005,...
    for(year_ind in 2004:2010)
    {
#         assign(x = paste0("stkcd_",year,"_to_",year+3),
#                value = Reduce(dplyr::intersect,unique_stkcd[index:(index+3)]))
        stkcd_4years[[index]] = Reduce(dplyr::intersect,unique_stkcd[index:(index+3)])
        mydata[[index]] = dea_and_features_data %>%
                            filter(year == year_ind,Stkcd %in% stkcd_4years[[index]])%>%
                            left_join(st_data) %>%
                            mutate(Would_be_ST = ifelse(is.na(Would_be_ST),"NO","YES")) %>%
                            mutate(Would_be_ST = as.factor(Would_be_ST))

        index = index + 1
    }

   
   reduced_data = do.call(rbind,mydata)
   
   
    ##去掉零方差，高度相关的列
    #因为DEA中的某些列和用来预测的features中有相关，这里选择把
    #那些相关的去掉，然后选择以T开头的列
    
        #处理缺失值
        #这种处理，会导致有116家st企业的某年数据消失，因为缺失值太多
        #可能需要某种缺失值处理方法

        ##第二种方法是插值，这里采用knnImpute
        cols_with_manyNAs = colSums(is.na(reduced_data))>1000
        lessNA = reduced_data[,!cols_with_manyNAs]

        #以下集中处理ml_data部分，不要处理dea部分
        
        
        pure_ml_data = lessNA %>%
                        select(starts_with("F"))
        other_data = lessNA %>%
                        select(-starts_with("F"))
        

        pure_ml_data_obj = preProcess(pure_ml_data,method = "knnImpute")
        pure_ml_data_complete = predict(pure_ml_data_obj,pure_ml_data)

#         noNAs = lessNA[complete.cases(lessNA),]
        
        dea_and_features_data <- cbind(other_data,pure_ml_data_complete)

##因为此时dea_data中还有缺失值，所以要再用一遍complete.cases
        dea_and_features_data_complete = dea_and_features_data[complete.cases(dea_and_features_data),]
        
        
        #再次提取ml_dea_data
        stkcd_year_st = dea_and_features_data_complete %>%
            select(Stkcd,year,Would_be_ST)
        
        dea_and_features_data = dea_and_features_data_complete %>%
            select(-Stkcd,-year,-Would_be_ST)
        
        
        col_num_near_zero_var = nearZeroVar(dea_and_features_data)
        if(length(col_num_near_zero_var) != 0)
            dea_and_features_data = dea_and_features_data[,-col_num_near_zero_var]
        
        large_cor = findCorrelation(cor(dea_and_features_data),cutoff = 0.7)
        
        #我们要去掉的是ml里面的数据列，所以dea数据列即使相关，也保留
        #故要去掉的是列的位置大于等于10的
        pos_greater_than_9 = (large_cor)>9
        
        cols_to_delete = large_cor[pos_greater_than_9]
        
        dea_and_features_data = dea_and_features_data[,-cols_to_delete]
        
        combo = findLinearCombos(dea_and_features_data)
        if(!is.null(combo$remove))
            dea_and_features_data = dea_and_features_data[,-combo$remove]
        
        
    
    
    
    ## 中以A、B、C列开始的是用于计算DEA的，某些列的相关性很强
    
    
    corps = cbind(Stkcd = stkcd_year_st$Stkcd,
                               year = stkcd_year_st$year,
                               dea_and_features_data,
                               Would_be_ST = stkcd_year_st$Would_be_ST)

    as.tbl(corps)
}

