load_feature_data = function()
{
    #读取那些不是用来计算DEA效率的数据
    #共计8个文件,合并到一起
    #返回原始数据
    setwd("./data/latest")
    Files = list.files(pattern="^FI")

    #require(data.table)
    library(dplyr)
    datalist = list()
    index = 1
    for(afile in Files)
    {
        #filename = substr(afile,start=1,stop=nchar(afile)-4)

        tbl = read.delim(file = afile,
                         header = TRUE,
                         colClasses = "character",
                         stringsAsFactors = FALSE)
        class(tbl) = c("data.frame")
        
        tbl = tbl %>%
            filter(grepl("12-31",Accper))
        
       
        
        datalist[[index]] = tbl

        index = index + 1
    }
    setwd("../../")
    Reduce(merge,datalist)

}











load_DEA_data = function()
{
    #加载用来计算DEA 效率的数据
    #返回没有清理的数据

    setwd("./data/latest")

    Files = list.files(pattern="^FS")
    library(dplyr)
    datalist = list()
    index = 1
    for(afile in Files)
    {
        tbl = read.csv(file = afile,
                       sep = "\t",
                       header = T,
                       encoding = "UTF-8",
                       colClasses = "character",
                       stringsAsFactors = FALSE)
        
        tbl = tbl %>%
            filter(grepl("12-31",Accper))
        
       # tbl[,3:ncol(tbl)] = sapply(tbl[,3:ncol(tbl)],as.numeric)
        
        datalist[[index]] = tbl
        index = index + 1
    }
    setwd("../../")
    Reduce(merge,datalist)
}




load_ST_data = function()
{
    library(dplyr)
    myfile = "./data/iFinD20140327/Implement_ST_1998_2014.csv"

    tbl = read.csv(file = myfile,header = T,fileEncoding = 'UTF-8')
    
    st_data = data.frame(Stkcd = strtrim(tbl[,1],6),
                        ImplementYear = lubridate::year(tbl[,3]),
                        Would_be_ST = "YES",
                        stringsAsFactors = FALSE)
    st_data = st_data %>%
        mutate(year = ImplementYear - 3) %>%
        select(-ImplementYear)

    ## 训练时,我们只用2008-2010年的数据
    ## 但是用的却是2011-2013的标签
    ## 例如,2008年的一家上市公司数据,其在2011年被首次ST
    ## 那么就把ST这个标签加到2008年的数据里
    ## 其意义为,不管2008年的业绩如何,我们想预测2年后其是否被ST

    ## 这里选取Perform_year 为2011-2013,即year=2008-2010
#     names(st)[1:2] = c("code","name")
#     if(pat=="Implement"){
#         st = st %>%
#             mutate(Stkcd = substr(code,1,6),
#                    Perform_year = as.numeric(Perform_year),
#                    year = Perform_year - 3,
#                    Would_be_ST = "YES") %>%
#             select(Stkcd,year,Would_be_ST)
#     }else{ ##选取的是被取消ST的企业，用来检验预测效果
#         st = st %>%
#             mutate(Stkcd = substr(code,1,6),
#                    Perform_year = as.numeric(Perform_year),
#                    year = Perform_year - 3,
#                    Would_be_CanceledST = "YES") %>%
#             select(Stkcd,year,Would_be_CanceledST)
#     }
# 
#     setwd("../../")
# 
#     st
}
