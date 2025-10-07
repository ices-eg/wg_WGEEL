fit_modele_benezech <- function(dat = dat_ge, area = "Elsewhere Europe", model_path){
  donneeUtilisee <- dat_ge$p_std_1960_1979[dat_ge$area == area & dat_ge$year >= 1980] 
  donneeUtilisee <- donneeUtilisee / donneeUtilisee[1] * 100
  recrutement <- donneeUtilisee
  
  utillast <- donneeUtilisee[length(donneeUtilisee)]
  recrutementlast <- recrutement[length(donneeUtilisee)]
  
  donneeUtilisee <- donneeUtilisee[-length(donneeUtilisee)]
  recrutement <- recrutement[-length(recrutement)]
  
  dernier_recrutement <- recrutement [length(recrutement)]
  
  IR <- recrutement 
  
  
  Tterminal <- length(IR)
  IR_terminal <- dernier_recrutement
  
  adapt = 1000
  burnin = 20000
  sample = 70000
  thin = 9 
  ir <- c(IR[seq_len(Tterminal)], rep(NA, 3))
  ir_terminal <- IR[Tterminal]
  modele <- list(modele_path = model_path, 
                 inits = list(sdwalkpente = 0.1, taue = 1/0.1^2, tau_IR = 1/0.1^2, 
                              n = stats::runif(Tterminal + 3, -1, 1), e = stats::runif(Tterminal + 
                                                                                         3, -1, 1), log_IR0 = 1, a0 = 0), data = list(T = Tterminal, 
                                                                                                                                      IR = ir), 
                 monitor = c("IR"))
  result_censure <- (runjags::run.jags(modele$modele_path, data = modele$data, 
                                       monitor =modele$monitor, n.chains = 3, burnin = burnin, sample = sample, 
                                       adapt = adapt, thin = thin, summarise = FALSE, inits = modele$inits, 
                                       method = "parallel"))
  
  
  library(coda)
  tmp <- as.matrix(as.mcmc.list(result_censure))  
  
  sum(tmp[,paste0("IR[",Tterminal+1,"]")]<=recrutementlast)/nrow(tmp)
  
  
  
}