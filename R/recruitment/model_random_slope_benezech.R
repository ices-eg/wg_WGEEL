# Recruitment random slope model
# doi: 10.1016/j.fishres.2023.106915
###############################################################################

model <- "
model {

# Intialisation : year 1
# ======================
	IR[1] ~ dlnorm(mu_IR[1], tau_IR)
	a[1] <- a0 
	mu_IR[1] <- log_IR0 
	eta[1] <- log(IR[1]) - mu_IR[1]
	residu[1] <- eta[1] / tau_IR


# Formulation : from year t-1
# ********************************
# Years 2 à T+3
# ==========================
	for (t in 2:T) {
		IR[t] ~ dlnorm(mu_IR[t], tau_IR)
		#mu_IR[t] <- mu_IR[t-1] + a[t-1] + rho*(eta[t-1]) + e[t] #with autocorrelation
    mu_IR[t] <- mu_IR[t-1] + a[t] + e[t] #without autocorrelation
    a[t] <- a[t-1] + n[t]
		eta[t] <- log(IR[t]) - mu_IR[t]
		residu[t] <- eta[t] / tau_IR
	}


#then, for following time steps, we use the initial loop
	for (t in (T+1):(T+3)) {
		IR[t] ~ dlnorm(mu_IR[t], tau_IR)
		#mu_IR[t] <- mu_IR[t-1] + a[t-1] + rho*(eta[t-1]) + e[t] #with autocorrelation
    mu_IR[t] <- mu_IR[t-1] + a[t]  + e[t] #without autocorrelation
    a[t] <- a[t-1] + n[t] 
		eta[t] <- log(IR[t]) - mu_IR[t]
		residu[t] <- eta[t] / tau_IR
	}


# Priors
	tau_IR ~ dgamma(0.01,0.01) T(1,)
	
	a0 ~ dnorm(0,0.01)

  log_IR0 ~ dnorm(0,0.01)

	s_IR <- pow(tau_IR,-0.5)
	
  sdwalkpente~dunif(0.001,.5)
  tauwalpente <- tau_IR/signalnoise_slope

  signalnoise_mu <- tau_IR/taue
  signalnoise_slope <- pow(signalnoise_mu*0.5,2)
  

  taue ~ dgamma(0.01,0.01) T(1,)

for (t in 1:(T+3)){
  n[t] ~ dnorm(0,tauwalpente) T(-5,5)
  e[t] ~ dnorm(0, taue) T(-5,5)

}


}
"
