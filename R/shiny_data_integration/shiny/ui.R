ui <- fluidPage( 
    theme = shinytheme("cerulean"), 
    #theme = shinytheme("superhero"),
    #theme="custom.css", #need folder www with custom.css
    # pour voir le css dans chrome tapper f12
    # Titre 
    titlePanel("Data integration"),  
    mainPanel(h2("wgeel data integration"),
        tabsetPanel(
            tabPanel("Data import", 
                h2("step 0"),
                fluidRow(
                    column(width=4,fileInput("xlfile", "Choose xls File",
                            multiple=FALSE,
                            accept = c(".xls",".xlsx")
                        )),
                    column(width=4,  radioButtons(inputId="file_type", label="File type:",
                            c("Catch and Landings" = "catch_landings",
                                "Aquaculture" = "aquaculture",
                                "Stocking" = "stocking",
                                "Stock indicators" = "stock"))),
                    column(width=4, actionButton("check_file_button", "Check file") )                     
                ),
                
                fluidRow(
                    column(width=6,
                        htmlOutput("step0_message_txt"),
                        verbatimTextOutput("integrate"),placeholder=TRUE),
                    column(width=6,
                        htmlOutput("step0_message_xls"),
                        DT::dataTableOutput("dt_integrate"))
                ),              
                tags$hr(),
                h2("step 1"),
                fluidRow(                                       
                    column(width=2,                        
                        actionButton("check_duplicate_button", "Check duplicate")), 
                    column(width=5,
                        htmlOutput("step1_message_duplicates"),
                        DT::dataTableOutput("dt_duplicates")),
                    column(width=5,
                        htmlOutput("step1_message_new"),
                        DT::dataTableOutput("dt_new"))
                ),
                tags$hr(),
                h2("step 2"),
                fluidRow(                   
                    column(width=6,
                        actionButton("database_integration_button", "Database integration")),
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
