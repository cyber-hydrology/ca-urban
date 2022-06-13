library(raster);library(tictoc);library(sp)
setwd('C:/Users/82105/Documents/cellularAutomata/CA_model_OCC_220412')
source('Neighbor_mat_OCC.R');source('STRG_surflow2.R');source('Transition_fun2.R')
asc_file <- raster("clipped_raster_4m_big2.asc")
range_raster <- as.matrix(extent(asc_file))
# x11()
plot(asc_file)
dem <- as.matrix(asc_file$clipped_raster_4m_big2)
dem <- dem - min(dem, na.rm = T)
x_dem <- seq(from=range_raster[1,1], to=range_raster[1,2],length = ncol(dem))
y_dem <- seq(from=range_raster[2,2], to=range_raster[2,1],length = nrow(dem))
min(dem, na.rm = T); max(dem, na.rm = T)

##################################################################################################################################
# Scale transition ###############################################################################################################
##################################################################################################################################
hour_to_sec <- c(3600)
m_to_mm <- c(1000)
cm_to_mm <- c(10)


##################################################################################################################################
# Cellular Automata Setting ######################################################################################################
##################################################################################################################################
##### Time parameter setting for CA calculation
# The units of all values, calculations, functions are based on seconds for time scale and mm for space scale
flowdir <- c("D4") # D8, D4, 4+4N
time_step <- c(30) # [seconds] Time step for iteration
time_interval <- c(450) # [seconds] Time interval in observation data

##### Matrix setting for CA calculation ##########################################################################################
num_col <- ncol(dem); num_row <- nrow(dem)
resolution_cell <- c(floor(res(asc_file))[1]*m_to_mm) #[mm]; 
sur_dem <- dem*m_to_mm; # [mm]
rownames(sur_dem) <- y_dem;colnames(sur_dem) <- x_dem
sur_waterdepth_dem <- matrix(0, num_row, num_col) # [mm]
rownames(sur_waterdepth_dem) <- y_dem;colnames(sur_waterdepth_dem) <- x_dem
sur_cellheight_dem <- matrix(NA, num_row, num_col) # [mm]
rownames(sur_cellheight_dem) <- y_dem; colnames(sur_cellheight_dem) <- x_dem
sur_storage_dem    <- matrix(NA, num_row, num_col) # [mm]
rownames(sur_storage_dem) <- y_dem; colnames(sur_storage_dem) <- x_dem
theta_Res_Sur_dem    <- matrix(NA, num_row, num_col) # [mm]
rownames(theta_Res_Sur_dem) <- y_dem; colnames(theta_Res_Sur_dem) <- x_dem
theta_Sat_Sur_dem    <- matrix(NA, num_row, num_col) # [mm]
rownames(theta_Sat_Sur_dem) <- y_dem; colnames(theta_Sat_Sur_dem) <- x_dem

##### Parameters in Waterbalance setting #########################################################################################
Date_data <- c(120928)
hydro_data <- read.csv(paste0('runoffEvent_',Date_data,'_sample.csv'))
hydro_data$Rain <- hydro_data$Rain*10
manning_coeff_sur <- c(0.035);
LAI <- c(3.76) # Leaf Area Index
P_max <- 0.935+0.498*LAI+0.00575*LAI^2 # [mm]
i_init  <- c(2.30) # [mm/hr]
i_final <- c(0.49) # [mm/hr]
i_decay <- c(1.58) # [mm/hr]
Evptr <- c(0) # [mm/hr]
R_cum <- c(0)  # [mm]
P_pre <- c(0)  # [mm]
Intercep_Total <- c(0)  # [mm]
Infiltra_Total <- c(0)  # [mm]
Runoff_Total   <- c(0)  # [mm]

##### Setting for soil texture characteristics ###################################################################################
#SoilText_Mat <- read.csv("GL_SoilText.csv")
#SoilText_Mat <- cbind(SoilText_Mat, t(hydro_data[1,grep("10", colnames(hydro_data))]),
#                      t(hydro_data[1,grep("30", colnames(hydro_data))]))
#dem_soiltext <- matrix(NA, nrow(dem), 9)
#colnames(dem_soiltext) <- c(colnames(SoilText_Mat)[2:8],"ASM_10","ASM_30")
#dem_soiltext[,1] <- dem[,1]; dem_soiltext[,2] <- dem[,2]
#order_dist <- sapply(1:nrow(dem), 
#                     function(i) which.min(sapply(1:nrow(SoilText_Mat),
#                     function(j) sqrt((dem[i,1]-SoilText_Mat[j,2])^2 + (dem[i,2]-SoilText_Mat[j,3])^2))))
#for(k in 3:9){
#  dem_soiltext[,k] <- sapply(1:nrow(dem), function(i) SoilText_Mat[order_dist[i],k+1])
#}
#colnames(dem_soiltext)
#dem_soiltext[,8] <- rep(mean(SoilText_Mat[,9]), nrow(dem)) # Average of surface sm setting
#dem_soiltext[,9] <- rep(mean(SoilText_Mat[,10]), nrow(dem)) # Average of subsurface sm setting
#dem_soiltext <- as.data.frame(dem_soiltext)

##### Parameters in STRG_surflow  ################################################################################################
K_Sur=c(0.3);  
Depth_Sur=c(5)*cm_to_mm; # [cm] Soil depth
E_Sat_Sur_cons_val <- c(60) # Effective saturation must exceed 0

E_Sat_Sur_cons = rep(E_Sat_Sur_cons_val, num_row); 
dir.create(paste0(getwd(),"/Plot/Plots_",flowdir,time_step,"sec_0",K_Sur*100,'K',E_Sat_Sur_cons_val,'%E_Sat'))
setwd(paste0(getwd(),"/Plot/Plots_",flowdir,time_step,"sec_0",K_Sur*100,'K',E_Sat_Sur_cons_val,'%E_Sat'))

##### Setting for initial conditions of soil texture, water balance ##############################################################
residual_sm_sur <- c(5) #[vol.%]
saturated_sm_sur <- c(50) #[vol.%]
average_sm_sur <- c(25) #[vol.%]
for(j in num_row:1){
for(i in 1:num_col){
    if(is.na(dem[j,i])){
      next
    }
    sur_storage_dem[j,i]   <- average_sm_sur # [vol.%]
    theta_Sat_Sur_dem[j,i] <- saturated_sm_sur # [vol.%]
    theta_Res_Sur_dem[j,i] <- residual_sm_sur # [vol.%]
  }}

##### Setting for boundary conditions including discharge, left, right sides #####################################################
# stream <- c(3,-2.5)
# y_str <- which(rownames(sur_updatecell_dem)==stream[2])
# x_str <- which(colnames(sur_updatecell_dem)==stream[1])
# sur_storage_dem[y_str,x_str] <- hydro_data$WL[1]
# sur_storage_dem[y_str,x_str] <- c(0)

##### Setting for results matrix of runoff time series data ######################################################################
# asm_hydro_data <- hydro_data[1,]
hydro_data <- hydro_data[-1,]
runoff_timeseries <- matrix(NA, 6, nrow(hydro_data)); 
rownames(runoff_timeseries) <- c('order','obs_runoff[m]','obs_runoff[m/s]','cal_sur_runoff[m]',
                                 'cal_tot_runoff[m]','cal_tot_runoff[m/s]')
runoff_timeseries[1,] <- c(1:nrow(hydro_data))
runoff_timeseries[2,] <- hydro_data$WL # [m]
runoff_timeseries[3,] <- (3*10^(-5))*exp(36.139*hydro_data$WL) # [m3/s]
runoff_timeseries[4:5,1] <- runoff_timeseries[2,1]
runoff_timeseries[6,1] <- runoff_timeseries[3,1]

##### Setting for results matrix of soil moisture time series data ###############################################################
# sur_sm_timeseries <- matrix(NA, nrow(SoilText_Mat)*2, nrow(hydro_data))
# rownames(sur_sm_timeseries) <- c(rownames(SoilText_Mat), paste0("pred_",rownames(SoilText_Mat)))
# sur_sm_timeseries[1:nrow(SoilText_Mat),] <- t(hydro_data[,grep("10", colnames(hydro_data))])
# sur_sm_timeseries[22:42,1] <- sur_sm_timeseries[1:21,1]
##################################################################################################################################
# Cellular Automata Calculation ##################################################################################################
##################################################################################################################################
for(time in 1:c(nrow(hydro_data)*time_interval/time_step)){
  #for(time in 1:10800){
  #tic()
  ################################################################################################################################
  ##### Hydrological components ##################################################################################################
  ################################################################################################################################
  
  ##### Rainfall [mm] 
  R_t <- (hydro_data$Rain[ceiling(time*time_step/time_interval)]/time_interval)*(time_step)

  ##### Evapotranspiration [mm]
  ET_t <- Evptr*(time_step/hour_to_sec)
  
  ##### Interception [mm/hr]
  R_cum <- R_cum+R_t
  P_cum <- P_max*(1-exp(-0.046*LAI*R_cum/P_max))
  P_t <- P_cum - P_pre
  P_pre <- P_cum
  Intercep_Total <- Intercep_Total + P_t
  
  ##### Infiltration [mm]
  I_t <- (i_final + (i_init-i_final)*exp(-i_decay*time_step/hour_to_sec))*(time_step/hour_to_sec)
  Infiltra_Sum <- c(0)
  
  ##### Effective rainfall
  R_eff <- R_t - P_t - ET_t
  #x <- c(40); y <- c(40)
  ################################################################################################################################
  ##### Set-up for DEM matrix ####################################################################################################
  ################################################################################################################################
  for(y in 1:num_row){
  for(x in 1:num_col){
      
      if(is.na(dem[y,x])){
        next
      }
      
      R_Sur <- sur_storage_dem[y,x] + sur_waterdepth_dem[y,x]
      STRG_mat <- STRG_sur2(R_eff, I_t, K_Sur, R_Sur, 
                           E_Sat_Sur_cons[y], Depth_Sur, 
                           theta_Res_Sur_dem[y,x], theta_Sat_Sur_dem[y,x])
      sur_storage_dem[y,x] <- STRG_mat[1,1]; # soil moisture
      sur_waterdepth_dem[y,x] <- STRG_mat[1,2]; # water depth for runoff
      Infiltra_Sum <- Infiltra_Sum + STRG_mat[1,3] # infiltration 
      #print(STRG_mat[1,2])
    }}
  
  sur_waterdepth_dem[nrow(sur_dem),] <- c(0) # discharge at bottom area
  sur_waterdepth_dem[1,] <- c(0) # discharge at top area
  sur_waterdepth_dem[,ncol(sur_dem)] <- c(0) # discharge at right area
  sur_waterdepth_dem[,1] <- c(0) # discharge at left area

  Infiltra_Total <- Infiltra_Total + (Infiltra_Sum/(num_row * num_col)) # Infiltration update
  sur_cellheight_dem <- sur_dem + sur_storage_dem + sur_waterdepth_dem # Cellheight update
  sur_updatecell_dem <- matrix(0, num_row, num_col) # Updatecell update
  rownames(sur_updatecell_dem) <- as.numeric(rownames(sur_dem))
  colnames(sur_updatecell_dem) <- as.numeric(colnames(sur_dem))
  
  ################################################################################################################################
  ##### Surface flow routing algorithm ###########################################################################################
  ################################################################################################################################
  for(y in 1:num_row){
  for(x in 1:num_col){
        if(is.na(dem[y,x]) || sur_waterdepth_dem[y,x] <= c(0)){
          next
        }
        sur_neighbor_cell <- matrix(NA, 6, 9); 
        colnames(sur_neighbor_cell) <- c('upleft','up','upright','left','point','right','doleft','do','doright')
        sur_neighbor_cell <- Neighbor_mat(x,y,num_col,num_row,sur_neighbor_cell,
                                          sur_dem,sur_cellheight_dem,sur_waterdepth_dem)
        sur_point_cell <- as.matrix(sur_neighbor_cell[,5]); sur_neighbor_cell <- sur_neighbor_cell[,-5]
        sur_updatecell_dem <- Transition_fun2(flowdir,manning_coeff_sur,resolution_cell,
                                             time_step,sur_neighbor_cell,sur_point_cell,sur_updatecell_dem)
  }}
  ################################################################################################################################
  ##### Export PNG file for water depth ##########################################################################################
  ################################################################################################################################
 # x11()
  #rast <- raster(sur_updatecell_dem)
  #extent(rast) <- c(c(min(dem$X)+0.5),max(dem$X),c(min(dem$Y)+0.5),max(dem$Y))
  #projection(rast) <- CRS("+proj=longlat +datum=WGS84")
  #plot(rast, col=terrain.colors(30), main="sur_updatecell_dem")
  png(paste0(time_step,"sec_",time,"_plot.png"),width=4000,height=2000,res=200)
  layout(matrix(c(1,2,3,4), 2, 2, byrow=F))
  rast <- raster(sur_dem)
  plot(rast, col=terrain.colors(30), main="sur_dem")
  rast <- raster(sur_storage_dem)
  plot(rast, col=terrain.colors(30), main="sur_Strg")
  rast <- raster(sur_waterdepth_dem)
  plot(rast, col=terrain.colors(11), main="sur_waterdepth_dem",breaks=c(0,400,800,1200,1600,2000,2400,2800,3200,3600,4000))
  rast <- raster(sur_updatecell_dem)
  plot(rast, col=terrain.colors(30), main="sur_updatecell_dem")
  dev.off()

  ################################################################################################################################
  ##### Undating waterdepth and check error ######################################################################################
  ################################################################################################################################
  sur_waterdepth_dem <- sur_updatecell_dem + sur_waterdepth_dem; 
  if(c(min(sur_waterdepth_dem)+0.0001) < c(0) ){
    print("there is negative values in waterdepth")
    break
  }
  
  # Runoff_Total <-
  #   Runoff_Total+(3*10^(-5))*exp(36.139*c(sur_waterdepth_dem[y_str,x_str]/m_to_mm))*time_step # [m3]
  ################################################################################################################################
  ##### Write water balance values ###############################################################################################
  ################################################################################################################################
  #if((time*time_step/time_interval) - floor(time*time_step/time_interval) == 0){
    
    ##### updating runoff time series 
  #  runoff_timeseries[4,c(floor(time*time_step/time_interval))] <- c(sur_waterdepth_dem[y_str,x_str])/m_to_mm # [m]
  #  runoff_timeseries[5,c(floor(time*time_step/time_interval))] <- c(sur_waterdepth_dem[y_str,x_str])/m_to_mm # [mm]
  #  runoff_timeseries[6,c(floor(time*time_step/time_interval))] <- 
  #                       c(3*10^(-5))*exp(36.139*runoff_timeseries[4,c(floor(time*time_step/time_interval))]) # [m3/s]
    
    ##### updating soil moisture time series
  #  for(t in 1:c(nrow(sur_sm_timeseries)/2)){
  #    sm_y_point <- which.min(abs(SoilText_Mat$y[t] - as.numeric(rownames(sur_cellheight_dem))))
  #    sm_x_point <- which.min(abs(SoilText_Mat$x[t] - as.numeric(colnames(sur_cellheight_dem))))
  #    sur_sm_timeseries[21+t, c(floor(time*time_step/time_interval))] <- 
  #                        c(sur_waterdepth_dem[sm_y_point,sm_x_point] + sur_storage_dem[sm_y_point,sm_x_point]) # [mm]
  # }
  #}
  
  # print(time_step * time)
  # if(R_t == c(0) && max(sur_updatecell_dem) == c(0) && max(sur_waterdepth_dem) == c(0) ){
  #   break
  # }

}

Rain_space <- sum((hydro_data$Rain/m_to_mm)*ncol(sur_dem)*(resolution_cell/m_to_mm)*nrow(sur_dem)*(resolution_cell/m_to_mm)) # [m3]
Intercep_space  <- 
  sum((Intercep_Total/m_to_mm)*ncol(sur_dem)*(resolution_cell/m_to_mm)*nrow(sur_dem)*(resolution_cell/m_to_mm)) # [m3]
Infiltra_space  <- 
  sum((Infiltra_Total/m_to_mm)*ncol(sur_dem)*(resolution_cell/m_to_mm)*nrow(sur_dem)*(resolution_cell/m_to_mm)) # [m3]


# Runoff_space_cal  <- Runoff_Total # [m3]
# runoff_diff <- runoff_timeseries[2,] - runoff_timeseries[2,1]
# runoff_flowrate <- (3*10^(-5))*exp(36.139*runoff_diff)
# Runoff_space_obs <- sum(runoff_flowrate[runoff_flowrate>0])*length(runoff_diff[runoff_diff>0])*time_interval # [m3]

##################################################################################################################################
# Cellular Automata Outputs ######################################################################################################
##################################################################################################################################
setwd('C:/Users/82105/Documents/cellularAutomata/CA_model_OCC_220412')
water_balance_mat <- matrix(NA, 1, 5)
colnames(water_balance_mat) <- c('Rainfall[m3]','Interception[m3]','Infiltration[m3]',
                                 'Observed runoff[m3]','Calculated runoff[m3]')
water_balance_mat[1,] <- c(round(Rain_space,2),round(Intercep_space,2),round(Infiltra_space,2),
                           round(Runoff_space_obs,2),round(Runoff_space_cal,2))

# sur_sm_timeseries <- cbind(rbind(t(asm_hydro_data[1,grep("10", colnames(hydro_data))]),
#                            t(asm_hydro_data[1,grep("10", colnames(hydro_data))])),sur_sm_timeseries)
# 
# runoff_timeseries <- cbind(c(0,asm_hydro_data$WL,c(3*10^(-5))*exp(36.139*asm_hydro_data$WL),asm_hydro_data$WL,
#                              asm_hydro_data$WL,c(3*10^(-5))*exp(36.139*asm_hydro_data$WL)),runoff_timeseries)

write.csv(water_balance_mat,
          paste0(getwd(),'/Results/WaterBudget_',time_step,"sec_0",K_Sur*100,'K',E_Sat_Sur_cons_val,'%E_Sat.csv'))
write.csv(runoff_timeseries,
          paste0(getwd(),'/Results/runoff_timeseries_',time_step,"sec_0",K_Sur*100,'K',E_Sat_Sur_cons_val,'%E_Sat.csv'))
write.csv(sur_sm_timeseries,
          paste0(getwd(),'/Results/sur_sm_timeseries_',time_step,"sec_0",K_Sur*100,'K',E_Sat_Sur_cons_val,'%E_Sat.csv'))
CA_results <- 
  list("Water_balance_mat"=water_balance_mat,"Runoff_timeseries"=runoff_timeseries,"SM_timeseries"=sur_sm_timeseries)
# toc()

