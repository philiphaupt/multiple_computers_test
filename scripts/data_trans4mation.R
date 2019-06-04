library(vegan)
library(tidyverse)

#read data
comm_data <- read_rds("./comm_data.RDS")
env_data <- read_rds("./env_data.RDS")


# transform - if count data, e.g. log transform
pres_abs_dat <- decostand(comm_data, "pa")
comm_data_log <- decostand(comm_data, "log")


#species accumulation curve
sp_accum <- vegan::specaccum(comm_data, "random", permutations = 1000)
plot(sp_accum)


#distance Jaccard for presence absence
dist <- vegdist(comm_data_log, method = "altGower", add = "lingoes", binary = TRUE)


#similarity between zones
simp <- simper(comm_data, env_data$shore_zones)
summary(simp)

# principal coordinates
pco_dat <- wcmdscale(dist, eig = TRUE, k = 10)

#calculate relative contribution of axis
axis1_contr <- round(pco_dat$eig[1]/sum(pco_dat$eig)*100,2)
axis2_contr <- round(pco_dat$eig[2]/sum(pco_dat$eig)*100,2)

#labels for plot
pco.lbls <- env_data %>%
        dplyr::select(shore_zones, exposure)
# shape (pch)
pco.lbls$clr[pco.lbls$shore_zones == "upper"] <-  "cornflowerblue"
pco.lbls$clr[pco.lbls$shore_zones == "middle"] <-  "blue"
pco.lbls$clr[pco.lbls$shore_zones == "lower"] <-  "red"

# label colours (col) #https://www.statmethods.net/advgraphs/parameters.html
pco.lbls$pch[pco.lbls$exposure == "exposed"] <-  16
pco.lbls$pch[pco.lbls$exposure == "covered"] <-  17#"blue"



plot(pco_dat$points,
     type = "p", 
     col = pco.lbls$clr, 
     pch = pco.lbls$pch, 
     xlab = paste("PCO 1 (",axis1_contr," %) of variation"), 
     ylab = paste("PCO 2 (",axis2_contr," %) of variation"), 
     cex=2)

#add groups polygons
ordihull(pco_dat$points, groups = env_data$shore_zones, label = FALSE, col = c("cornflowerblue","blue","red"))

#plot(pco_dat$points, choices=1:2, scaling="species", col = as.factor(env_data$exposure), pch = 16, cex=2)
ef <- envfit(pco_dat ~ distance_from_pier,data = env_data)
plot(ef,  bg = rgb(1, 1, 1, 0.5))

legend(-0.45, 0.22, c("Lower", "Middle", "Upper"), lty = c(1,1,1), col = c("cornflowerblue", "blue","red"), cex = 1.1)
legend(-0.45, 0.29, c("Exposed", "Covered"), pch = c(16,17), cex = 1.1)
# are the groups different between 
adonis2(comm_data ~ shore_zones + exposure + dist_pier, data = env_data)
