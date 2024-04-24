geremCode <- nimbleCode({
  for (zone in 1:nbzone){
    #weightZone[zone]<-sum(pow(surfaceallcatchment[zone,],beta))
    ###see https://en.wikipedia.org/wiki/Log-normal_distribution#Related_distributions
    VZ[zone] <- log((exp(1/tauLocal)-1)*(sum(pow(pow(surfaceallcatchment[zone,1:nbcatchmentzone[zone]],beta)*exp(-0.5/tauLocal),2))/pow(sum(pow(surfaceallcatchment[zone,1:nbcatchmentzone[zone]],beta)*exp(-0.5/tauLocal)),2))+1)
    sigmaZone[zone] <- sqrt(VZ[zone])
    tauZone[zone] <- 1/VZ[zone]
    muWeightZone[zone] <- log(sum(pow(surfaceallcatchment[zone,1:nbcatchmentzone[zone]],beta)*exp(-0.5/tauLocal)))+0.5/tauLocal-0.5*VZ[zone]
    weightZone[zone]~dlnorm(muWeightZone[zone],tauZone[zone])
  }
  for (icm in 1:nbcatchments){
    localeffect[icm]~dlnorm(-0.5/tauLocal,tauLocal)
    weight[icm]<-pow(surface[icm],beta)*localeffect[icm]/weightZone[zonecatchment[icm]]
  }
  
  #prior for first year of recruitment
  logRglobal[1]<-logR1
  Rglobal[1]<-exp(logRglobal[1])
  
  for (zone in 1:(nbzone)){
    Rzone[1,zone]<-Rglobal[1]*propR[zone,1]
  }
  for (icm in 1:nbcatchments){
    Rcmnotwhole[1,icm] ~ T(dnorm(Rcmpred[1,icm],sd=sdRcm[1,icm]), 0,)
    Rcmpred[1,icm]<-Rzone[1,zonecatchment[icm]]*((wholeZone[icm])+(1-wholeZone[icm])*weight[icm])
    sdRcm[1,icm]<-sqrt(0.00001*wholeZone[icm]+ (1-wholeZone[icm])*((0.000001+Rzone[1,zonecatchment[icm]])*(0.000001+weight[icm])*(.999999999999-weight[icm])))
    Rcm[1,icm]<-wholeZone[icm] * Rzone[1,zonecatchment[icm]] + (1-wholeZone[icm])*(0.0001+Rcmnotwhole[1,icm]) #troncature pour éviter des log de 0
  }
  
  for (y in 2:nbyear){
    mulogRglobal[y-1]<-logRglobal[y-1]
    logRglobal[y]<-mulogRglobal[y-1]+epsilonR[y]*sdRwalk
    Rglobal[y]<-exp(logRglobal[y])
    for (zone in 1:(nbzone)){
      #		Rzonepred[y,zone]<-Rglobal[y]*propR[zone]
      #		sdRzone[y,zone]<-sqrt((0.000001+Rglobal[y])*(0.000001+propR[zone])*(.999999999999-propR[zone]))
      #		Rzone[y,zone]<-max(0.000000001,Rzonepred[y,zone]+epsilonRzone[(y-1)*nbzone+zone]*sdRzone[y,zone]) #troncature pour éviter des log de 0
      Rzone[y,zone]<-propR[zone,y]*Rglobal[y]
    }
    for (icm in 1:nbcatchments){
      Rcmnotwhole[y,icm] ~ T(dnorm(Rcmpred[y,icm],sd=sdRcm[y,icm]), 0,)
      Rcmpred[y,icm]<-Rzone[y,zonecatchment[icm]]*((wholeZone[icm])+(1-wholeZone[icm])*weight[icm])
      
      sdRcm[y,icm]<-sqrt(0.00001*wholeZone[icm]+(1-wholeZone[icm])*((0.000001+Rzone[y,zonecatchment[icm]])*(0.000001+weight[icm])*(.999999999999-weight[icm])))
      Rcm[y,icm]<-Rzone[y,zonecatchment[icm]] * wholeZone[icm] + (1-wholeZone[icm]) * (Rcmnotwhole[y,icm]+0.0001) #troncature pour éviter des log de 0
    }
  }
  for (zone in 1:nbzone){
    Rzone_final[zone]<-Rzone[nbyear,zone]
    alpha[zone]<-initpropR[zone]+0.01#*precisionpropRwalk
  }
  
  
  for (y in 1:nbyear){
    for (isurvey in 1:nbsurvey){
      ########on doit connaitre: capturabilité du survey q[survey], la surface du bv bvsurvey[survey]
      ########  
      logIApred[y,isurvey]<-logq[isurvey]+log(Rcm[y,catchment_survey[isurvey]])-0.5/tauIA[isurvey]
      logIAObs[y,isurvey]~dnorm(logIApred[y,isurvey],tauIA[isurvey])
    }
    for (itrap in 1:nbtrap){
      ########on doit connaître l'efficacité du piège
      logIPpred[y,itrap]<-loga[itrap]+log(Rcm[y,catchment_trap[itrap]])-0.5/tauIP[itrap]
      logIPObs[y,itrap]~dnorm(logIPpred[y,itrap],tauIP[itrap])
    }
    
    for (icatch in 1:nbcatch){
      ########on doit connaître l'efficacité du piège
      logIEpred[y,icatch]<-logp[icatch]+log(Rcm[y,catchment_catch[icatch]])-0.5/tauIE[icatch]
      logIEObs[y,icatch]~dnorm(logIEpred[y,icatch],tauIE[icatch])
    }
    
    for (iabsolute in 1:nbabsolute){
      ########on doit connaitre: pareil qu avant mais sans capturabilité
      logUpred[y,iabsolute]<-log(Rcm[y,catchment_absolute[iabsolute]])-0.5/tauU[iabsolute]
      logUObs[y,iabsolute]~dnorm(logUpred[y,iabsolute],tauU[iabsolute])
    }
  }
  beta~dunif(0.71,1.3)
  propR[1:nbzone,1]~ddirich(alpha[1:nbzone])
  for (y in 2:nbyear){
    alphaYear[y-1, 1:nbzone] <- lambda*propR[1:nbzone,y-1]
    propR[1:nbzone,y]~ddirich(alphaYear[y-1, 1:nbzone])
  }
  lambda<-80
  

  for (y in 1:(nbzone*nbyear)){
    epsilonRzone[y]~dnorm(0,1)
  }
  for (y in 1:nbyear){
    epsilonR[y]~dnorm(0,1)
  }
  logR1~dunif(14,17)
  for (survey in 1:nbsurvey){
    logq[survey]~dunif(-13,0)
  }
  for (itrap in 1:nbtrap){
    a[itrap]~T(dbeta(scale_trap[1,itrap],scale_trap[2,itrap]),min_trap[itrap],max_trap[itrap])
    loga[itrap]<-log(a[itrap])
  }
  for (icatch in 1:nbcatch){
    p[icatch]~T(dbeta(scale_catch[1,icatch],scale_catch[2,icatch]),min_catch[icatch],max_catch[icatch])
    logp[icatch]<-log(p[icatch]) 
  }
  
  #precisionpropRwalk~dunif(0.5,1)
  
  
  
  sdRglob ~ T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  tauRglob <- 1/sdRglob^2
  
  
  for (isurvey in 1:nbsurvey){
    tauIA[isurvey] <- sdIA[isurvey]
    sdIA[isurvey]~ T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  }
  for (itrap in 1:nbtrap){
    tauIP[itrap] <- 1/sdIP[itrap]^2
    sdIP[itrap]~T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  }
  
  for (iabsolute in 1:nbabsolute){
    tauU[iabsolute] <- 1/sdU[iabsolute]^2
    sdU[iabsolute]~T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  }
  for (icatch in 1:nbcatch){
    tauIE[icatch]<-1/sdIE[icatch]^2
    sdIE[icatch]~T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  }
  
  sdq ~T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  tauq <- 1/sdq^2
  sdRwalk ~ T(dt(df=1,mu=0,sigma=2.5),0.001,1)
  tauRwalk <- 1/sdRwalk^2
  tauLocal <- 1/sdLocal
  sdLocal ~ T(dt(df=1,mu=0,sigma=2.5),0.001,1)
})
