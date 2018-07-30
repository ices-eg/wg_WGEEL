ui <- dashboardPage(title="ICES Data Integration",
    dashboardHeader(title=div(img(src="iceslogo.png"),"wgeel")),
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
        )
    ), 
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
                            c("Annex 2 Catch and Landings" = "catch_landings",
                                "Annex 3 Release" = "release",
                                "Annex 4 Aquaculture" = "aquaculture",                                
                                "Annex 6 Biomass indicators" = "biomass",
                                "Annex 7 Habitat - wetted area"= "potential_available_habitat",
                                "Annex 8 Mortality silver equiv. Biom."="mortality_silver_equiv",
                                "Annex 9 Mortality_rates"="mortality_rates",
                                )),
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
                    column(width=6,verbatimTextOutput("textoutput_step2.2"))
                )
            ),
            tabItem("edit",
                h2("Data correction table"),
                br(),        
                h3("Filter"),
                fluidRow(
                    column(width=4,
                        pickerInput(inputId = "country", 
                            label = "Select a country :", 
                            choices = list_country,
                            multiple = TRUE, # fond défaut (primary, success, info, warning, danger) see shinydashboard appearance
                            options = list(
                                style = "btn-primary", size = 5))),
                    column(width=4, 
                        pickerInput(inputId = "typ", 
                            label = "Select a type :", 
                            choices = typ_id,
                            multiple = TRUE, # fond défaut (primary, success, info, warning, danger) see shinydashboard appearance
                            options = list(
                                style = "btn-primary", size = 5))),
                    column(width=4,
                        sliderTextInput(inputId ="year", 
                            label = "Choose a year range:",
                            choices=seq(the_years$min_year, the_years$max_year),
                            selected = c(the_years$min_year,the_years$max_year)
                        ))),                                                         
                helpText("This table is used to edit data in the database
                        After you double click on a cell and edit the value, 
                        the Save and Cancel buttons will show up. Click on Save if
                        you want to save the updated values to database; click on
                        Cancel to reset."),
                br(), 
                fluidRow(                                       
                    column(width=8,verbatimTextOutput("database_errors")),
                    column(width=2,actionButton("clear_table", "clear")),
                    column(width=2,uiOutput("buttons_data_correction"))
                ),                
                br(),
                DT::dataTableOutput("table_cor")),
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


