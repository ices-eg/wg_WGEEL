#function used to shift month circularly
shifter <- function(x, n = 1) {
  if (n == 0) x else c(tail(x, -n), head(x, n))
}

#function used after a classification to get some stats about clusters
characteristics <- function(myres,nbclus, threshold=.80){
  mydata <- as.matrix(as.mcmc.list(myres,add.mutate=FALSE))
  sapply(seq_len(nbclus),function(clus){
    esp <- mydata[, paste("esp[",clus , ",", 1:12, "]", sep="")]
    duration_it <- apply(esp, 1, function (esp_it){
      esp_it <- min(which(cumsum(sort(esp_it, decreasing=TRUE))/
                            sum(esp_it)>threshold))
    })
    duration <- quantile(duration_it, probs=c(0.025, .5, .975))
    month_prop <- colMeans(esp)
    peak <- which(month_prop == max(month_prop))
    
    season_order <- shifter(1:12,peak-6) #with this order peak in the middle
    #of the season
    
    centroids <- apply(esp[,season_order], 1 , function(esp_it) {
      sum(esp_it * 1:12)/sum(esp_it)
    })
    quant_centr <- quantile(centroids, probs=c(0.025, .5, .975))
    quant_centr <- quant_centr - ceiling(quant_centr) +
      season_order[ceiling(quant_centr)]
    data.frame(cluster=clus,
               duration=duration[2],
               duration2.5=duration[1],
               duration97.5=duration[3],
               centroid=quant_centr[2],
               centroid2.5=quant_centr[1],
               centroid97.5=quant_centr[3])
    
  })
}


#function to build data in the format required by the jags model
build_data <- function(nbclus,seuil=.95){
  ref=as.integer(
    names(nb_occ_group)[which(nb_occ_group==max(nb_occ_group))])[1]
  list(y=y, #observations
       y2=y,
       group=group, #group identifier (a group is a period x series)
       nbm=12, #number of month
       nbclus=nbclus,# number of clusters
       seuil=seuil,
       nbgroup=length(unique(group)),
       nbobs=nrow(y),
       ref=ref,
       not_ref=seq_len(length(unique(group)))[-ref]
  )
}


#format to provide random initial values for the jags model
generate_init <- function(nbclus,mydata){
  lapply(1:3,function(nclus){
    dirichlet_prior <- function(n){
      t(replicate(n,{tmp <- runif(12)
      tmp <- tmp / sum(tmp)
      }))
    }
    cluster <- sample(1:nbclus, length(unique(group)), replace=TRUE)
    cluster[mydata$ref] <- NA
    list(cluster=cluster,
         esp_unordered=dirichlet_prior(nbclus),
         alpha_group=dirichlet_prior(length(unique(group))),
         lambda=runif(1,2,3)
    )
  })
}



#to be considered as valid, we need:
#   at least 8 months including the peak (since there are often two peaks, one
#   in spring and one in autumn)
#   that the first month of data generally stands for a small proportion of catches
#   that the last month of data generally stands for a small proportion of catches
#   that there is no missing month between first and last month

good_coverage_wave <- function(mydata, stage=NULL){
  
  checking_duplicate(mydata)
  if (is.null(stage)){
    peak_month <- unique(mydata$peak_month)
    lowest_month <- unique(mydata$lowest_month)
    stage="notG"
  } else if (stage =="G" | "emu_nameshort" %in% names(mydata)){
    lowest_month=10 #for glass eel season starts in november
  }
  original_months <- shifter(1:12,lowest_month-1)
  #we put data in wide format with one row per seasaon
  
  data_wide <- mydata[,c("season",
                         "month_in_season",
                         "das_value")] %>%
    spread(month_in_season,
           das_value,
           drop=FALSE)
  data_wide <- data_wide[,c(1:12,"season")]
  
  
  #For Spanish landings data of glass eels, NA are indeed 0 catches because
  #of fishery closure
  if (stage == "G" & "emu_nameshort" %in% names(mydata) & 
      unique(mydata$cou_code) == "ES") {
      data_wide[data_wide$season==min(mydata$season),
                which(original_months == 1):12] <- ifelse(is.na(data_wide[data_wide$season==min(mydata$season),
                                                                          which(original_months == 1):12]),0,data_wide[data_wide$season==min(mydata$season),
                                                                                                                       which(original_months == 1):12])
      data_wide[data_wide$season > min(mydata$season),] <-
        data_wide %>%
        filter(season>min(mydata$season)) %>%
        replace_na(replace=list(`1`=0,
                                      `2`=0,
                                      `3`=0,
                                      `4`=0,
                                      `5`=0,
                                      `6`=0,
                                      `7`=0,
                                      `8`=0,
                                      `9`=0,
                                      `10`=0,
                                      `11`=0,
                                      `12`=0))
  } else if ("emu_nameshort" %in% names(mydata) & 
             unique(mydata$cou_code) == "ES") {
    data_wide[data_wide$season==min(mydata$season),
              which(original_months == 1):12] <- ifelse(is.na(data_wide[data_wide$season==min(mydata$season),
                                                                        which(original_months == 1):12]),0,data_wide[data_wide$season==min(mydata$season),
                                                                                                                     which(original_months == 1):12])
    
    data_wide[data_wide$season==max(mydata$season),
              1:which(original_months==12)] <- ifelse(is.na(data_wide)[data_wide$season==max(mydata$season),
                                                                       1:which(original_months==12)],
                                                      0,
                                                      data_wide[data_wide$season==max(mydata$season),
                                                       1:which(original_months==12)]
                                                      )
    
    data_wide[data_wide$season > min(mydata$season) & data_wide$season < max(mydata$season),] <-
      data_wide %>%
      filter(season>min(mydata$season)) %>%
      replace_na(replace=list(`1`=0,
                              `2`=0,
                              `3`=0,
                              `4`=0,
                              `5`=0,
                              `6`=0,
                              `7`=0,
                              `8`=0,
                              `9`=0,
                              `10`=0,
                              `11`=0,
                              `12`=0))
  }
  mean_per_month <- colMeans(data_wide[,1:12],na.rm=TRUE)
  mean_per_month <- mean_per_month / sum(mean_per_month, na.rm=TRUE)
  
  cum_sum <- 
    cumsum(sort(mean_per_month, decreasing=TRUE)) / 
    sum(mean_per_month, na.rm=TRUE)
  
  
  name_data <- ifelse("ser_nameshort" %in% names(mydata),
                      unique(mydata$ser_nameshort),
                      unique(mydata$emu_nameshort))
  #we take the last month to have at least 95% of catches and which stands for
  #less than 5 % of catches
  bound <- min(which(cum_sum > .95 &
                       mean_per_month[as.integer(names(cum_sum))]<.05))
  if (is.infinite(bound) | sum(is.na(mean_per_month))>5){
    print(paste("For",
                name_data,
                "not possible to define a season"))
    return (NULL)
  }
  
  min_max <- range(as.integer(names(cum_sum)[1:bound]))
  fmin  <- min_max[1]
  lmin <- min_max[2]
  
  if ((fmin>1 & mean_per_month[fmin]>.05 & is.na(mean_per_month[fmin+1])) |
      (lmin<12 & mean_per_month[lmin]>.05 & is.na(mean_per_month[lmin+1]))){
    print(paste("For",
                name_data,
                "not possible to define a season"))
    return (NULL)
    
  }

  print(paste("For ",
              name_data,
              " a good season should cover months:",
              original_months[fmin],
              "to",
              original_months[lmin]))
  
  #  if ((lmin - fmin) < 8) return(NULL)
  keeping <- data_wide%>%
    mutate(num_na=rowSums(is.na(select(.,num_range("",fmin:lmin))))) %>%
    filter(num_na==0)
  if (nrow(keeping)==0) return(NULL)
  keeping$season
}

checking_duplicate <- function(mydata){
  counts_data <- table(mydata$das_year, mydata$das_month)
  if (sum(counts_data > 1)) {
    dup <- which(counts_data > 1, arr.ind = TRUE)
    if ("ser_nameshort" %in% names(mydata)){
      print(paste("##duplicates series",unique(mydata$ser_nameshort)))
    } else {
      print(paste("##duplicates series",unique(mydata$emu_nameshort)))
    }
    
    stop(paste(rownames(counts_data)[dup[,1]],
               colnames(counts_data)[dup[, 2]],
               collapse = "\n"))
  }
}


#creating season
finding_peak <- function(data){
  mean_per_month <- tapply(data$das_value,list(data$das_month),mean,na.rm=TRUE)
  peak_month <-as.integer(names(sort(mean_per_month,decreasing=TRUE)))[1]
  peak_month
}

finding_lowest_month <- function(data){
  mean_per_month <- tapply(data$das_value,list(data$das_month),mean,na.rm=TRUE)
  lowest_month <-as.integer(names(sort(mean_per_month)))[1]
  lowest_month
}


season_creation<-function(data){
  peak_month <- finding_peak(data) #2 3 4 5 6 7 8 9 10 11 12 1
  lowest_month <- finding_lowest_month(data)
  #season_order <- shifter(1:12,peak_month-6)
  season_order <- shifter(1:12,lowest_month-1)
  data$month_in_season <- as.factor(match(data$das_month,season_order))
  data$season <- ifelse(data$das_month < lowest_month,
                        data$das_year-1,
                        data$das_year)
  data$peak_month <- peak_month
  data$lowest_month <- lowest_month
  data
}



compute_silhouette <- function(res_mat){
  names_col <-colnames(res_mat)
  mean_si <- apply(res_mat, 1, function(iter){
    ng <- seq_len(length(unique(group)))
    clusters <- iter[paste("cluster[",ng,"]",sep="")]
    nb_occ <- table(clusters)
    used_group <- unique(clusters)
    esp <- t(sapply(ng,function(id){
      iter[grep(paste("alpha_group\\[", id,",", sep=""),
                names_col)]
    }))
    distance <- apply (esp, 1 ,function(x){ #matrix of distance among groups
      1 -rowSums(sweep(esp,2,x,pmin))
    })
    
    #average distance to other members of cluster
    ai <- sapply(ng, function(id){  
      ci <- which(clusters == clusters[id])
      ifelse(length(ci)>1,
             sum(distance[id,ci])/(length(ci)-1),
             NA)
    })
    
    #distance to the closest external cluster, defined as the mean distance
    #to all points of this external cluster
    bi <- sapply(ng, function(id){
      dk <- tapply(distance[id, ],list(clusters),mean)
      min(dk[names(dk) != clusters[id]])
    })
    
    #silhouette coeff
    si <- (bi-ai)/pmax(ai,bi)
    si[is.na(si)]<-0
    
    #mean silhouette from Kaufman et al.
    mean(si)
  })
}




median_pattern_group = function(g, group_name,res_mat, lfs_code, type, hty_code=NULL) {
  name <- group_name[g]
  ncar=nchar(name)
  if (is.null(hty_code)){
    emu_nameshort=substr(name,start=1,stop=ncar-4)
    period=substr(name,start=ncar,stop=ncar)
    hty_code=substr(name,start=ncar-2,stop=ncar-2)
  } else{
    emu_nameshort=substr(name,start=1,stop=ncar-2)
    period=substr(name,start=ncar,stop=ncar)
  }
  
  esp <- res_mat[,grep(paste("alpha_group\\[",g,",",sep=""),name_col)]
  med <- apply(esp,2,median)
  data.frame(emu_nameshort=emu_nameshort,
               period=period,
               hty_code=hty_code,
               lfs_code=lfs_code,
               type=type,
               month=1:12,
               prop=med/sum(med))
  
}



median_pattern_group_monitoring = function(g,emu,res_mat, lfs_code, ser, hty_code=NULL) {

  ncar=nchar(ser)
  period=substr(ser,start=ncar,stop=ncar)
  esp <- res_mat[,grep(paste("alpha_group\\[",g,",",sep=""),name_col)]
  med <- apply(esp,2,median)
  type=ser
    data.frame(emu_nameshort=emu,
               period=period,
               hty_code=hty_code,
               lfs_code=lfs_code,
               type=type,
               month=1:12,
               prop=med/sum(med))
  
}
