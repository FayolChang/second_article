source("./creative/mytrainv3.R")
source("./creative/get_features.R")
load(".RData")
system.time(top_05_and_10_features <- get_features())
