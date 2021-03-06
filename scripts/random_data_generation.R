

#some Code
rm(list=ls())

#make-up data from shore exploration
#some data
library(tidyverse)
#library(pscl) # generate zero inflated data: https://stats.stackexchange.com/questions/368913/zero-inflated-count-data-simulation-in-r



#data.frame(matrix(rep(c(1,2,3,4,5,6,7,4,5,6,3,4),3), ncol = 3, nrow = 12))

#generate some random data
#x <- data.frame(matrix(rep(sample(0:100, 1000, replace = T),30), ncol = 30, nrow = 12))

x <- data.frame(matrix(rbinom(10000, 2, 0.35), ncol = 12, nrow = 9))

#randomly selected count data
counts <- x %>% sample_n(9)

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
transects <- c(1:9)#c("1", "2", "3")
rownames(counts) <- transects       
colnames(counts) <- species

rm(x)


env_data <- data.frame(matrix(nrow = 9, ncol = 3))
shore_zones <- rep(c("upper", "middle", "lower"),3)
exposure <- data.frame(matrix(c(rep(c("covered", "exposed"),3),"exposed","exposed","exposed")), row.names = NULL) %>%
        sample_n(9) 
names(exposure) <- c("exposure")       
dist_pier <-seq(3,27, by = 3)

env_data[1] <- shore_zones
env_data[2] <- exposure
env_data[3] <- dist_pier
names(env_data) <- c("shore_zones", "exposure")

write_rds(counts, "./count_data.RDS")
write_rds(env_data, "./env_data.RDS")

