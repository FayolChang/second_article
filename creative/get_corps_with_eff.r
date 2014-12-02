get_corps_with_eff <- function(corps)
{
    source("./src/DEA.R")
    cols_ABC = grepl("^A|B|C",names(corps))
    corps_by_year = split(corps[,cols_ABC],corps$year)
    eff_by_year = lapply(X = corps_by_year,FUN = CalculateDEAEfficiency)
    corps$eff = unlist(eff_by_year)
    corps
}