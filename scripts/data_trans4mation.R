library(vegan)

#read data
counts <- read_rds("./count_data.RDS")
env_data <- read_rds("./env_data.RDS")


# transform - if count data, e.g. log transform
counts <- decostand(counts, "pa")



#species accumulation curve
sp_accum <- vegan::specaccum(counts, "random", permutations = 1000)
plot(sp_accum)


#distance Jaccard for presence absence
dist <- vegdist(counts, method = "jaccard", binary = TRUE)


#similarity between zones
simp <- simper(counts, env_data$exposure)
summary(simp)

# principal coordinates
pco_dat <- wcmdscale(dist, k = 6)
plot(pco_dat, choices=1:2, scaling="species", col = env_data$exposure, pch = 15, cex=2)
plot(pco_dat, choices=1:2, scaling="species", col = as.factor(env_data$shore_zones), pch = 16, cex=2)
ef <- envfit(pco_dat ~ dist_pier,data = env_data)
plot(ef,  bg = rgb(1, 1, 1, 0.5))

# are the groups different between 
adonis2(counts ~ shore_zones + exposure + dist_pier, data = env_data)
