# test an bayesian implementation to extrapolate landings
# 
# Author: lbeaulaton
###############################################################################

#########################
# INITS
#########################
source("R/utilities/load_library.R")
load_library(c("rjags", "stringr", "dplyr", "reshape2", "mgcv")) #rjags may need that jags is already installed on your computer (http://mcmc-jags.sourceforge.net/) : on Ubuntu >sudo apt install jags 

source("R/utilities/set_directory.R")
set_directory("result")
#result_wd = "/home/lbeaulaton/Documents/ANGUILLE/ICES/WGEEL/WGEEL 2017 Kavala/Catch_analysis"

# useful function to extract results
f_var_indice = function(var.names, n)
	paste(var.names, "[", n, "]", sep = "")

#########################
# prepare data
#########################

#load data
landings_original = read.table(file = str_c(result_wd, "/com_landings_YS_raw.csv"), sep = ";", header = TRUE)
surface_country = read.csv2(file = str_c(result_wd, "/country_surface.csv"), sep = ";", header = TRUE, dec= '.')

#putting year in rownames only
rownames(landings_original) = landings_original$year
landings_original = landings_original[,-1]

#statistics
nb_year = nrow(landings_original)
nb_country = ncol(landings_original)
min_year = min(as.numeric(rownames(landings_original)))
max_year = max(as.numeric(rownames(landings_original)))

#rearranging the data
year = factor(rep(min_year:max_year, nb_country))
country = factor(rep(colnames(landings_original), each = nb_year))
landings = unlist(landings_original)
landings = landings + 0.001
surface = surface_country[match(levels(country), as.character(surface_country$cou_code)), "surface"]
longitude = surface_country[match(levels(country), as.character(surface_country$cou_code)), "longitude"]
latitude = surface_country[match(levels(country), as.character(surface_country$cou_code)), "latitude"]
order = surface_country[match(levels(country), as.character(surface_country$cou_code)), "cou_order"]

nb_data = length(landings)

#########################
# model description
#########################

model_1 = "model {
		for (i in 1:nb_data) {
#landings are log-normally distributed
			landings[i] ~ dlnorm(mlandings[i],tau)
#country and year effect
			mlandings[i] <- log(country_effect[country[i]]) + log(year_effect[year[i]])
 # error
			e[i] <- log(landings[i]) - mlandings[i]
		}
# prior
		for(c in 1:nb_country){
			country_effect[c]~dlnorm(country_m[c],tau_c)
			country_m[c] <- abs(a * surface[c] + b * latitude[c] + d)
			e_country[c] <- log(country_effect[c]) - country_m[c]
		}
		for(y in 1:nb_year){
			year_effect[y]~dgamma(1,0.01) 
		}
		tau <- pow(s,-2)
		s ~ dunif(0,10000)
		tau_c <- pow(s_c,-2)
		s_c ~ dunif(0,10000)
		a ~ dnorm(0,0.1)
		b ~ dnorm(0,0.1)
		c ~ dnorm(0,0.1)
		d ~ dgamma(1,0.01) 
		}"

model_1 = "model {
		for (i in 1:nb_data) {
#landings are log-normally distributed
		landings[i] ~ dlnorm(mlandings[i],tau)
#country and year effect
		mlandings[i] <- log(country_effect[country[i]]) + log(year_effect[year[i]])
		# error
		e[i] <- log(landings[i]) - mlandings[i]
		}
# prior
		for(c in 1:nb_country){
#		country_effect[c]~dlnorm(country_m[c],tau_c)
		country_effect[c] ~ dgamma(1,1)
#		country_m[c] <- abs(a * surface[c] + b * latitude[c] + d)
#		e_country[c] <- log(country_effect[c]) - country_m[c]
		}
		for(y in 1:nb_year){
		year_effect[y]~dgamma(1,0.01) 
		}
		tau <- pow(s,-2)
		s ~ dunif(0,10000)
		tau_c <- pow(s_c,-2)
		s_c ~ dunif(0,10000)
#		a ~ dnorm(0,0.1)
#		b ~ dnorm(0,0.1)
#		c ~ dnorm(0,0.1)
		d ~ dgamma(1,1) 
		}"

#########################
# model run
#########################
surf = surface_country[match(as.character(country), as.character(surface_country$cou_code)), "surface"]
long = surface_country[match(as.character(country), as.character(surface_country$cou_code)), "longitude"]
lat = surface_country[match(as.character(country), as.character(surface_country$cou_code)), "latitude"]
ord = surface_country[match(as.character(country), as.character(surface_country$cou_code)), "cou_order"]
model_glm = gam(log(landings) ~ year + country)
model_glm = gam(log(landings) ~ year + s(surf, k=2) + s(long, lat, k = 20))
summary(model_glm)
AIC(model_glm)
plot.gam(model_glm, se = FALSE)

plot(surface_country$longitude, surface_country$latitude, type="n")
text(surface_country$longitude, surface_country$latitude, surface_country$cou_code)

model1 = jags.model(textConnection(model_1), data = .GlobalEnv, n.chain = 3, quiet = FALSE)
#update(model1, n.iter = 10000)
result = coda.samples(model1, 
		c("country_effect", "year_effect", "landings", "e", "a", "b", "c", "e_country", "d"), 10000, progress.bar = "gui", thin = 10)
#save(result, file = str_c(result_wd, "/bayesian2.RData"))
#load(file = str_c(result_wd, "/bayesian.RData"))

#test convergence
gelman.diag(result[,f_var_indice("year_effect", 1:nb_year)])
gelman.diag(result[,f_var_indice("country_effect", 1:nb_country)])

# basic stats
summary(result[,c("a", "b", "c", "d")])
summary(result[,f_var_indice("e_country", 1:nb_country)])
summary(result[, f_var_indice("country_effect", 1:nb_country)])
summary(result[, f_var_indice("year_effect", 1:nb_year)])

barplot((summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"]), names.arg = levels(country), las = 2)
barplot(summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / surface, names.arg = levels(country), las = 2)
barplot(summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / surface, names.arg = levels(country), las = 2)
barplot(summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / latitude, names.arg = levels(country), las = 2)
barplot(summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / longitude, names.arg = levels(country), las = 2)
barplot(summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / order, names.arg = levels(country), las = 2)

explore = function(variable)
{
	plot(variable, summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / surface, type = "n")
	text(variable, summary(result[, f_var_indice("country_effect", 1:nb_country)])$quantiles[,"50%"] / surface, labels = levels(country))	
}

explore(latitude)


#graph
x11()
par(mar = c(4, 4, 0.5, 0.5))
synth_year = summary(result[,f_var_indice("year_effect", 1:nb_year)])
plot(min_year:max_year, synth_year$quantiles[,"50%"])
synth_country = summary(result[,f_var_indice("country_effect", 1:nb_country)])
barplot(synth_country$quantiles[,"50%"], names.arg = levels(country), las = 2, horiz = T)

names_result = dimnames(result[[1]])
result_agreg = rbind(result[[1]], result[[2]], result[[3]])

#boxplot(as.matrix(result_agreg[, f_var_indice("country_effect", 1:nb_country)]), outline = FALSE, range = 1.5, yaxs = "i", las = 2, names = levels(country))
#
#boxplot(as.matrix(result_agreg[, f_var_indice("year_effect", 1:nb_year)]), outline = FALSE, range = 1.5, yaxs = "i", las = 2, names = levels(year))
#
#
#summary(result_agreg[, "landings[1010]"])
#summary(result_agreg[,f_var_indice("landings",(1:nb_data)[country == "FR"])])
#boxplot(as.matrix(result_agreg[,f_var_indice("landings",(1:nb_data)[country == "FR"])]), outline = FALSE, range = 1.5, yaxs = "i", las = 2, names = levels(year))
#
#a = result_agreg[,f_var_indice("landings",(1:nb_data)[year %in% c("1950", "2010")])]
#b = result_agreg[,f_var_indice("landings",(1:nb_data))]
#mapply(b, matrix(year, nrow = dim(b)[1], ncol = nb_data), function(X) quantile(rowSums(X)))
#round(quantile(rowSums(a), prob = c(2.5,25,50,75,97.5)/100))
##c = split(b, year)
reconstruction_df = melt(result_agreg[,f_var_indice("landings",(1:nb_data))], varnames = c("iteration", "name"))
reconstruction_df$year = rep(year, each = dim(result_agreg)[1])
reconstruction_df$country = rep(country, each = dim(result_agreg)[1])

#plot(min_year:max_year, tapply(c$value, list(c$year, c$country), function(X) quantile(rowSums(X), prob = .5)))
#
#c_small = c %>% filter(iteration %in% 5000:5999)
reconstruction_array = acast(reconstruction_df, iteration ~ year ~ country)

apply(reconstruction_array, c( 2, 3), quantile, prob = 0.975) - apply(reconstruction_array, c( 2, 3), quantile, prob = 0.025)

test = apply(reconstruction_array, c(1, 2), sum)
plot(min_year:max_year, apply(test, 2, quantile, prob = .975), type = "l", ylim = c(0, 50000), lty = 2, las = 2, xlab = "Year", ylab = "Landings (t)")
points(min_year:max_year,apply(test, 2, quantile, prob = .025), type = "l", lty = 2)
points(min_year:max_year,apply(test, 2, quantile, prob = .5), type = "l", lwd = 2)
grid()


extract_bayesian = function(r_year, r_country)
{
	return(quantile(reconstruction_array[,as.character(r_year),r_country], prob = c(2.5,25,50,75,97.5)/100))
}

extract_bayesian(1950, "FR")

matplot(min_year:max_year, t(apply(reconstruction_array[,,"FR"], 2, quantile, prob = c(2.5,25,50,75,97.5)/100)), type = "l", lwd = c(1,1,2,1,1))
boxplot( reconstruction_array[,,"FR"], outline = FALSE, range = 1.5, yaxs = "i", las = 2, names = levels(year))

boxplot(test, outline = FALSE, range = 1.5, yaxs = "i", las = 2, names = levels(year), ylim = c(0, 100000))
plot(min_year:max_year, apply(reconstruction_array[,,"FR"], 2, quantile, prob = .5), type = "l")

boxplot_ci = function()
{
	xb = boxplot(data$day ~data$an, plot = FALSE)
	xb$stats = quant1
	bxp(xb, outline = F, las = 2, xlab = "Année", yaxt = "n")	
}
