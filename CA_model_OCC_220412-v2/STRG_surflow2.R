STRG_sur2 <- function(R_eff, I_t, K_Sur, R_Sur,
                        E_Sat_Sur_cons, Depth_Sur, 
                        theta_Res_Sur, theta_Sat_Sur) {
  
  #E_Sat_Sur_cons =  E_Sat_Sur_cons[y]  #[vol.%]
  #theta_Res_Sur = theta_Res_Sur_dem[y,x] #[vol.%]
  #theta_Sat_Sur = theta_Sat_Sur_dem[y,x] #[vol.%]
  
  
################################################################################
Res_Sur  <- R_Sur + R_eff
theta_Sur <- Res_Sur / Depth_Sur * 100 # vol.% soil moisture
E_Sat_Sur <- (theta_Sur - theta_Res_Sur) / (theta_Sat_Sur - theta_Res_Sur) * 100
if(E_Sat_Sur > E_Sat_Sur_cons){
  I_t <- I_t
}else{
  I_t <- c(0)
}
################################################################################
Res_Sur  <- R_Sur + R_eff - I_t #[mm]
theta_Sur <- Res_Sur / Depth_Sur * 100  #[vol.%]
E_Sat_Sur <- (theta_Sur - theta_Res_Sur) / (theta_Sat_Sur - theta_Res_Sur) * 100

if(theta_Sur > theta_Sat_Sur){
  Flow_Sur = Res_Sur - c(theta_Sat_Sur*Depth_Sur/100) #[mm]
}else if(E_Sat_Sur > E_Sat_Sur_cons){
  Flow_Sur = K_Sur * Res_Sur #[mm]
}else{
  Flow_Sur = c(0)
}

Res_Sur  <- Res_Sur - Flow_Sur
################################################################################
STRG_mat <- matrix(NA, 1, 3)
colnames(STRG_mat) <- c('R_Sur', 'Q_Sur', 'Infil')
################################################################################
STRG_mat[1,] <- c(Res_Sur, Flow_Sur, I_t)
return(STRG_mat)
}