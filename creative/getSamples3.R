##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##' @title 
##' @param corps_with_eff,eff is computed by year 
##' @return samples, 
##' @author fujitsu
getSamples3 = function(corps_with_eff)
{
    library(dplyr)
    tmp = corps_with_eff %>%
        group_by(year,Would_be_ST)%>%
        do(sample_n(.,size = 50,replace = T))%>%
        select(starts_with("T"),eff,Would_be_ST)
    tmp$year <- NULL
    tmp
}
