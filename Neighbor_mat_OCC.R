Neighbor_mat <- function(x,y,num_col,num_row,neighbor_cell,surface_dem, cellheight_dem, waterdepth_dem) {
  
if(x==c(1)&&y>c(1)&&y<c(num_row)){
    cell_arr <- c(2,3,5,6,8,9); k <- c(1)
    for(j in c(y-1):c(y+1)){
      for(i in c(x):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        
        k <- k+1
      }}
  }else if(x==c(1)&&y==c(1)){
    cell_arr <- c(5,6,8,9); k <- c(1)
    for(j in c(y):c(y+1)){
      for(i in c(x):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}
  }else if(x==c(1)&&y==c(num_row)){
    cell_arr <- c(2,3,5,6); k <- c(1)
    for(j in c(y-1):c(y)){
      for(i in c(x):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}
  }else if(x==c(num_col)&&y>c(1)&&y<c(num_row)){
    cell_arr <- c(1,2,4,5,7,8); k <- c(1)
    for(j in c(y-1):c(y+1)){
      for(i in c(x-1):c(x)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}
  }else if(x==c(num_col)&&y==c(1)){
    cell_arr <- c(4,5,7,8); k <- c(1)
    for(j in c(y):c(y+1)){
      for(i in c(x-1):c(x)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}
  }else if(x==c(num_col)&&y==c(num_row)){
    cell_arr <- c(1,2,4,5); k <- c(1)
    for(j in c(y-1):c(y)){
      for(i in c(x-1):c(x)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}
  }else if(y==c(1)&&x>c(1)&&x<c(num_col)){
    cell_arr <- c(4,5,6,7,8,9); k <- c(1)
    for(j in c(y):c(y+1)){
      for(i in c(x-1):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}  
  }else if(y==c(num_row)&&x>c(1)&&x<c(num_col)){
    cell_arr <- c(1,2,3,4,5,6); k <- c(1)
    for(j in c(y-1):c(y)){
      for(i in c(x-1):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}   
  }else{
    cell_arr <- c(1,2,3,4,5,6,7,8,9); k <- c(1)
    for(j in c(y-1):c(y+1)){
      for(i in c(x-1):c(x+1)){
        neighbor_cell[2,cell_arr[k]] <- as.numeric(cellheight_dem[j,i]) 
        neighbor_cell[3,cell_arr[k]] <- as.numeric(waterdepth_dem[j,i])
        neighbor_cell[5,cell_arr[k]] <- as.numeric(rownames(surface_dem)[j])
        neighbor_cell[6,cell_arr[k]] <- as.numeric(colnames(surface_dem)[i])
        k <- k+1
      }}}
    return(neighbor_cell)
}