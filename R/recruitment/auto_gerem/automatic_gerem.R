#######################################################################################
#######################################################################################
## GEREM: application to European data series script
## H. Drouineau - Irstea
## L. Beaulaton - Onema
## 10/09/2013
#######################################################################################
#######################################################################################
rm(list=ls())

library(RPostgreSQL)
library(tidyr)
library(reshape2)
library(sf)
library(svDialogs)
m=dbDriver("PostgreSQL")


#get the surface of a catchment given a list of wso_id
getSurface=function(w,con){
  if (as.character(w)=="") return(1) #corresponds to unreal catchments
  dbGetQuery(con,paste("select sum(area_km2) from hydrographie.ccm_v2_1_riverbasin_seaoutlets where wso_id in (",as.character(w),")"))[1,1]
}
getUsername <- function(){
  name <- Sys.info()[["user"]]
  return(name)
}


if(getUsername() == 'hilaire.drouineau'){
  con_wgeel=dbConnect(m,host="localhost",user="hilaire",dbname="wgeel",password=dlg_input("Password for wgeel database", "")$res)
  con_ccm=dbConnect(m,host="citerne.bordeaux.cemagref.fr",dbname="referentiel",user="hilaire.drouineau",password=dlg_input("Password for ccm database", "")$res)
  setwd("~/Documents/Bordeaux/migrateurs/WGEEL/auto_gerem/")
}


####loading time series from WGEEL
catchment_wgeel=read.table("catchment_wgeel.csv",header=TRUE,sep=";")
catchment_wgeel$surface=sapply(catchment_wgeel$wso_id,getSurface,con=con_ccm )
wgeel=dbGetQuery(con_wgeel,paste("select das_year,ser_nameshort,ser_uni_code,das_value from datawg.t_dataseries_das left join datawg.t_series_ser on das_ser_id =ser_id where das_year>=1960 and ser_nameshort in ('",paste(catchment_wgeel$ser_nameshort,collapse="','"),"')",sep="") )

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

catchment_french=read.table("catchment_french.csv",header=TRUE,sep=";")
catchment_french$surface=sapply(catchment_french$wso_id,getSurface,con=con_ccm )


series_wide=merge(wgeel_wide,french_wide,all=TRUE)
catchment=rbind.data.frame(catchment_wgeel,catchment_french)




######building zones
allcatchments=st_read(con_ccm,query='select wso_id,area_km2,"window",sea_cd,geom from hydrographie.ccm_v2_1_riverbasin_seaoutlets where strahler>0 and ("window"<=2004 or "window"=2008)')
outlets=st_read(con_ccm,query='select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2000_rivernodes where num_seg=0 union
  select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2001_rivernodes where num_seg=0 union
  select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2002_rivernodes where num_seg=0 union
  select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2003_rivernodes where num_seg=0 union
  select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2004_rivernodes where num_seg=0 union
  select "window",gid, wso_id, geom from hydrographie.ccm_v2_1_w2008_rivernodes where num_seg=0')
emu=st_read(con_wgeel,query='select * from ref.tr_emu_emu')
st_nearest_feature(outlets,)

source("inits.R")
bv=read.table("bv2.csv",header=TRUE,sep=",")
zone=read.table("zones2.csv",header=TRUE,sep=";")






data_1_wide=merge(french_serie,data_1_wide,by.x="dat_year",by.y="dat_year",all=TRUE)

surfaceallbv=read.table("ccm_bv2.csv",header=TRUE,sep=";")
surfaceallbv=surfaceallbv[surfaceallbv$zone!="" & surfaceallbv$area_km2>0,]
surfaceallbv$zone=as.factor(as.character(surfaceallbv$zone))

tmp=matrix(0,max(table(surfaceallbv$zone)),length(table(surfaceallbv$zone)))
tab=table(surfaceallbv$zone)
for (i in 1:length(tab)){
  tmp[1:tab[i],i]=surfaceallbv$area_km2[surfaceallbv$zone==names(tab)[i]]
  
}
colnames(tmp)=names(tab)
tmp=tmp[,match(zone$zone,colnames(tmp))]
surfaceallbv=t(tmp)





#####remise des séries en kgs sans facteur d'efficacité
data_1_wide[,"Vilaine Arzal trapping all"]=as.numeric(paste(data_1_wide[,"Vilaine Arzal trapping all"]))*1000#passage en kilos
data_1_wide$Vaccares=(data_1_wide$Vaccares*0.3)/1000 ####correction de Vaccares et passage en kilos, 
data_1_wide[,"Bresle trapping all"]=(as.numeric(paste(data_1_wide[,"Bresle trapping all"]))*0.3)/1000#passage en g+ conversion en kgs
data_1_wide$Somme=data_1_wide$Somme#série en kg= classe unqiue
data_1_wide[,"Viskan Sluices trapping all"]=as.numeric(paste(data_1_wide[,"Viskan Sluices trapping all"]))#serie en kg
data_1_wide[,"River Feale"]=as.numeric(paste(data_1_wide[,"River Feale"]))#série en kgs
data_1_wide[,"Imsa Near Sandnes trapping all"]=(as.numeric(paste(data_1_wide[,"Imsa Near Sandnes trapping all"]))*0.3)/1000#passage en g+ conversion en kgs
data_1_wide[,"Fremur trapping all"]=(as.numeric(paste(data_1_wide[,"Fremur trapping all"]))*0.3)/1000#passage en g+ conversion en kgs
data_1_wide[,"Erne trapping all"]=as.numeric(paste(data_1_wide[,"Erne trapping all"]))#serie en kgs
data_1_wide[,"Shannon trapping all"]=as.numeric(paste(data_1_wide[,"Shannon trapping all"]))#serie en kgs
data_1_wide[,"Bann trapping partial"]=as.numeric(paste(data_1_wide[,"Bann trapping partial"]))#serie en kgs
data_1_wide[,"Oria"]=as.numeric(paste(data_1_wide[,"Oria"]))# serie en kgs
data_1_wide$AdGERMA=(data_1_wide$AdGERMA)# series en kgs
data_1_wide$GiGEMAC=(data_1_wide$GiGEMAC)# 
data_1_wide$SeGEMAC=(data_1_wide$SeGEMAC)# 
data_1_wide$ChGEMAC=(data_1_wide$ChGEMAC)# 
data_1_wide$LoGERMA=(data_1_wide$LoGERMA)# 
data_1_wide$Tiber=(data_1_wide$Tiber)# 

#transfo en classe numérique 
data_1_wide[,"Tiber commercial catch"]=as.numeric(paste(data_1_wide[,"Tiber commercial catch"]))*1000#passage en kgs
data_1_wide[,"Severn commercial catch"]=as.numeric(paste(data_1_wide[,"Severn commercial catch"]))*1000#passage en kgs
data_1_wide[,"Loire commercial catch"]=as.numeric(paste(data_1_wide[,"Loire commercial catch"]))#série en kgs
data_1_wide[,"Ems commercial catch"]=as.numeric(paste(data_1_wide[,"Ems commercial catch"]))#série en kgs
data_1_wide[,"Vida commercial catch"]=as.numeric(paste(data_1_wide[,"Vida commercial catch"]))#série en kgs
data_1_wide[,"Nalon commercial catch"]=as.numeric(paste(data_1_wide[,"Nalon commercial catch"]))#série en kgs
data_1_wide[,"Minho commercial catch"]=as.numeric(paste(data_1_wide[,"Minho commercial catch"]))#série en kgs
data_1_wide[,"Ebro commercial catch"]=as.numeric(paste(data_1_wide[,"Ebro commercial catch"]))#série en kgs
data_1_wide[,"Adour Estuary (CPUE) commercial CPUE"]=as.numeric(paste(data_1_wide[,"Adour Estuary (CPUE) commercial CPUE"])) 
data_1_wide[,"Adour Estuary commercial catch"]=as.numeric(paste(data_1_wide[,"Adour Estuary commercial catch"]))*1000#passage en kgs
data_1_wide[,"Albufera de Valencia commercial catch"]=as.numeric(paste(data_1_wide[,"Albufera de Valencia commercial catch"])) 
data_1_wide[,"Gironde Estuary commercial catch"]=as.numeric(paste(data_1_wide[,"Gironde Estuary commercial catch"]))*1000#passage en kgs 
data_1_wide[,"Ijzer Nieuwpoort scientific estimate"]=as.numeric(paste(data_1_wide[,"Ijzer Nieuwpoort scientific estimate"])) 
data_1_wide[,"IYFS1 scientific estimate"]=as.numeric(paste(data_1_wide[,"IYFS1 scientific estimate"])) 
data_1_wide[,"IYFS2 scientific estimate"]=as.numeric(paste(data_1_wide[,"IYFS2 scientific estimate"])) 
data_1_wide[,"Katwijk scientific estimate"]=as.numeric(paste(data_1_wide[,"Katwijk scientific estimate"])) 
data_1_wide[,"Lauwersoog scientific estimate"]=as.numeric(paste(data_1_wide[,"Lauwersoog scientific estimate"])) 
data_1_wide[,"Rhine DenOever scientific estimate"]=as.numeric(paste(data_1_wide[,"Rhine DenOever scientific estimate"])) 
#data_1_wide[,"Rhine Ijmuiden scientific estimate"]=as.numeric(paste(data_1_wide[,"Rhine Ijmuiden scientific estimate"])) 
data_1_wide[,"Ringhals scientific survey"]=as.numeric(paste(data_1_wide[,"Ringhals scientific survey"])) 
data_1_wide[,"River Inagh"]=as.numeric(paste(data_1_wide[,"River Inagh"]))#serie en kgs
data_1_wide[,"River Maigue"]=as.numeric(paste(data_1_wide[,"River Maigue"])) #serie en kgs
data_1_wide[,"Sevre Niortaise Estuary commercial CPUE"]=as.numeric(paste(data_1_wide[,"Sevre Niortaise Estuary commercial CPUE"])) 
data_1_wide[,"Stellendam scientific estimate"]=as.numeric(paste(data_1_wide[,"Stellendam scientific estimate"])) 


row.names(data_1_wide)=data_1_wide$dat_year



####on retire des séries à problème
#data_1_wide=data_1_wide[,!names(data_1_wide) %in% c("IYFS2 scientific estimate","Tiber commercial catch","River Maigue")]





#bv=bv[!bv$index%in%c("IYFS2 scientific estimate","Tiber commercial catch","River Maigue"),]
match(names(data_1_wide),bv$index)
match(bv$zone,zone$zone)

data_1_wide=data_1_wide[data_1_wide$dat_year>=1960,]


library(parallel)
library(coda)






method="surface" 
#method="debit"



###############"mise en forme des observations


nbyear=nrow(data_1_wide)
comptage=subset(data_1_wide,select=as.character(unique(bv$index[bv$type=="absolute"])))
serie=subset(data_1_wide,select=as.character(unique(bv$index[bv$type=="relative"])))
piege=subset(data_1_wide,select=as.character(unique(bv$index[bv$type=="trap"])))
expert=subset(data_1_wide,select=as.character(unique(bv$index[bv$type=="expertise"])))
#serie=serie[as.character(1980:2013),]
#serie=serie[,-which(names(serie)=="Loi")]

#serie=serie+1
serie=sweep(serie,2, colMeans(serie,na.rm=TRUE),"/")
logIAObs=log(serie)
#logIAObs[which(is.na(logIAObs),arr.ind=TRUE)]=-9999999999999999
logUObs=log(comptage)
#logUObs[which(is.na(logUObs),arr.ind=TRUE)]=-9999999999999999
logIPObs=log(piege)
logIEObs=log(expert)
#logIPObs[which(is.na(logIPObs),arr.ind=TRUE)]=-9999999999999999

nbsurvey=ncol(serie)
nbcomptage=ncol(comptage)
nbpiege=ncol(piege)
nbexpert=ncol(expert)

########mise en forme des bassins versants
nbzone=nrow(zone)
bv2=unique(bv[,c("bv","surface","zone","debit")])
nbbv=nrow(bv2)
surface=bv2$debit
if(method=="surface") surface=bv2$surface
zonebv=match(bv2$zone,zone$zone)
surfaceZone=zone$debit
if(method=="surface") surfaceZone=zone$area_km2


###############"création des vecteurs d'indice
bvsurvey=match(bv$bv[match(names(serie),bv$index)],bv2$bv)
bvcomptage=match(bv$bv[match(names(comptage),bv$index)],bv2$bv)
bvpiege=match(bv$bv[match(names(piege),bv$index)],bv2$bv)
bvexpert=match(bv$bv[match(names(expert),bv$index)],bv2$bv)

meanlogq=rep(log(.5),ncol(serie))



mulogRglobal1=log(sum(colMeans(comptage,na.rm=TRUE)))+log(sum(surfaceZone)/sum(surface[bvcomptage]))

initpropR=rep(1/nbzone,nbzone)




mydata=list(
  initpropR=initpropR,
  nbzone=nbzone,
  nbsurvey=nbsurvey,
  nbpiege=nbpiege,
  nbbv=nbbv,
  nbcomptage=nbcomptage,
  nbexpert=nbexpert,
  bvsurvey=bvsurvey,
  bvpiege=bvpiege,
  bvcomptage=bvcomptage,
  bvexpert=bvexpert,
  zonebv=zonebv,
  surface=surface,
  nbyear=nbyear,
  logIAObs=as.matrix(logIAObs),
  logIPObs=as.matrix(logIPObs),
  logUObs=as.matrix(logUObs),
  logIEObs=as.matrix(logIEObs),
  surfaceallbv=surfaceallbv)

generate_init=function(){
  gen_init=function(x){
    epsilonRbv=rnorm(mydata$nbbv*mydata$nbyear)
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
    tauIP=1/(runif(mydata$nbpiege,0.26,1)^2)
    tauU=1/(runif(mydata$nbcomptage,0.26,1)^2)
	tauIE=1/(runif(mydata$nbexpert,0.26,1)^2)
    
    epsilonRzone=rnorm(mydata$nbyear*mydata$nbzone,0,1)
    epsilonR=rnorm(mydata$nbyear,0,1)
    beta=runif(1,0.01,2)
    logR1=runif(1,14,17)
    logq=runif(ncol(mydata$logIAObs),-13,0)
    loga=runif(ncol(mydata$logIPObs),-2.3,-0.7)
	logp=runif(ncol(mydata$logIEObs),-0.43,-0.16)
    
    inits=list(tauIE=tauIE,logp=logp,tauq=tauq,propR=propR,tauRglob=tauRglob,
               tauIA=tauIA,tauIP=tauIP,tauU=tauU, #precisionpropRwalk=precisionpropRwalk,      
               epsilonRzone=epsilonRzone,epsilonR=epsilonR,epsilonRbv=epsilonRbv,
               tauRwalk=tauRwalk,beta=beta,
               logR1=logR1,logIAObs=logIAObs,logIPObs=logIPObs,logUObs=logUObs,logq=logq,loga=loga)
    inits
  }
  gen_init(1)
}




library(doParallel)
library(coda)
library(runjags)
library(Rmpi)
numWorkers <- 3
cl <- makeCluster(numWorkers, type = "MPI")
registerDoParallel(cl)
clusterCall(cl, function () Sys.info () [c ( "nodename", "machine" ) ] )

clusterExport(cl,c("mydata","inits"))
clusterEvalQ(cl,library(coda))
clusterEvalQ(cl,library(runjags))
clusterEvalQ(cl,library(doParallel))
clusterEvalQ(cl,library(foreach))
clusterEvalQ(cl,library(iterators))



debut=Sys.time()
#jags_res=jags.parfit(cl,data = mydata,params = c("beta","logq","logRglobal","Rbv","Rzone","propR"),model = "versionBugs.txt",inits = generate_init,n.chains = 3,n.iter=10000,n.update=10000)

jags_res=foreach(i =1:3,.combine='mcmc.list',.multicombine=TRUE)%dopar%{
	as.mcmc(run.jags("versionBugs2_1.txt",monitor=c("sdRwalk","precisionpropRwalk"),data=mydata,n.chains=1,inits=inits[[i]],burnin=80000,sample=40000,thin=1,tempdir=FALSE,
         summarise=FALSE,adapt = 80000,keep.jags.files=FALSE))
}



#jags_res=run.jags("versionBugs1.txt",monitor=c("beta","logq","loga",logRglobal","Rbv","Rzone","propR"),data=mydata,n.chains=3,inits=generate_init,burnin=20000,sample=20000,method="parallel",thin=1,tempdir=FALSE,
                  #summarise=FALSE,adapt = 10000,keep.jags.files=TRUE)
fin=Sys.time()
save.image("jags2_1_transect_2.Rdata")

stopCluster(cl)
mpi.exit()
