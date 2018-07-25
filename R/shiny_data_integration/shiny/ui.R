ui <- fluidPage( 
    theme = shinytheme("cerulean"), 
    #theme = shinytheme("superhero"),
    #theme="custom.css", #need folder www with custom.css
    # pour voir le css dans chrome tapper f12
    # Titre 
    titlePanel("ICES wgeel"),  
    mainPanel(h2("Datacall Integration and checks"),
        tabsetPanel(
            tabPanel("Data import", 
                h2("step 0 : Data check"),
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
                h2("step 1 : Compare with database"),
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
                h2("step 2.1 Integrate/ proceed duplicates rows"),
                fluidRow(
                    column(width=4,fileInput("xl_duplicates_file", "xls duplicates",
                            multiple=FALSE,
                            accept = c(".xls",".xlsx")
                        )),                   
                    column(width=2,
                        actionButton("database_duplicates_button", "Proceed")),
                    column(width=6,verbatimTextOutput("textoutput_step2.1"))
                ),
                h2("step 2.2 Integrate new rows"),
                fluidRow(
                    column(width=4,fileInput("xl_new_file", "xls new",
                            multiple=FALSE,
                            accept = c(".xls",".xlsx")
                        )),                   
                    column(width=2,
                        actionButton("database_new_button", "Proceed")),
                    column(width=6,verbatimTextOutput("errors_new_integration"))
                )
            ),
            tabPanel("Data correction table", br(), DT::dataTableOutput("table_cor"),
                helpText("This table is used to edit data in the database
                                        After you double click on a cell and edit the value, 
                                        the Save and Cancel buttons will show up. Click on Save if
                                        you want to save the updated values to database; click on
                                        Cancel to reset."),
                      uiOutput("buttons_data_correction")),
            tabPanel("Data check", fluidRow(
                    column(width=6,plotOutput("mon_graph")),
                    column(width=6,plotOutput("mon_ggplot"))
                )
            )
        )
    )  
)
