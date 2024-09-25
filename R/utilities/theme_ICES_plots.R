theme_ICES_plots <-
  function(
    type = c("Catches", "Recruitment", "F", "SSB", "quality_SSB", "quality_F", "quality_R")) {
    font <- "Gothic A1, sans-serif"#"Calibri, sans-serif" # assign font family up front
    tmp <- theme_minimal() %+replace% # replace elements we want to change
      
      theme(
        axis.title = element_text( # axis titles
          family = font, # font family
          size = 18,
          colour = "darkgrey",
          vjust = -2
        ),
        axis.text = element_text( # axis titles
          family = font, # font family
          size = 13,
          colour = "black"
        ),
        axis.title.x = element_blank(),
        
        panel.grid.major.y = element_line(
          colour = "grey",
          size = 1,
          linetype = "solid",
        ),
        plot.title = element_text( # title
          family = font, # set font family
          size = 21, # set font size
          face = "bold", # bold typeface
          hjust = 0, # left align
          vjust = 1,
          margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0),
          if (type == "Catches") {
            color <- "#002b5f"
          } else if (type == "Recruitment" | type == "quality_R") {
            color <- "#28b3e8"
          } else if (type == "F" | type == "quality_F") {
            color <- "#ed5f26"
          } else if (type == "SSB" | type == "quality_SSB") {
            color <- "#047c6c"
          }
        ),
        axis.line = element_line(size = 1, colour = "black"),
        axis.ticks = element_line(size = 1, color="black"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_rect(
          colour = "black",
          fill = NA,
          size = 0.5
        ),
        legend.text = element_text(
          family = "sans-serif",
          size = 15,
          color = "black"
        ),
        legend.title = element_blank(),
        legend.position = "bottom"
        
      )
    
    if (type == "Catches") {
      
      if (is.null(title)) {
        title <- "Catches"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("Catches in 1000 %s", dplyr::last(df$Units))
      }
      
      if (is.null(ymax)) {
        limits <- expand_limits(y = 0)
      } else {
        limits <- expand_limits(y = c(0, ymax))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = ylegend
        ),
        scale_fill_manual(values = c(
          "Landings" = "#002b5f",
          "Discards" = "#fda500",
          "Catches" = "#002b5f",
          "Industrial Bycatch" = "#00b29d",
          "Unallocated_Removals" = "#6eb200",
          "Down-weighted Catches" = "#6eb5d2"
        )),
        limits,
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = function(l) {
            trans <- l / 1000
          }
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "Recruitment") {
      

      theme_ICES_plots <- list(
        tmp,
        scale_fill_manual(values = c("#28b3e8")),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "F") {
      if (is.null(title)) {
        title <- "Fishing pressure"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title, #"Fishing pressure", # sprintf("Recruitment <sub>(age %s)</sub>", dplyr::last(df$RecruitmentAge)),
          y = ylegend, #sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge)), # sprintf("Catches in 1000 %s", dplyr::last(df$Units))
          x = "Year"
        ),
        scale_color_manual(values = c(
          "F" = "#ed5f26",
          "F<sub>MSY</sub>" = "#00AC67",
          "F<sub>Lim</sub>" = "#000000",
          "F<sub>pa</sub>" = "#000000",
          "HR MSY<sub>proxy</sub>" = "#00AC67",
          "FMSY<sub>proxy</sub>" = "#00AC67"
        )),
        scale_linetype_manual(values = c(
          "F" = "solid",
          "F<sub>Lim</sub>" = "dashed",
          "F<sub>pa</sub>" = "dotted",
          "F<sub>MSY</sub>" = "solid",
          "HR MSY<sub>proxy</sub>" = "dotdash",
          "FMSY<sub>proxy</sub>" = "dotdash"
        )),
        scale_size_manual(values = c(
          "F" = 1.5,
          "F<sub>Lim</sub>" = .8,
          "F<sub>pa</sub>" = 1,
          "F<sub>MSY</sub>" = .5,
          "HR MSY<sub>proxy</sub>" = .8,
          "FMSY<sub>proxy</sub>" = .8
        )),
        scale_fill_manual(values = c("#f2a497")),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)) # ,
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "SSB") {
      if (is.null(title)) {
        title <- "Spawning Stock Biomass"
      }
      if (is.null(ylegend)) {
        ylegend <- sprintf("%s in 1000 %s", dplyr::last(df$StockSizeDescription), dplyr::last(df$StockSizeUnits))
        ylabels_func <- function(l) {
          trans <- l / 1000 #1000000
        }
      } else {
        if (is.na(ylegend)) ylegend <- ""
        ylabels_func <- function(l) {
          trans <- l
        }
      }
      
      if (is.null(ymax)) {
        limits <- expand_limits(y = 0)
      } else {
        limits <- expand_limits(y = c(0, ymax))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title, 
          y = ylegend,
          x = "Year"
        ),
        scale_color_manual(values = c(
          "SSB" = "#047c6c",
          "MSY B<sub>trigger</sub>" = "#689dff",
          "B<sub>Lim</sub>" = "#000000",
          "B<sub>pa</sub>" = "#000000",
          "Average" = "#ed5f26",
          "I<sub>trigger</sub>" = "#689dff",
          "BMGT<sub>lower</sub>" = "#000000",
          "BMGT<sub>upper</sub>" = "#689dff"
        )),
        scale_linetype_manual(values = c(
          "SSB" = "solid",
          "B<sub>Lim</sub>" = "dashed",
          "B<sub>pa</sub>" = "dotted",
          "MSY B<sub>trigger</sub>" = "solid",
          "Average" = "solid",
          "I<sub>trigger</sub>" = "dotdash",
          "BMGT<sub>lower</sub>" = "dotted",
          "BMGT<sub>upper</sub>" = "dotdash"
        )),
        scale_size_manual(values = c(
          "SSB" = 1.5,
          "B<sub>Lim</sub>" = .8,
          "B<sub>pa</sub>" = 1,
          "MSY B<sub>trigger</sub>" = .5,
          "Average" = .8,
          "I<sub>trigger</sub>" = .8,
          "BMGT<sub>lower</sub>" = .8,
          "BMGT<sub>upper</sub>" = .8                
        )),
        scale_fill_manual(values = c("#94b0a9")),
        limits,
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = ylabels_func
        ),
        scale_x_continuous(breaks = breaks_pretty())
      )
    } else if (type == "quality_SSB") {
      
      if (is.null(title)) {
        title <- sprintf("%s in 1000 %s", dplyr::last(df$StockSizeDescription), dplyr::last(df$StockSizeUnits))
      }
      
      rfpt <- c( "B<sub>Lim</sub>", "B<sub>pa</sub>","MSY B<sub>trigger</sub>")
      
      line_color <- c("#969696","#737373","#525252","#252525","#047c6c") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      line_color_rfpt <- c( "#000000","#000000", "#689dff")
      names(line_color_rfpt) <- rfpt
      line_color <- append(line_color, line_color_rfpt)
      
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_type_rfpt <- c("dashed", "dotted","solid")
      names(line_type_rfpt) <- rfpt
      line_type <- append(line_type, line_type_rfpt)
      
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_size_rfpt <- c( .8, 1, .5)
      names(line_size_rfpt) <- rfpt
      line_size <- append(line_size, line_size_rfpt)
      
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = "",
          x = ""
        ),
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = function(l) {
            trans <- l / 1000
          }
        ),
        scale_x_continuous(breaks= pretty_breaks())
        
      )
    } else if (type == "quality_F") {
      rfpt <- c( "F<sub>Lim</sub>","F<sub>pa</sub>", "F<sub>MSY</sub>")
      
      line_color <- c("#969696","#737373","#525252","#252525","#ed5f26") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      line_color_rfpt <- c( "#000000","#000000", "#00AC67")
      names(line_color_rfpt) <- rfpt
      line_color <- append(line_color, line_color_rfpt)
      
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_type_rfpt <- c("dashed", "dotted","solid")
      names(line_type_rfpt) <- rfpt
      line_type <- append(line_type, line_type_rfpt)
      
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_size_rfpt <- c( .8, 1, .5)
      names(line_size_rfpt) <- rfpt
      line_size <- append(line_size, line_size_rfpt)
      
      if (is.null(title)) {
        title <- sprintf("%s <sub>(ages %s)</sub>", dplyr::last(df$FishingPressureDescription), dplyr::last(df$FAge))
      }
      
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = "",
          x = "Year"
        ),
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1))
          
        ),
        scale_x_continuous(breaks= pretty_breaks())
      )
    } else if (type == "quality_R") {
      line_type <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) "solid")
      line_size <- sapply(as.character(sort(unique(df$AssessmentYear))), function(x) 1)
      line_color <- c("#969696","#737373","#525252","#252525","#28b3e8") %>% tail(length(unique(df$AssessmentYear)))
      names(line_color) <- as.character(sort(unique(df$AssessmentYear)))
      
      if (is.null(title)) {
        title <- sprintf("Rec <sub>(age %s)</sub> (Billions)", dplyr::last(df$RecruitmentAge))
      }
      theme_ICES_plots <- list(
        tmp,
        labs(
          title = title,
          y = "",
          x = ""
        ),
        scale_color_manual(values = line_color
        ),
        scale_linetype_manual(values = line_type
        ),
        scale_size_manual(values = line_size
        ),
        expand_limits(y = 0),
        scale_y_continuous(
          expand = expansion(mult = c(0, 0.1)),
          labels = function(l) {
            trans <- l / 1000000
          }
        ),
        scale_x_continuous(breaks= pretty_breaks())
      )
    }
    
    return(theme_ICES_plots)
    
  }
