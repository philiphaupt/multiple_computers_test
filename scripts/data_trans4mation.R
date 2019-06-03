library(vegan)
library(tidyverse)

#read data
comm_data <- read_rds("./comm_data.RDS")
env_data <- read_rds("./env_data.RDS")


# transform - if count data, e.g. log transform
pres_abs_dat <- decostand(comm_data, "pa")
comm_data_log <- decostand(comm_data, "hell")


#species accumulation curve
sp_accum <- vegan::specaccum(comm_data, "random", permutations = 1000)
plot(sp_accum)


#distance Jaccard for presence absence
dist <- vegdist(comm_data_log, method = "altGower", binary = TRUE)


#similarity between zones
simp <- simper(comm_data, env_data$shore_zones)
summary(simp)

# principal coordinates
pco_dat <- wcmdscale(dist, k = 6)
plot(pco_dat, choices=1:2, scaling="species", col = env_data$exposure, pch = 15, cex=2)
plot(pco_dat, choices=1:2, scaling="species", col = as.factor(env_data$shore_zones), pch = 16, cex=2)
ef <- envfit(pco_dat ~ distance_from_pier,data = env_data)
plot(ef,  bg = rgb(1, 1, 1, 0.5))

# are the groups different between 
adonis2(comm_data ~ shore_zones + exposure + dist_pier, data = env_data)
