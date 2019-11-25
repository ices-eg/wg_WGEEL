#######################################################################################
#######################################################################################
## GEREM: application to European data series script
## H. Drouineau - Irstea
## L. Beaulaton - Onema
## 10/09/2013
#######################################################################################
#######################################################################################
rm(list=ls())

library(runjags)
library(coda)
library(ggplot2)
library(RPostgreSQL)
library(tidyr)
library(reshape2)
library(sf)
library(getPass)
m=dbDriver("PostgreSQL")


#get the surface of a catchment given a list of wso_id
getSurface=function(w,con){
  if (as.character(w)<"0") return(1) #corresponds to unreal catchments
  dbGetQuery(con,paste("select sum(area_km2) from hydrographie.ccm_v2_1_riverbasin_seaoutlets where wso_id in (",as.character(w),")"))[1,1]
}
getUsername <- function(){
  name <- Sys.info()[["user"]]
  return(name)
}


if(getUsername() == 'hilaire.drouineau'){
  con_wgeel=dbConnect(m,host="citerne.bordeaux.cemagref.fr",user="hilaire.drouineau",dbname="sudoang",password=getPass("Password for wgeel database"))
  con_ccm=dbConnect(m,host="citerne.bordeaux.cemagref.fr",dbname="referentiel",user="hilaire.drouineau",password=getPass("Password for ccm database"))
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/github//wg_WGEEL/R/recruitment/auto_gerem/")
} else if (getUsername() == 'marie.vanacker'){
  con_wgeel=dbConnect(m,host="citerne.bordeaux.cemagref.fr",user="marie.vanacker",dbname="sudoang",password=getPass("Password for wgeel database"))
  con_ccm=dbConnect(m,host="citerne.bordeaux.cemagref.fr",dbname="referentiel",user="marie.vanacker",password=getPass("Password for ccm database"))
  setwd("C:/Users/marie.vanacker/Work Folders/Documents/projet SUDOANG/depot_git/sudoang/gerem")
}


####loading time series from WGEEL
series_wgeel=read.table("catchment_wgeel.csv",header=TRUE,sep=";")
series_wgeel$surface=sapply(series_wgeel$wso_id,getSurface,con=con_ccm )
wgeel=dbGetQuery(con_wgeel,paste("select das_year,ser_nameshort,ser_uni_code,das_value from datawg.t_dataseries_das left join datawg.t_series_ser on das_ser_id =ser_id where das_year>=1960 and ser_nameshort in ('",paste(series_wgeel$ser_nameshort,collapse="','"),"')",sep="") )

###converting to kg
wgeel$das_value=ifelse(wgeel$ser_uni_code=="t",wgeel$das_value*1000,ifelse(wgeel$ser_uni_code=="nr",wgeel$das_value*0.3/1000,wgeel$das_value))

###reshaping and merging Minho Spain and Portugal
wgeel_wide=dcast(wgeel,formula=das_year~ser_nameshort)
wgeel_wide$Min=wgeel_wide$MiPo+wgeel_wide$MiSp
wgeel_wide=wgeel_wide[,!names(wgeel_wide) %in% c("MiSp","MiPo")]


####loading additional french series
french_wide=read.table("french_serie2.csv",header=TRUE,sep=";")
french_wide=french_wide[,!names(french_wide) %in% c("Vaccares","Gisc")] #those data are already in wgeel database so we removed them
names(french_wide)[1]="das_year"
french_wide=subset(french_wide,french_wide$das_year>=1960)

series_french=read.table("catchment_french.csv",header=TRUE,sep=";")
series_french$surface=sapply(series_french$wso_id,getSurface,con=con_ccm )


values_wide=merge(wgeel_wide,french_wide,all=TRUE)
series=rbind.data.frame(series_wgeel,series_french)




######building zones
allcatchments=st_read(con_ccm,query='select wso_id,area_km2,"window",sea_cd,geom from hydrographie.ccm_v2_1_riverbasin_seaoutlets where strahler>0 and ("window"<=2004 or "window"=2008)')
outlets=st_read(con_ccm,query='select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2000_rivernodes where num_seg=0 union
                select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2001_rivernodes where num_seg=0 union
                select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2002_rivernodes where num_seg=0 union
                select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2003_rivernodes where num_seg=0 union
                select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2004_rivernodes where num_seg=0 union
                select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2008_rivernodes where num_seg=0')
outlets=subset(outlets,outlets$wso_id %in% allcatchments$wso_id)

emu=st_read(con_wgeel,query='select * from ref.tr_emu_emu')
asso=st_nearest_feature(st_transform(outlets,4326),emu)
outlets$emu=emu$emu_nameshort[asso]

allcatchments$emu=outlets$emu[match(allcatchments$wso_id,outlets$wso_id)]

#ATL_F
plot(subset(allcatchments, startsWith(allcatchments$emu,"FR_") & allcatchments$sea_cd==1))

#ATL_IB
plot(subset(allcatchments,(startsWith(allcatchments$emu,"ES_") | startsWith(allcatchments$emu,"PT_")) & allcatchments$sea_cd==1))


#Med
plot(subset(allcatchments,(startsWith(allcatchments$emu,"ES_") | startsWith(allcatchments$emu,"FR_")| startsWith(allcatchments$emu,"IT_")) & allcatchments$sea_cd==2))

#NS
plot(subset(allcatchments, allcatchments$sea_cd==5))

#Channel
plot(subset(allcatchments, (allcatchments$sea_cd==4 & allcatchments$window!=2002) & (startsWith(allcatchments$emu,'FR_') | allcatchments$emu %in% c("GB_Wale","GB_Seve","GB_SouW","GB_SouE"))))


#BI
plot(subset(allcatchments, allcatchments$sea_cd!=5 &  ((startsWith(allcatchments$emu,'GB_') | startsWith(allcatchments$emu,'IE_')) &  !allcatchments$emu %in% c("GB_Wale","GB_Seve","GB_SouW","GB_SouE"))))

allcatchments$zone=NA
allcatchments$zone[startsWith(allcatchments$emu,"FR_") & allcatchments$sea_cd==1]="ATL_F"
allcatchments$zone[(startsWith(allcatchments$emu,"ES_") | startsWith(allcatchments$emu,"PT_")) & allcatchments$sea_cd==1]="ATL_IB"
allcatchments$zone[(allcatchments$sea_cd==4 & allcatchments$window!=2002) & (startsWith(allcatchments$emu,'FR_') | allcatchments$emu %in% c("GB_Wale","GB_Seve","GB_SouW","GB_SouE"))]="Channel"
allcatchments$zone[allcatchments$sea_cd==5]="NS"
allcatchments$zone[allcatchments$sea_cd!=5 &  ((startsWith(allcatchments$emu,'GB_') | startsWith(allcatchments$emu,'IE_')) &  !allcatchments$emu %in% c("GB_Wale","GB_Seve","GB_SouW","GB_SouE"))]="BI"
allcatchments$zone[(startsWith(allcatchments$emu,"ES_") | startsWith(allcatchments$emu,"FR_")| startsWith(allcatchments$emu,"IT_")) & allcatchments$sea_cd==2]="Med"

plot(allcatchments["zone"],col=as.factor(allcatchments$zone))

allcatchments=subset(allcatchments,!is.na(allcatchments$zone))
allcatchments$zone=as.factor(allcatchments$zone)

zone=aggregate(allcatchments$area_km2,list(allcatchments$zone),sum)
names(zone)=c("zone","surface")


tmp=matrix(0,max(table(allcatchments$zone)),length(table(allcatchments$zone)))
tab=table(allcatchments$zone)
for (i in 1:length(tab)){
  tmp[1:tab[i],i]=allcatchments$area_km2[allcatchments$zone==names(tab)[i]]
  
}
colnames(tmp)=names(tab)
tmp=tmp[,match(zone$zone,colnames(tmp))]
surfaceallcatchment=t(tmp)







row.names(values_wide)=values_wide$das_year
values_wide=values_wide[,-1]


###############formatting data and inputs


nbyear=nrow(values_wide)
absolute=subset(values_wide,select=which(series$type[match(names(values_wide),series$ser_nameshort)]=="absolute"))
serie=subset(values_wide,select=which(series$type[match(names(values_wide),series$ser_nameshort)]=="relative"))
trap=subset(values_wide,select=which(series$type[match(names(values_wide),series$ser_nameshort)]=="trap"))
catch=subset(values_wide,select=which(series$type[match(names(values_wide),series$ser_nameshort)]=="catch"))


#serie=serie+1
serie=sweep(serie,2, colMeans(serie,na.rm=TRUE),"/")
logIAObs=as.matrix(log(serie))
logIAObs[is.infinite(logIAObs)]=NA #we removed 0 
logUObs=log(absolute)
logIPObs=as.matrix(log(trap))
logIPObs[is.infinite(logIPObs)]=NA #we removed 0 
logIEObs=log(catch)

nbsurvey=ncol(serie)
nbabsolute=ncol(absolute)
nbtrap=ncol(trap)
nbcatch=ncol(catch)

########formatting catchments
nbzone=nrow(zone)
tab_series=unique(series[,c("wso_id","surface","zone")]) # a table with one row per catchment in which we have data
nbcatchments=nrow(tab_series)

surface=tab_series$surface #vector of surfaces of the catchments
zonecatchment=match(tab_series$zone,zone$zone)

surfaceZone=zone$surface


###############creating vector of indices to match the different dataset
catchment_survey=match(series$wso_id[match(names(serie),series$ser_nameshort)],tab_series$wso_id)
catchment_absolute=match(series$wso_id[match(names(absolute),series$ser_nameshort)],tab_series$wso_id)
catchment_trap=match(series$wso_id[match(names(trap),series$ser_nameshort)],tab_series$wso_id)
catchment_catch=match(series$wso_id[match(names(catch),series$ser_nameshort)],tab_series$wso_id)

meanlogq=rep(log(.5),ncol(serie))



mulogRglobal1=log(sum(colMeans(absolute,na.rm=TRUE)))+log(sum(surfaceZone)/sum(surface[catchment_absolute]))

initpropR=rep(1/nbzone,nbzone)

#priors for scaling factors, alpha and beta of a beta distrition. If no data is provided, 
#default uninformative prior will be used
scale_bound=list(Vac=c(1.5,3), #trap around 1/3
                 Bann=c(1.5,3),#trap around 1/3
                 Bres=c(1.5,3),#trap around 1/3
                 Erne=c(1.5,3),#trap around 1/3
                 Fre=c(1.5,3),#trap around 1/3
                 Imsa=c(1.5,3),#trap around 1/3
                 Feal=c(1.5,3),#trap around 1/3
                 Inag=c(1.5,3),#trap around 1/3
                 Maig=c(1.5,3),#trap around 1/3,
                 Visk=c(1.5,3),#trap around 1/3
                 ShaA=c(1.5,3),#trap around 1/3
                 Somme=c(4.5,1.5)) #something wide around 0.75)


mydata=list(
  initpropR=initpropR,
  nbzone=nbzone,
  nbsurvey=nbsurvey,
  nbtrap=nbtrap,
  nbcatchments=nbcatchments,
  nbabsolute=nbabsolute,
  nbcatch=nbcatch,
  catchment_survey=catchment_survey,
  catchment_trap=catchment_trap,
  catchment_catch=catchment_catch,
  catchment_absolute=catchment_absolute,
  zonecatchment=zonecatchment,
  surface=ifelse(!is.na(surface),surface,1),
  nbyear=nbyear,
  logIAObs=as.matrix(logIAObs),
  logIPObs=as.matrix(logIPObs),
  logUObs=as.matrix(logUObs),
  logIEObs=as.matrix(logIEObs),
  surfaceallcatchment=surfaceallcatchment,
  scale_trap=sapply(1:nbtrap,function(i){
    if(names(trap)[i] %in% names(scale_bound)) {
      scale_bound[[names(trap)[i]]]
    } else { 
      c(1.01,1.01)
    }}
  ),
  scale_catch=sapply(1:nbcatch,function(i){
    if(names(catch)[i] %in% names(scale_bound)) {
      scale_bound[[names(catch)[i]]]
    } else { 
      c(1.01,1.01)
    }}
  )
)

generate_init=function(){
  gen_init=function(x){
    epsilonRcm=rnorm(mydata$nbcatchments*mydata$nbyear)
    logIAObs=apply(mydata$logIAObs,2,function(x){
      d=which(!is.na(x))
      x[which(is.na(x))]=runif(length(which(is.na(x))),min(x,na.rm = TRUE)*2,max(x,na.rm = TRUE)*2)
      x[d]=NA
      x
    })
    logIPObs=apply(mydata$logIPObs,2,function(x){
      d=which(!is.na(x))
      x[which(is.na(x))]=runif(length(which(is.na(x))),min(x,na.rm = TRUE)*2,max(x,na.rm = TRUE)*2)
      x[d]=NA
      x
    })
    
    logUObs=apply(mydata$logUObs,2,function(x){
      d=which(!is.na(x))
      x[which(is.na(x))]=runif(length(which(is.na(x))),min(x,na.rm = TRUE)*2,max(x,na.rm = TRUE)*2)
      x[d]=NA
      x
    })
    logIEObs=apply(mydata$logIEObs,2,function(x){
      d=which(!is.na(x))
      x[which(is.na(x))]=runif(length(which(is.na(x))),min(x,na.rm = TRUE)*2,max(x,na.rm = TRUE)*2)
      x[d]=NA
      x
    })
    
    
    #inits
    propR=matrix(0,nbzone,nbyear)
    for (i in 1:nbyear){
      tmp=rbeta(mydata$nbzone,1,1)
      propR[,i]=tmp/sum(tmp)
    }
    
    tauq=1/(runif(1,0.26,1)^2)
    tauRglob=1/(runif(1,0.26,1)^2)
    tauRwalk=1/(runif(1,0.26,1)^2)
    precisionpropRwalk=runif(1,0.5,1)
    tauIA=1/(runif(mydata$nbsurvey,0.26,1)^2)
    tauIP=1/(runif(mydata$nbtrap,0.26,1)^2)
    tauU=1/(runif(mydata$nbabsolute,0.26,1)^2)
    tauIE=1/(runif(mydata$nbcatch,0.26,1)^2)
    
    epsilonRzone=rnorm(mydata$nbyear*mydata$nbzone,0,1)
    epsilonR=rnorm(mydata$nbyear,0,1)
    beta=runif(1,0.01,2)
    logR1=runif(1,14,17)
    logq=runif(ncol(mydata$logIAObs),-13,0)
    a=apply(mydata$scale_trap,2,function(x) rbeta(1,x[1],x[2]))
    p=apply(mydata$scale_catch,2,function(x) rbeta(1,x[1],x[2]))
    inits=list(tauIE=tauIE,tauq=tauq,propR=propR,tauRglob=tauRglob,
               tauIA=tauIA,tauIP=tauIP,tauU=tauU, #precisionpropRwalk=precisionpropRwalk,      
               epsilonRzone=epsilonRzone,epsilonR=epsilonR,epsilonRcm=epsilonRcm,
               tauRwalk=tauRwalk,beta=beta,
               logR1=logR1,logIAObs=logIAObs,logIPObs=logIPObs,logUObs=logUObs,logq=logq,a=a,p=p)
    inits
  }
  gen_init(1)
}




debut=Sys.time()
jags_res=run.jags("versionBugs2_1.txt",monitor=c("beta","logq","loga","logRglobal","Rzone","propR"),data=mydata,n.chains=3,inits=generate_init,burnin=80000,sample=40000,thin=1,tempdir=FALSE,
                  summarise=FALSE,adapt = 80000,keep.jags.files=FALSE,method="parallel")



save.image("gerem2018.rdata")


jags_res=as.mcmc.list(jags_res)
jags_mat=as.matrix(jags_res)
colname=varnames(jags_res)
rm(jags_res)
gc()



#######Rzone
col=grep("Rzone",colname)
name_zone=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) zone$zone[as.numeric(x[3])])
year=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) as.numeric(row.names(values_wide)[as.numeric(x[2])]))
rzone=data.frame(t(apply(jags_mat[,col],2,quantile,probs=c(0.025,.5,.975))))
names(rzone)=c("q2.5","q50","q97.5")
rzone$year=year
rzone$zone=name_zone

ggplot(rzone,aes(x=year,y=q50))+geom_line()+geom_ribbon(aes(ymin=q2.5,ymax=q97.5),alpha=0.3)+
  facet_wrap(~zone)+ylab("R")




col=grep("Rzone",colname)
name_zone=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) zone$zone[as.numeric(x[3])])
year=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) as.numeric(row.names(values_wide)[as.numeric(x[2])]))
rzone=data.frame(log(t(apply(jags_mat[,col],2,quantile,probs=c(0.025,.5,.975)))))
names(rzone)=c("q2.5","q50","q97.5")
rzone$year=year
rzone$zone=name_zone

ggplot(rzone,aes(x=year,y=q50))+geom_line()+geom_ribbon(aes(ymin=q2.5,ymax=q97.5),alpha=0.3)+
  facet_wrap(~zone)+ylab("log R")


#######Rzone
col=grep("logRglobal",colname)
year=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) as.numeric(row.names(values_wide)[as.numeric(x[2])]))
logrglobal=data.frame(t(apply(jags_mat[,col],2,quantile,probs=c(0.025,.5,.975))))
names(logrglobal)=c("q2.5","q50","q97.5")
logrglobal=rbind.data.frame(logrglobal,exp(logrglobal))

logrglobal$year=c(year,year)
logrglobal$type=c(rep("log R",length(year)),rep("R",length(year)))

ggplot(logrglobal,aes(x=year,y=q50))+geom_line()+geom_ribbon(aes(ymin=q2.5,ymax=q97.5),alpha=0.3)+
  facet_wrap(~type,scales="free")



######propR
####----------------------------propR-------------------------------------
col=grep("propR",colname)
name_zone=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) zone$zone[as.numeric(x[2])])
year=sapply(strsplit(colname[col],"[[:punct:]]"),function(x) as.numeric(row.names(values_wide)[as.numeric(x[3])]))
propR=data.frame(t(apply(jags_mat[,col],2,quantile,probs=c(0.025,.5,.975))))
names(propR)=c("q2.5","q50","q97.5")
propR$year=year
propR$zone=name_zone

ggplot(propR,aes(x=year,y=q50))+geom_line()+geom_ribbon(aes(ymin=q2.5,ymax=q97.5),alpha=0.3)+
  facet_wrap(~zone)+ylab("proportion")
