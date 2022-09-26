load_library("MARSS")
load_library("parallel")
load_library("flextable")
load_library("tidyverse")
load_library("eulerr")

#' @title standard graph for raw data
#' @param data data (format tibble) the first row being the year and then all series
#' @return a graph in ggplot format
graph_serie = function(data)
{
	graph = 	ggplot(data,  aes(x = das_year, y = das_value))  + geom_line()  + geom_point(color = "blue") + facet_wrap(~ ser_nameshort, scales = "free_y") +  xlab("Year") + ylab("Abundance")
	return(graph)
}

#' @title log-transform data and replace  0 by 1%  of the mean
#' @param data data (format tibble) the first row being the year ('das_year') and then all series
#' @return data log-transformed data
log_transform = function(data)
{
	data = data  %>% mutate(across(!das_year, ~ ifelse(.x==0, mean(.x, na.rm = TRUE) * 0.01, .x))) %>% mutate(across(!das_year, ~ log(.x)))
	
	return(data)
}

#' @title Run DFA according to an experimental plan
#' @param data data (format tibble) the first row being the year ('das_year') and then all series
#' @param expe the experimental plan = a data.frame with 'S' column, variance-covariance matrix hypothesis et 'nbtrend' column, nb of trend to be tested.
#' @param log TRUE/FALSE (FALSE is the default). Should the data be lo-transformed by the function.
#' @return a list with the experimental plan (Trends and Sigma), AICc et AIC  and the model itself (dfa)
run_DFA = function(data, expe, log = FALSE)
{
	# data preparation
	if(log) data = log_transform(data)
	y=as.matrix(t(data[,-1])) #matrix of observation
	rownames(y)=colnames(data[,-1])
	colnames(y) = data[,1] %>% pull()
	
	cat(" --- list of models ---\n")
	print(expe)
	
	# model computing
	start_general = Sys.time()
	
	models = mcmapply(function(s,m){
			cat("-----------------------------")
			cat(paste0("nb trend = ", m, " ; ", s))
			cat("-----------------------------\n")
			start = Sys.time()
			dfa.model=list(R=s, m=m)
			kemz=MARSS(y, model=dfa.model, form="dfa",z.score=TRUE,  method="BFGS")
			aicc=MARSSaic(kemz, output="AICc")$AICc
			aic=MARSSaic(kemz, output="AIC")$AIC
			end = Sys.time()
			print(round(end - start, 1))
			list(Trends=m,Sigma=s,AICc=aicc,AIC=aic,dfa=kemz)
		},as.character(expe$S),expe$nbtrend, mc.cores=1,SIMPLIFY=FALSE)
	
	end_general = Sys.time()
	
	cat("\nTotal time elapsed: \n")
	print( round(end_general - start_general, 1))
	cat("\n")
	
	return(models)
}

#' @title summary of model statistics
#' @param models models as a result of 'run_DFA' function
#' @return a data.frame
summary_models = function(models)
{
	results_dfalp=do.call(rbind.data.frame,lapply(models,function(x) {
				data.frame(Trends=x["Trends"],
					Sigma=x["Sigma"],
					AIC=x["AIC"],
					AICc=as.numeric(x["AICc"])
				)})
	)
	
	return(results_dfalp)
}

#' @title produce a formatted (ready for a report) of the summary of the models (cf function 'summary_models')
#' @param results_dfalp output of the 'summary_models' function
#' @return a html table
table_summary_models = function(results_dfalp)
{
	ft <- flextable(results_dfalp[,c("Trends","Sigma", "AIC", "AICc")] %>% mutate(AIC = round(AIC), AICc = round(AICc))) #digits no more supported in colformat_num
	ft <- colformat_num(ft, j=c("AIC", "AICc"), big.mark = "")
	
	return(autofit(ft))
}

#' @title graph of AICc
#' @param results_dfalp output of the 'summary_models' function
#' @return a ggplot
graph_summary_models = function(results_dfalp)
{
	graph = ggplot(results_dfalp, aes(x=Trends, y = AICc, color =  Sigma)) + geom_point() + scale_x_continuous(breaks = 1:max(results_dfalp$Trends), name = "Number of trends") + scale_y_continuous() + scale_colour_discrete(name = "Variance-covariance")
	return(graph)
}

#' @title extract the best model based on AICc
#' @param models models as a results of 'run_DFA' function
#' @return a DFA model
best_DFA = function(models)
{
	results_dfalp = summary_models(models)
	n_best = which(results_dfalp$AICc==min(results_dfalp$AICc, na.rm = TRUE))
	best = models[[n_best]]$dfa
	cat(paste0("The best model has ", results_dfalp[n_best, "Trends"], " trend(s) and a  R ", results_dfalp[n_best, "Sigma"], "\n"))
	return(best)
}

#' @title extract and format the results of a DFA
#' @param the.fit a DFA model
#' @details extract and format the loading factors Z  and the trends using varimax (cf Holmes et al 2021)
#' @return a list
results_DFA = function(the.fit)
{
	H.inv=1
	Z.est = coef(the.fit, type="matrix")$Z
	if(ncol(Z.est)>1) H.inv = varimax(Z.est)$rotmat
#rotate factor loadings
	Z.rot<-coef(the.fit,type="matrix")$Z%*%H.inv
#rotate trends
	trends<-solve(H.inv)%*%the.fit$states
	scale_val=coef(the.fit)$A
	
#CI for Z
# Add CIs to marssMLE object
	the.fit <- MARSSparamCIs(the.fit)
	Z.low <- coef(the.fit, type = "Z", what = "par.lowCI")
	Z.up <- coef(the.fit, type = "Z", what = "par.upCI")
	Z.rot.up <- Z.up %*% H.inv
	Z.rot.low <- Z.low %*% H.inv
	Z.conf <- list(
		Z = Z.rot,
		Z.low = Z.rot.low,
		Z.up = Z.rot.up
	)
	
	return(list(Z=Z.rot, trends=trends, scale_val=scale_val,Z.conf = Z.conf))
}

#' @title graph of Z
#' @param Z.conf Z.conf as produce by 'results_DFA' function
#' @param graph_2_trends should the graph be adapted if only 2 trends?
#' @param sign_trends vector of 1 / -1 indicating if you want to inverse the trend (-1 in that case)
#' @return the graph
graph_Z = function(Z.conf, graph_2_trends = FALSE, sign_trends = NULL, minZ = 0.2)
{
	nb_series = dim(Z.conf[["Z"]])[1]
	nb_trends = dim(Z.conf[["Z"]])[2]
	names_series = rownames(Z.conf[["Z"]])
	
	Z.conf = array(unlist(Z.conf), dim = c(nb_series, nb_trends, 3), dimnames = list(names_series, as.character(1:nb_trends), c("Z", "Z.low", "Z.up")))
	Z.conf = data.table::as.data.table(Z.conf)
	names(Z.conf) = c("ser_nameshort", "trend", "Z", "value")
	
	#  inverse trends if needed
	if(is.null(sign_trends)) sign_trends = rep(1, nb_trends)
	if(length(sign_trends) != nb_trends) stop(paste0("sign_trends should be of length ", nb_trends))
	Z.conf = Z.conf %>% mutate(value = value * sign_trends[as.numeric(trend)])
	
	if(nb_trends == 2 & graph_2_trends)
	{
		Z.conf = inner_join(Z.conf %>% filter(trend == 1) %>% select(!trend) %>% pivot_wider(names_from = Z, values_from = value), Z.conf %>% filter(trend == 2) %>% select(!trend) %>% pivot_wider(names_from = Z, values_from = value), by = "ser_nameshort", suffix = c(".1", ".2"))
		graph = ggplot(Z.conf, aes(x = Z.1, y = Z.2, color = ser_nameshort, label = ser_nameshort))  + geom_rect(xmin = -minZ, xmax = minZ, ymin = -minZ, ymax = minZ, fill = gray(0.9), color = gray(0.9), alpha = 0.05) + geom_pointrange(aes(xmin= Z.low.1, xmax = Z.up.1), show.legend = FALSE)  + geom_pointrange(aes(ymin=Z.low.2, ymax=Z.up.2), show.legend = FALSE) + geom_vline(xintercept = 0, color = "black") + geom_hline(yintercept = 0, color = "black")  + geom_vline(xintercept = c(-minZ, minZ), color = "gray", linetype="dashed") + geom_hline(yintercept = c(-minZ, minZ), color = "gray", linetype="dashed") + ggrepel::geom_label_repel(show.legend = FALSE) + theme_classic() + xlab("Loading factor (Z) for trend 1") + ylab("Loading factor (Z) for trend 2")
	} else {	
		Z.conf = pivot_wider(Z.conf, names_from = Z, values_from = value)
		graph = ggplot(Z.conf, aes(y = ser_nameshort, x = Z, xmin= Z.low, xmax = Z.up, color = trend)) + geom_pointrange(position = position_dodge(width = 0.5)) + geom_vline(xintercept = 0, color = "black") + ylab("Serie") + xlab("Factor loading (Z)") + scale_colour_discrete(name = "Trend")
	}

	return(graph + theme_classic())
}

#' @title graph for trends
#' @param trends trends as produce by 'results_DFA' function
#' @param sign_trends vector of 1 / -1 indicating if you want to inverse the trend (-1 in that case)
#' @return the graph
graph_trends = function(trends, year, sign_trends = NULL)
{
	nb_trends = dim(trends)[1]
	
	# inverse trends if needed
	if(is.null(sign_trends)) sign_trends = rep(1, nb_trends)
	if(length(sign_trends) != nb_trends) stop(paste0("sign_trends should be of length ", nb_trends))
	for(m in 1:nb_trends)
		trends[m,] = trends[m,] * sign_trends[m]

	trends_long <- as.data.frame(t(trends))
	names(trends_long)=paste("Trend", 1:ncol(trends_long))
	trends_long$year=as.numeric(year )
	
	trends_long<-trends_long %>%
		pivot_longer(starts_with("Trend"), names_to="Trend")
	
	graph = ggplot(trends_long,aes(x=year, y=value, color = Trend))+
		geom_line()+
		xlab("Year") + ylab("Relative abundance") + scale_colour_discrete(name = "Trend")
	return(graph)
}


#' @title Venn diagram
#' @param Z as produce by the 'results_DFA' function
#' @param minZ the min value to consider a Z significant (defaut = 0.2)
#' @param sign_trends vector of 1 / -1 indicating if you want to inverse the trend (-1 in that case)
#' @return a list with the diagram (in `plot` slot) and the group each series belongs to (in `venn` slot)
Venn_diagram = function(Z, minZ = 0.2, sign_trends = NULL){
	nameseries = rownames(Z)
	nb_trends = dim(Z)[2]
	
	# on procède à l'inversion
	if(is.null(sign_trends)) sign_trends = rep(1, nb_trends)
	if(length(sign_trends) != nb_trends) stop(paste0("sign_trends should be of length ", nb_trends))
	for(m in 1:nb_trends)
		Z[,m] = Z[,m] * sign_trends[m]
	
	list_venn=do.call(c,lapply(1:(dim(Z)[2]),function(j){
				res=list(nameseries[which(Z[,j]>minZ)],nameseries[which(Z[,j] < -minZ)])
				names(res)=paste("Trend",j,c("+","-"),sep="")
				res
			}))

	list_venn$Any =nameseries[!nameseries %in% unlist(list_venn)]
	euler_fit<-euler(list_venn)
	lab=sapply(names(euler_fit$original.values),function(n){
			groups=strsplit(n,"&")[[1]]
			group_not=names(list_venn)[!names(list_venn) %in% groups]
			okgroup = apply(sapply(groups,function(g) nameseries %in% list_venn[[g]]),
				1,
				prod) 
			oknotgroup=1
			if(length(group_not)>0){
				oknotgroup=apply(sapply(group_not,
						function(g) !nameseries %in% list_venn[[g]]),
					1,
					prod)
			}
			paste(nameseries[as.logical(
						okgroup * oknotgroup)],
				collapse="\n")
		})
	eulerr_options(quantities=list(cex=.6))
	
	return(list(plot = plot(euler_fit,quantities=lab), venn = list_venn))
}


##TODO: check if still used if yes describe
#venn_belonging <- function(nameseries,Z,minZ){
#	nameseries=as.character(nameseries)
#	list_venn=do.call(c,lapply(1:(dim(Z)[2]),function(j){
#				res=list(nameseries[which(Z[,j]>minZ)],nameseries[which(Z[,j]< -minZ)])
#				names(res)=paste("Trend",j,c("+","-"),sep="")
#				res
#			}))
#	list_venn$Any =nameseries[!nameseries %in%unlist(list_venn)]
#	sapply(nameseries,function(ser) 
#			paste(names(list_venn)[sapply(names(list_venn),
#						function(g) ifelse(ser %in% list_venn[[g]], TRUE,FALSE))],
#				collapse="; "))
#}

#' @title convert the venn list into a tibble with trends
#' @param venn_list list. As produced by the Venn_diagram (slot `venn`)
#' @return a tible
tabulate_venn = function(venn_list)
{
	result = data.frame(
		ser_nameshort = unlist(venn_list, use.names=F),
		Venn_group = rep(names(venn_list), lengths(venn_list))
	)
	
	result = result %>% 
		table %>%
		as_tibble %>% 
		pivot_wider(names_from = "Venn_group", values_from = "n") 
	
	return(result)
}

#' @title convert the venn list into a data.frame
#' @param venn_list list. As produced by the Venn_diagram (slot `venn`)
#' @return a data.frame
unlist_venn = function(venn_list)
{
	
	group = tabulate_venn(venn_list) %>%
		select(- ser_nameshort) %>%
		map2_dfc(colnames(.), ., function(x1,x2) ifelse(x2 == 1, x1, "")) %>%
		apply(1, paste, collapse = "")
	
	result = tabulate_venn(venn_list)  %>% select(ser_nameshort) %>% bind_cols(group) %>% rename(Venn_group = `...2`) 
	
	return(result)
}

#' @title extract the sign of a given trend from a venn list
#' @param venn_list list. As produced by the Venn_diagram (slot `venn`)
#' @param trend integer. The number of the trend to extract
#' @return a data.frame
sign_trend_venn = function(venn_list, trend = 1)
{
	trend = paste0("Trend", trend)
	
	result = venn_list %>% 
		tabulate_venn() %>% 
		select(ser_nameshort, starts_with(trend)) %>%
		mutate(sign = ifelse(!!as.symbol(paste0(trend, "+")) == 1, "+", ifelse(!!as.symbol(paste0(trend, "-")) == 1, "-", "0"))) %>%
		select(ser_nameshort, sign)
	
	return(result)
}

#' @title graph of raw series and trends
#' @param model DFA model
#' @return a ggplot
series_trends_graph = function(model, colored_strip = TRUE)
{
	year = as.integer(colnames(model$model$data))
	TT = length(year)
	d <- residuals(model,interval="confidence")
	d$.conf.low <- d$.fitted + qnorm(0.05/2)*d$.sigma
	d$.conf.up <- d$.fitted - qnorm(0.05/2)*d$.sigma
	
	nameshort_ranked = sampling %>% arrange(rank) %>% select(ser_nameshort) %>% pull
	
	d = d  %>% inner_join(sampling, by = c(".rownames" = "ser_nameshort"))%>% mutate(.rownames = factor(.rownames, levels = nameshort_ranked))
	
	country_to_display = d %>% select(ser_cou_code, color_country, cou_order) %>% unique %>% arrange(cou_order)
	
	graph = ggplot(data = d) +
		geom_line(aes(t, .fitted)) +
		geom_point(aes(t, value, color = ser_cou_code)) +
		geom_ribbon(aes(x=t, ymin=.conf.low, ymax=.conf.up), linetype=2, alpha=0.2) +
		facet_wrap(vars(.rownames)) +
		xlab("Year") + ylab("Standardised abundance index")+
		scale_x_continuous(breaks=seq(1,TT,10),labels=year[seq(1,TT,10)]) +
		theme_classic() +
		scale_colour_manual("",
			breaks = country_to_display$ser_cou_code,
			values = country_to_display$color_country
		)  + 
		theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
	
	if(colored_strip)
	{
		#https://github.com/tidyverse/ggplot2/issues/2096
		g <- ggplot_gtable(ggplot_build(graph))
		strip <- which(grepl('strip-t', g$layout$name))
		fills <- c("red","green","blue","yellow")
		k <- 1
		for (i in strip) {
			j <- which(grepl('text', g$grobs[[i]]$grobs[[1]]$childrenOrder))
			j2 <- which(grepl('rect', g$grobs[[i]]$grobs[[1]]$childrenOrder))
			series_j = g$grobs[[i]]$grobs[[1]]$children[[j]]$children[1][[1]]$label 
			g$grobs[[i]]$grobs[[1]]$children[[j2]]$gp$fill = sampling %>% filter(ser_nameshort == series_j) %>% select(color_country) %>% pull()
		}
		graph = grid.draw(g)
	}
	
	return(graph)
}

#' @title correlation predicted/observed
#' @param model DFA model
#' @return the correlation
correlation_predicted_observed = function(model)
{
	d <- residuals(model)
	
	return(cor.test(d$value, d$.fitted))
}