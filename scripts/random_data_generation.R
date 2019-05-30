

#some Code

#make-up data from shore exploration
#some data
library(tidyverse)

#data.frame(matrix(rep(c(1,2,3,4,5,6,7,4,5,6,3,4),3), ncol = 3, nrow = 12))

#generate some random data
x <- data.frame(matrix(rep(sample(0:100, 1000, replace = T),3), ncol = 3, nrow = 12))

#randomly selected count data
counts <- x %>% sample_n(12)

#species list
species <- c("Patella vulgata", 
             "Littora obtusata", 
             "Semibalanus balanoides",
             "Fucus serratus", 
             "Fucus spiralis", 
             "Crepidula fornicata",
             "Anemonia viridis", 
             "Mytilus edulis", 
             "Ostrea edulis", 
             "Littorina saxatilis", 
             "Carcineas maenas",
             "Lipophrys pholis" )
transects <- c("1", "2", "3")
names(x) <- transects       
rownames(x) <- species

rm(x)

shore_zones <- rep(c("upper", "middle", "lower"),4)
env.data <- data.frame(matrix(rep(c("covered", "exposed"),6)), row.names = NULL) %>%
        sample_n(12) 
names(env.data) <- c("exposure")       
