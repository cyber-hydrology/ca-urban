Transition_fun2 <- function(flowdir, manning_coeff, resolution_cell, time_step, neighbor_cell, point_cell, updatecell_dem){
  
  manning_coeff <- manning_coeff_sur
  neighbor_cell <- sur_neighbor_cell
  point_cell <- sur_point_cell
  updatecell_dem <- sur_updatecell_dem
  
  # Calculation for 8N or 4N
  if(flowdir == c("D4")){
    neighbor_cell[2,c(1,3,6,8)] <- NA
  }
  
  # Comparison with raw height of point 
  neighbor_cell[2,which(as.numeric(neighbor_cell[2,])>=as.numeric(point_cell[2,1]))] <- NA
  
  # Comparison with average height 
  for(iter in 1:8){
    n <- length(neighbor_cell[2,])-sum(is.na(neighbor_cell[2,]))
    ave_Height <- c(sum(as.numeric(neighbor_cell[2,]), na.rm=T)+as.numeric(point_cell[2,1]))/c(n+1)
    neighbor_cell[2,which(as.numeric(neighbor_cell[2,])>=as.numeric(ave_Height))] <- NA
    if(length(which(neighbor_cell[2,] >= as.numeric(ave_Height)))==c(0)){break}
  }
  
  # Calculation for 8N or 4+4N
  if(flowdir == c("4+4N")){
    if(sum(is.na(neighbor_cell[2,c(2,4,5,7)])) < 4){
      neighbor_cell[2,c(1,3,6,8)] <- NA
    }}
  
  ##### Second transition rule #################################################################################
  ##### Calculation of flow rate ###############################################################################
  
  # Check remaining neighbor cell and water depth
  if(sum(is.na(neighbor_cell[2,]))!=c(8)){
    flow_total  <- c(0); flow_amount <- c(0)
    
    # selection of remaining neighbor cell
    cal_neighbor_cell <- as.matrix(neighbor_cell[,complete.cases(neighbor_cell[2,])])
    flow_neighbor_cell <- which(neighbor_cell[2,] > 0)
    ###########################################
    for(p in 1:length(flow_neighbor_cell)){
      # p<- c(1)
      #if(cal_neighbor_cell[1,p]=="D"){
      if(flow_neighbor_cell==c(1)||flow_neighbor_cell==c(3)||flow_neighbor_cell==c(6)||flow_neighbor_cell==c(8)){
        distance <- sqrt(2)*resolution_cell
      }else{
        distance <- resolution_cell
      }
      
      # calculating flow travel time based on Manning equation
      H_1 <- as.numeric(cal_neighbor_cell[2,p]);
      H_0 <- as.numeric(point_cell[2,]);
      h_0 <- as.numeric(point_cell[3,]);
      cal_neighbor_time <- (manning_coeff*distance)/((h_0^2/3)*sqrt((H_0-H_1)/distance))
      
      # checking whether sufficient time for flowing or not.
      if(time_step < cal_neighbor_time){
        flow_amount <- (ave_Height-H_1)*(time_step/cal_neighbor_time)
      }else{
        flow_amount <- (ave_Height-H_1)
      }
      cal_neighbor_cell[4,p] <- flow_amount
      flow_total <- flow_total + flow_amount
    }
    ###########################################
    # checking whether sufficient water for flowing or not.
    if(h_0 < flow_total){
      for(p in 1:length(flow_neighbor_cell)){
        cal_neighbor_cell[4,p] <- as.numeric(cal_neighbor_cell[4,p])*(h_0/flow_total)
      }
    }else{
      for(p in 1:length(flow_neighbor_cell)){
        cal_neighbor_cell[4,p] <- as.numeric(cal_neighbor_cell[4,p])
      }
    }
    
    # calculating flow amounts from point cell to each neighbor cell
    for(q in 1:length(flow_neighbor_cell)){
      neighbor_cell[,flow_neighbor_cell[q]] <- cal_neighbor_cell[,q]
    }
    ##### Third transition rule #################################################################################
    ##### updating surface cell state ###########################################################################
    for(r in 1:ncol(cal_neighbor_cell)){
      y_loc <- which(rownames(updatecell_dem)==cal_neighbor_cell[5,r])
      x_loc <- which(colnames(updatecell_dem)==cal_neighbor_cell[6,r])
      updatecell_dem[y_loc,x_loc] <- updatecell_dem[y_loc,x_loc]+as.numeric(cal_neighbor_cell[4,r])
    }
    
    y_point <- which(rownames(updatecell_dem)==point_cell[5,1])
    x_point <- which(colnames(updatecell_dem)==point_cell[6,1])
    updatecell_dem[y_point,x_point] <- updatecell_dem[y_point,x_point]-sum(as.numeric(cal_neighbor_cell[4,]))
  }
  return(updatecell_dem)
  #return(neighbor_cell)
}
