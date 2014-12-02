layout(matrix(1:9,3,byrow = T))
apply(corps[,3:11],2,function(x){plot(density(x))})


by(corps$year,CalculateDEAEfficiency(corps[,3:11])) -> eff


expIndex = apply(corps[,3:11],2,function(x)floor(log10(abs(x))))

expIndex_and_year = as.data.frame(cbind(corps$year,expIndex))

expIndex_and_year %>% 
    group_by(V1) %>%
    summarise_each(funs(table))
    


by(expIndex_and_year[,-1],factor(expIndex_and_year$V1),function(x)apply(x,2,table))

N=1000
tmp = corps %>%
    filter(year==2008)%>%
    select(starts_with("A"),starts_with("B"),starts_with("C"))%>%
    sample_n(size = N,replace = F)

source("./src/DEA.R")
system.time(myeff<-CalculateDEAEfficiency(tmp))
