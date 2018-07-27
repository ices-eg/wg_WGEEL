ui <- dashboardPage(title="ICES Data Integration",
    dashboardHeader(title=div(img(src="iceslogo.png"),"ICES wgeel")),
    dashboardSidebar(
        # A button that stops the application
        extendShinyjs(text = jscode, functions = c("closeWindow")),
        actionButton("close", "Close window"),  
        h3("Data"),      
        sidebarMenu(            
            menuItem("Import",tabName= "import", icon= icon("align-left")),
            menuItem("Edit", tabName="edit", icon=icon("table")),
            menuItem("Check", tabName='check',icon= icon("area-chart"),
                menuSubItem("plot1",  tabName="plot1"),
                menuSubItem("plot2", tabName="plot2"))    
        ),
        br(),        
        h3("Filter"),
            pickerInput(inputId = "country", 
                label = "Select a country :", 
                choices = list_country,
                multiple = TRUE, # fond défaut (primary, success, info, warning, danger) see shinydashboard appearance
                options = list(
                    style = "btn-primary")), 
            bsTooltip(id= "country", #  donne le lien vers n'importe quel input ou output
                title = "Choose a country (this only applies to data correction and check)",
                placement="top", # default bottom
                trigger="hover", # hover focus click, hover default
                options=NULL
            )),
    dashboardBody(
        useShinyjs(), # to be able to use shiny js           
        tabItems(
            tabItem(tabName="import",
                h2("Datacall Integration and checks"),
                br(),
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
            tabItem("edit",
                h2("Data correction table"),
                br(), 
                helpText("This table is used to edit data in the database
                        After you double click on a cell and edit the value, 
                        the Save and Cancel buttons will show up. Click on Save if
                        you want to save the updated values to database; click on
                        Cancel to reset."),
                br(), 
                fluidRow(                                       
                    column(width=8,verbatimTextOutput("database_errors")),
                    column(width=2,actionButton("clear_table", "clear"))
                ),                
                br(),
                DT::dataTableOutput("table_cor"),
                uiOutput("buttons_data_correction")),
            tabItem("plot1", fluidRow(
                    column(width=6,plotOutput("mon_graph1")),
                    column(width=6,plotOutput("mon_ggplot1"))
                )),
            tabItem("plot2", fluidRow(
                    column(width=6,plotOutput("mon_graph2")),
                    column(width=6,plotOutput("mon_ggplot2"))
                ))
        )
    )
)


