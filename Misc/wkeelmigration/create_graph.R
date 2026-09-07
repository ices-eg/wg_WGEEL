library(ggplot2)
library(dplyr)

palette = c("#3B4CC0", "#5A5BD6", "#7A4CCF", "#A23DBA",
            "#C23C9A", "#D8576B", "#E57C3A", "#EFAE2E",
            "#D6C92F", "#9DBA3A", "#4FB08B", "#3BA3C6")
            
months = c("Jan", "Feb", "Mar", "Apr", "May",
           "Jun", "Jul", "Aug", "Sep", "Oct",
           "Nov", "Dec")
get_coordinates <- function(xcenter, ycenter, month, l) {
  x1 <- xcenter + l * sin(2*pi * (month-1) /12+0.05)
  y1 <- ycenter + l * cos(2*pi * (month-1) /12+0.05)
  x2 <- xcenter + l * sin(2*pi * (month) /12-0.05)
  y2 <- ycenter + l * cos(2*pi * (month) /12-0.05)
  
  return(data.frame(x = x1, y = y1, xend = x2, yend = y2, xcenter = xcenter, ycenter = ycenter, month = month, l = l))
}


get_coordinates2 <- function(xcenter, ycenter, month, l) {
  if (is.nan(l)) l <- 0
  x1 <- xcenter + l * sin(2*pi * (month-1) /12+0.05)
  y1 <- ycenter + l * cos(2*pi * (month-1) /12+0.05)
  x2 <- xcenter + l * sin(2*pi * (month) /12-0.05)
  y2 <- ycenter + l * cos(2*pi * (month) /12-0.05)
  
  res <- data.frame(x = c(x1,x2,xcenter), y = c(y1,y2,ycenter), month = month, l = l)
  res
  
  
}

format_pattern <- function(dat, multiplier = 200000, keep_period = FALSE){
  coords_col = c("ser_x", "ser_y")
  if ("emu_x" %in% names(dat)) coords_col = c("emu_x", "emu_y")
  dat <- st_as_sf(dat,coords=coords_col, crs = 4326) |>
    st_transform(3035) 
  dat$x <- st_coordinates(dat)[, 1]
  dat$y <- st_coordinates(dat)[, 2]
  
  
  poly <- data.frame()
  if ("ser_nameshort" %in% names(dat)){
    poly <- data.frame(ser_nameshort=rep(dat$ser_nameshort,
                                         each = 3))
  } else {
    poly <- data.frame(emu_nameshort=rep(dat$emu_nameshort,
                                         each = 3))
  }
  if (keep_period){
    poly$period <- rep(dat$period,
                       each = 3)
  }
    
  
  cbind.data.frame(bind_rows(mapply(get_coordinates2,
         dat$x, dat$y, dat$das_month, dat$das_value * multiplier,
         SIMPLIFY = FALSE)),
         poly)
}



tmp=mapply(xcenter = rep(0,12), ycenter = rep(0,12),
       month = 1:12, l= rep(1,12), FUN = get_coordinates, SIMPLIFY = FALSE) %>% bind_rows() 

tmp2=mapply(xcenter = rep(0,12), ycenter = rep(0,12),
           month = 1:12, l= rep(1,12), FUN = get_coordinates2, SIMPLIFY = FALSE) %>% bind_rows() 

ggplot(tmp)  + 
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend, col = as.factor(month),
                   )) +
  scale_color_manual("Manual", values = palette, labels = )


ggplot(tmp2)  + 
  geom_polygon(aes(x = x, y = y,
                   col = as.factor(month),
                   fill = as.factor(month)),
               alpha = .3) +
  scale_color_manual("Month", values = palette, labels = months) +
  scale_fill_manual("Month", values = palette, labels = months)
                              
