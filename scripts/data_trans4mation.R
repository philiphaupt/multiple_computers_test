library(vegan)

#read data
counts <- read_rds("./count_data.RDS")
env_data <- read_rds("./env_data.RDS")


# transform - if count data, e.g. log transform
counts <- decostand(counts, "pa")



#species accumulation curve
sp_accum <- vegan::specaccum(count_data, "random", permutations = 1000)
plot(sp_accum)


#distance Jaccard for presence absence

dist <- vegdist(counts, method = "Jaccard", binary = TRUE)


#similarity between zones
simp <- simper(counts, env_data$exposure)
summary(simp)

# principal coordinates
pco_dat <- wcmdscale(dist, k = 6)
plot(pco_dat, choices=1:2, scaling="species", col = env_data$exposure, pch = 15, cex=2)
plot(pco_dat, choices=1:2, scaling="species", col = as.factor(env_data$shore_zones), pch = 16, cex=2)

# are the groups different between 
adonis2(counts ~ shore_zones + exposure, data = env_data)
