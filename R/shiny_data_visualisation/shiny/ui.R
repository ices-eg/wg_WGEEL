#########################################
# shiny data visualisation : ui.R
# Authors: lbeaulaton Cedric
###############################################################################

ui = dashboardPage(title="ICES Data Visualisation",
    skin = "black",
    dashboardHeader(title=div(img(src="iceslogo.png")," wgeel")),
    dashboardSidebar(
        # A button that stops the application--------------------------------------------------------
        
        extendShinyjs(text = jscode, functions = c("closeWindow")),
        actionButton("close", "Close window"), 
        
        # Elements of menu in the sidebar -----------------------------------------------------------   
        
        sidebarMenu(
            id="tabs",  
            menuItem("Table",tabName= "table_tab", icon= icon("table")),
            menuItem("Landings", tabName="landings_tab", icon=icon("bar-chart-o"),
                menuSubItem("Raw + cor",  tabName="combined_landings_tab"),
                menuSubItem("Raw",  tabName="raw_landings_tab"),               
                menuSubItem("Available Data",tabName="available_landings_tab")#,
            #menuSubItem("Habitat average",tabName="average_landings_habitat_tab"),
            #menuSubItem("Habitat sum",tabName="sum_landings_habitat_tab")
            ),
            menuItem("Aquaculture", tabName="aquaculture_tab", icon=icon("bar-chart-o")),
            menuItem("Release", tabName="release_tab", icon=icon("bar-chart-o")),               
            menuItem("Map", tabName='map_tab',icon= icon("globe") #,
            #                menuSubItem("Landings",  tabName="leaflet_landings_tab"),
            #                menuSubItem("Releases",  tabName="leaflet_release_tab"),
            #                menuSubItem("Aquaculture",  tabName="leaflet_aquaculture_tab")
            ),  
            menuItem("Preco-diag", tabName='precodata_tab',icon= icon("dashboard",lib="glyphicon")),  
            menuItem("Recruitment", tabName='recruit_tab',icon= icon("signal",lib= "font-awesome" ),
                menuSubItem("Map",tabName="map_recruitment_tab"),
                menuSubItem("Tables",tabName="table_recruitment_tab")),
            
            # Sliders, radiobuttons and checkboxes. These will be used by the filter function to
            # narrow down the dataset ---------------------------------------------------------------
            
            sliderTextInput("year", "Year", 
                choices=seq(from=min(landings$eel_year),to= CY,by=1),
                selected=c(1980,CY)),
            radioGroupButtons(
                inputId = "geo",
                label = "Scale", 
                choices = c("country", "emu"), 
                selected = "country"      
            ),
            pickerInput(
                inputId = "lfs",
                label = "Life stage", 
                choices = lfs_code_base$lfs_code,
                selected=lfs_code_base$lfs_code,
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE)
            ),
            pickerInput(
                inputId = "habitat",
                label = "Habitat", 
                choices = c(habitat_ref$hty_code,"NA"),
                selected=c(habitat_ref$hty_code,"NA"),
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE)
            ),
            pickerInput(
                inputId = "country",
                label =  "Country", 
                choices = sort(levels(country_ref$cou_code)), 
                selected= levels(country_ref$cou_code), 
                multiple = TRUE,
                options = list(
                    `actions-box` = TRUE, size = 10))
        ),
        radioGroupButtons(
            inputId = "image_format",
            label = "Preferred image format", 
            choices = c("png", "svg")[1:(1+require(svglite))], 
            selected = "png"      
        )),	
    
    # Content of tabs -------------------------------------------------------------------------------
    
    dashboardBody(
        # integrate custom css style
        #        tags$head(
        #            tags$link(rel = "stylesheet", type = "text/css", href = "cerulean.css")
        #        ),
        tags$head(tags$style(
                type="text/css",
                "#recruit_site_image img {max-width: 100%; width: 100%; height: auto}"
            )),
        useShinyjs(), # to be able to use shiny js 
        
        
        
        tabItems(
            
            # TABLE --------------------------------------------------------------------------------
            
            tabItem(tabName="table_tab",
                box(id="box_table",
                    title="Table per country",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(column(width=4,
                            radioGroupButtons(
                                inputId = "dataset",
                                label = "Dataset",
                                choices = c("landings","raw_landings_com","raw_landings_rec","landings_com_corrected","landings_rec_corrected","aquaculture_n", "aquaculture_kg", "release_kg", "release_n","gee", "precodata"),
                                status = "primary",
                                checkIcon = list(
                                    yes = icon("ok", 
                                        lib = "glyphicon"),
                                    no = icon("remove",
                                        lib = "glyphicon"))
                            )), 
                        column(width=6,htmlOutput("table_description"))),
                    DT::dataTableOutput("table"))),
            
            # LANDINGS ------------------------------------------------------------------------------
            
            tabItem(tabName="combined_landings_tab", 
                fluidRow(                    
                    column(width=10,plotOutput("graph_combined",height="800px")),
                    column(width=2,htmlOutput("graph_combined_description"),
                        actionBttn(
                            inputId = "combined_button",
                            label = NULL,
                            style = "simple", 
                            color = "success",
                            icon("refresh",lib="glyphicon")
                        ),
                        bsTooltip(id= "combined_button", #  donne le lien vers n'importe quel input ou output
                            title = "Click to refresh / launch the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL
                        ),
                        awesomeCheckboxGroup(
                            inputId = "combined_landings_eel_typ_id",
                            label = "Dataset",
                            choices = c("com"=4,"rec"=6),
                            selected=c("com"=4),
                            status = "primary",
                            inline=TRUE                                
                        ),
                        tipify(downloadButton(
                                outputId = "downloadcombined",
                                label = "" 
                            #style = "material-circle",
                            #color = "danger"
                            ),
                            title = "Click to download the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL
                        )
                    )                
                )
            ),
            tabItem(tabName="raw_landings_tab", 
                box(id="box_graph",
                    title="Landings",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(column(width=2, materialSwitch(
                                inputId = "raw_landings_habitat_switch",
                                label = "By habitat", 
                                value = FALSE,
                                status = "primary"
                            )),
                        column(width=2,  materialSwitch(
                                inputId = "raw_landings_lifestage_switch",
                                label = "By lifestage", 
                                value = FALSE,
                                status = "primary"
                            )),
                        column(width=2,  awesomeCheckboxGroup(
                                inputId = "raw_landings_eel_typ_id",
                                label = "Dataset",
                                choices = c("com"=4,"rec"=6),
                                selected=c("com"=4),
                                status = "primary",
                                inline=TRUE                                
                            ))
                    )),
                fluidRow(                    
                    column(width=10,plotOutput("graph_raw_landings",height="800px")),
                    column(width=2,
                        actionBttn(
                            inputId = "raw_landings_button",
                            label = NULL,
                            style = "simple", 
                            color = "success",
                            icon("refresh",lib="glyphicon")
                        ),
                        bsTooltip(id= "raw_landings_button", #  donne le lien vers n'importe quel input ou output
                            title = "Click to refresh / launch the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL
                        ),
                        tipify(downloadButton(
                                outputId = "download_graph_raw_landings",
                                label = ""#, 
                            #style = "material-circle", 
                            #color = "danger"
                            ),                       
                            title = "Click to download the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL                        
                        )
                    )                
                )
            ),
            
            tabItem(tabName="available_landings_tab",
                column(width=10, plotOutput("graph_available",height="800px")),
                column(width=2,
                    actionBttn(
                        inputId = "available_landings_button",
                        label = NULL,
                        style = "simple", 
                        color = "success",
                        icon("refresh",lib="glyphicon")
                    ),
                    bsTooltip(id= "available_landings_button", #  donne le lien vers n'importe quel input ou output
                        title = "Click to refresh / launch the graph",
                        placement="top", # default bottom
                        trigger="hover", # hover focus click, hover default
                        options=NULL
                    )
                
                )),
            tabItem(tabName="average_landings_habitat_tab"),
            tabItem(tabName="sum_landings_habitat_tab"),
            
            # Aquaculture ---------------------------------------------------------------------------
            
            tabItem(tabName="aquaculture_tab", 
                box(id="box_graph_aquaculture",
                    title="Aquaculture",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(
                        column(width=2,  materialSwitch(
                                inputId = "aquaculture_lifestage_switch",
                                label = "By lifestage", 
                                value = FALSE,
                                status = "primary"
                            )),
                        column(width=2,  radioGroupButtons(
                                inputId = "aquaculture_eel_typ_id",
                                label = "Dataset",
                                choices = c("ton","n"),
                                selected=c("ton"),
                                status = "primary",
                                checkIcon = list(
                                    yes = icon("ok", 
                                        lib = "glyphicon"),
                                    no = icon("remove",
                                        lib = "glyphicon"))                               
                            ))
                    )),
                fluidRow(                    
                    column(width=10,plotOutput("graph_aquaculture",height="800px")),
                    column(width=2,
                        actionBttn(
                            inputId = "aquaculture_button",
                            label = NULL,
                            style = "simple", 
                            color = "success",
                            icon("refresh",lib="glyphicon")
                        ),
                        bsTooltip(id= "aquaculture_button", #  donne le lien vers n'importe quel input ou output
                            title = "Click to refresh / launch the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL
                        ),
                        tipify(downloadButton(
                                outputId = "download_graph_aquaculture",
                                label = ""#, 
                            #style = "material-circle", 
                            #color = "danger"
                            ),                       
                            title = "Click to download the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL                        
                        )
                    )                
                )
            ),
            
            # Release ---------------------------------------------------------------------------
            
            tabItem(tabName="release_tab", 
                box(id="box_graph_release",
                    title="We love transporting eels arround",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(
                        column(width=2,  materialSwitch(
                                inputId = "release_lifestage_switch",
                                label = "By lifestage", 
                                value = FALSE,
                                status = "primary"
                            )),
                        column(width=3,  radioGroupButtons(
                                inputId = "release_eel_typ_id",
                                label = "Dataset",
                                choices = c("Release_kg","Release_n","Gee"),
                                selected=c("Release_kg"),
                                status = "primary",
                                checkIcon = list(
                                    yes = icon("ok", 
                                        lib = "glyphicon"),
                                    no = icon("remove",
                                        lib = "glyphicon"))                               
                            ))
                    )),
                fluidRow(                    
                    column(width=10,plotOutput("graph_release",height="800px")),
                    column(width=2,
                        actionBttn(
                            inputId = "release_button",
                            label = NULL,
                            style = "simple", 
                            color = "success",
                            icon("refresh",lib="glyphicon")
                        ),
                        bsTooltip(id= "release_button", #  donne le lien vers n'importe quel input ou output
                            title = "Click to refresh / launch the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL
                        ),
                        tipify(downloadButton(
                                outputId = "download_graph_release",
                                label = ""#, 
                            #style = "material-circle", 
                            #color = "danger"
                            ),                       
                            title = "Click to download the graph",
                            placement="top", # default bottom
                            trigger="hover", # hover focus click, hover default
                            options=NULL                        
                        )
                    )                
                )
            ),
            
            
            
            
            # PRECAUTIONARY DIAGRAM -----------------------------------------------------------------
            
            tabItem(tabName="precodata_tab",
                fluidRow(                    
                    column(width=10,plotOutput("precodata_graph",height="800px")),
                    column(width=2,
                        awesomeCheckboxGroup(
                            inputId = "precodata_choice",
                            label = "graph_choice",
                            choices = c("emu","country","all"),
                            selected=c("all"),
                            status = "danger",
                            inline=TRUE                                
                        ), 
                        switchInput(
                            inputId = "button_precodata_last_year",
                            onLabel = "last year",
                            offLabel = "all", 
                            onStatus = "success", 
                            offStatus = "warning",
                            size = "default",                           
                            value = FALSE
                        )                        
                    )
                )            
            ),
            
            # MAP -----------------------------------------------------------------------------------
            
            tabItem(tabName="map_tab", 
                leafletOutput("map", height = 800),
                absolutePanel(top = 70, right = 25, draggable = TRUE,
                    p("Upper glider = year, both = historical range for bubble size"),
                    p("buttons on the left and right to narrow the dataset"), 
                    radioGroupButtons(
                        inputId = "leaflet_dataset",
                        label = "Dataset", 
                        choices = c("landings", "aquaculture", "release"
                        #,"precodata" TODO develop here
                        ), 
                        selected = "landings"      
                    ),
                    # this output listens to leaflet dataset and change input accordingly
                    uiOutput("leaflet_typ_button")                     
                ),
                absolutePanel(bottom = 300, right = 10, draggable = TRUE,
                    # add a small border to indicate where the plot will be
                    div(
                        #----------------------
                        # A button to toggle the plotly graph on and off
                        switchInput(
                            inputId = "showplotly",
                            onLabel = "Show",
                            offLabel = "Hide", 
                            onStatus = "primary", 
                            offStatus = "secondary",
                            size = "mini",                           
                            value = TRUE
                        ),
                        plotlyOutput("plotly_graph")
                        #----------------------
                        , style = "border: 2px solid rgb(209,218,201);"
                    )# end div
                )
            ),
            
            #recruitment----------------------------------------
            tabItem(tabName="map_recruitment_tab", 
                fluidRow(
                    
                    column(width=6,
                        h2("Map of recruitment sites"),
                        p("Click on a point for details about the series"),
                        leafletOutput("mapstation", height = 600),
                        box(title = "Details about the site",
                            status = "primary",
                            solidHeader = F,
                            collapsible = F,
                            width = 12,
                            fluidRow(
                                column(width=7,uiOutput("recruit_site_description")),
                                column(width=5, align="center",
                                    imageOutput("recruit_site_image")                                    
                                )
                            )
                        )
                    ),
                    column(width=6,
                        h2("Individual series compared to recruitment trend"),
                        plotlyOutput("plotly_recruit"),
                        htmlOutput("das_comment"),
                        # below the div style is to align things on a single line 
                        div(style="display:inline-block",
                            h2("Model Residuals")),
                        div(style="display:inline-block",switchInput(
                                inputId = "button_smooth",
                                onLabel = "res+smooth",
                                offLabel = "resid", 
                                onStatus = "secondary", 
                                offStatus = "secondary",
                                size = "mini",                           
                                value = FALSE
                            )),
                        p("Unlike previous graph where current values are scaled to the period,
                                1960-1979 using predicted model values, these represent the TRUE residuals of the gamma model"),
                        plotOutput("resid_recruitment_graph")))),
            tabItem(tabName="table_recruitment_tab",
                box(id="box_table_recruitment",
                    title="Recruitment indices",
                    status="primary",
                    solidHeader=TRUE,
                    collapsible=TRUE,
                    width=NULL,
                    fluidRow(column(width=4,
                            radioGroupButtons(
                                inputId = "index_rec",
                                label = "Recruitment",
                                choices = c("Elsewhere Europe","North Sea","Yellow"),
                                status = "primary",
                                checkIcon = list(
                                    yes = icon("ok", 
                                        lib = "glyphicon"),
                                    no = icon("remove",
                                        lib = "glyphicon"))
                            )), 
                        column(width=6,htmlOutput("table_rec_description"))),
                    DT::dataTableOutput("table_recruitment")))
        
        )
    )
)
