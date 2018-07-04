ui <- fluidPage(  
    #theme = shinytheme("superhero"),
    theme="custom.css", #need folder www with custom.css
    # pour voir le css dans chrome tapper f12
    # Titre 
    titlePanel("Data integration"),  
    mainPanel(h2("wgeel data integration"),
        tabsetPanel(
            tabPanel("Data import", 
                fluidRow(
                    column(width=6,fileInput("xlfile", "Choose xls File",
                            multiple=FALSE,
                            accept = c(".xls",".xlsx")
                        )),
                    column(width=6,  radioButtons(inputId="file_type", label="File type:",
                            c("Catch and Landings" = "catch_landings",
                                "Aquaculture" = "aquaculture",
                                "Stocking" = "stocking",
                                "Stock indicators" = "stock")))
                ),
                tags$hr(),
                fluidRow(
                                       
                    column(width=4,
                        h2("step 1"),
                        actionButton("check_duplicate", "Check duplicate")),
                    column(width=4,
                        h2("step 2"),
                        actionButton("database", "Database integration"))                   
                ),
                tags$hr(),
                fluidRow(
                    column(width=6,textOutput("integrate")),
                    column(width=6,dataTableOutput("errors"))
                )
            ),
            tabPanel("Data correction table", dataTableOutput("table_cor"),width=95),
            tabPanel("Data check", fluidRow(
                    column(width=6,plotOutput("mon_graph")),
                    column(width=6,plotOutput("mon_ggplot"))
                )
            )
        )
    )  
)