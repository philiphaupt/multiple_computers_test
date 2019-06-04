#some Code
rm(list=ls())

#make-up data from shore exploration
#some data
library(tidyverse)
#library(pscl) # generate zero inflated data: https://stats.stackexchange.com/questions/368913/zero-inflated-count-data-simulation-in-r



# species list
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

# random presence absence data set
#very abundant
very_abundant <- rbinom(10000, 100, 0.6)
#abundant_species <- data.frame(matrix(rbinom(10000, 100, 0.35), ncol = 1, nrow = 10000))
abundant_species <- rbinom(10000, 100, 0.35)
#common_species <- data.frame(matrix(rbinom(10000, 10, 0.35), ncol = 1, nrow = 10000))
common_species <- rbinom(10000, 10, 0.5)
#rare_species <- data.frame(matrix(rbinom(10000, 1, 0.35), ncol = 1, nrow = 10000))
rare_species <- rbinom(10000, 1, 0.25)
#very rare
very_rare <- rbinom(10000, 1, 0.1)        


#percent_cover <- data.frame(matrix(rbinom(10000, 4, 0.35), ncol = 12, nrow = 10000))

d_vabun <- density(very_abundant)
d_abun <- density(abundant_species)
d_comm <- density(common_species)
d_rare <- density(rare_species)
d_vrare <- density(very_rare)


plot(d_rare, col = "blue", xlim = c(0,40))
lines(d_comm, col = "green")
lines(d_abun, col = "red")
lines(d_vrare, col= "black")
lines(d_vabun, col = "grey")
#choose type of community
#x <- rare_species

# randomly selected 27 samples from the randomly generated data above data
#pres_abs_dat <- x %>% sample_n(27)

# name community matrix
comm_data <- data.frame(matrix(nrow = 27, ncol = 12))
colnames(comm_data) <- species

# populate the data

#Rare species
#comm_data$`Patella vulgata` <- sample_n(rare_species, 27)
comm_data[1] <- c(sample(common_species, 9, replace = T), sample(rare_species, 9, replace = T), sample(very_rare, 9, replace = T))
#comm_data$`Crepidula fornicata` <- sample_n(rare_species, 27)
comm_data[6] <- c(sample(very_rare, 9, replace = T), sample(rare_species, 9, replace = T), sample(rare_species, 9, replace = T))
#comm_data$`Anemonia viridis` <- sample_n(rare_species, 27)
comm_data[7] <- c(sample(very_rare, 9, replace = T), sample(common_species, 9, replace = T), sample(common_species, 9, replace = T))
#comm_data$`Mytilus edulis` <- sample_n(rare_species, 27)
comm_data[8] <- c(sample(very_rare, 9, replace = T), sample(very_rare, 9, replace = T), sample(rare_species, 9, replace = T))
#comm_data$`Ostrea edulis` <- sample_n(rare_species, 27)
comm_data[9] <- c(sample(very_rare, 9, replace = T), sample(very_rare, 9, replace = T), sample(rare_species, 9, replace = T))

# Common species
#comm_data$`Littora obtusata` <- sample_n(common_species, 27)
comm_data[2] <- c(sample(common_species, 27, replace = T))
#comm_data$`Littorina saxatilis` <- sample_n(common_species, 27)
comm_data[10] <- c(sample(rare_species, 9, replace = T), sample(common_species, 9, replace = T), sample(common_species, 9, replace = T))
#comm_data$`Fucus serratus` <- sample_n(common_species, 27)
comm_data[4] <- c(sample(common_species, 9, replace = T), sample(rare_species, 9, replace = T), sample(abundant_species, 9, replace = T))
#comm_data$`Fucus spiralis` <- sample_n(common_species, 27)
comm_data[5] <- c(sample(rare_species, 9, replace = T), sample(very_rare, 9, replace = T), sample(common_species, 9, replace = T))
#comm_data$`Carcineas maenas`
comm_data[11] <- c(sample(rare_species, 9, replace = T), sample(common_species, 9, replace = T), sample(common_species, 9, replace = T))

# Abundant species
#comm_data$`Semibalanus balanoides` <- sample_n(abundant_species, 27)
comm_data[3] <- c(sample(common_species, 9, replace = T), sample(very_abundant, 9, replace = T), sample(rare_species, 9, replace = T))
#comm_data$`Lipophrys pholis`
comm_data[12] <- c(sample(very_rare, 9, replace = T), sample(very_rare, 9, replace = T), sample(rare_species, 9, replace = T))


#sample id
sample_id <- seq(1,27,1)
row.names(comm_data) <- sample_id # rename our samples according to their sample ids.

write_rds(comm_data, "./comm_data.RDS")     

#------------------------
#env data
#env_data <- data.frame(matrix(nrow = 9, ncol = 3))

#transects
transects <- c(1:9)

#env data: distance from pier
dist_pier <-seq(3,27, by = 3)

#populate env_data
#env_data[1] <- shore_zones
#env_data[2] <- dist_pier

#shore zones
shore_zones <- c("upper", "middle", "lower")
sample_station <- expand.grid(transects, shore_zones) #makes all possible combinations
sample_station_2 <- expand.grid(dist_pier, shore_zones)
exposure <- data.frame(matrix(rep(c(rep(c("covered", "exposed"),3),"exposed","exposed","exposed"),3))) %>%
        sample_n(27) 
names(exposure) <- c("exposure") 

env_data <- bind_cols(sample_station, sample_station_2, exposure)
env_data <- env_data[,-4]
names(env_data) <- c("transect", "shore_zones", "distance_from_pier", "exposure")
env_data <- env_data %>% arrange(transect)
row.names(env_data) <- sample_id


#housekeeping
rm(d_abun, d_comm, d_rare, exposure, sample_station, sample_station_2, dist_pier, shore_zones, transects)



write_rds(env_data, "./env_data.RDS")

