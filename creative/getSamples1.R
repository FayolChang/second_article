getSamples1 <- function(corps_with_eff)
{
    num_of_ST_by_year = corps_with_eff %>%
                            group_by(year)%>%
                            filter(Would_be_ST=="YES")%>%
                            summarise(n=n())
    class(num_of_ST_by_year) = "data.frame"
    num_vec = as.numeric(num_of_ST_by_year[,2])
    samples = corps_with_eff %>%
        group_by(year) %>%
        do(sample_n(.,size = num_vec,replace = F))
    
   
    
    
}