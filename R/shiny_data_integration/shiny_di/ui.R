###############################################
# Ui file for ICES data integration tools
###############################################
spsDepend("toastr") #https://www.rdocumentation.org/packages/spsComps/versions/0.1.1/topics/spsDepend

ui <- fluidPage(spsDepend("toastr"),
		dashboardPage(title="ICES Data Integration",
				
				dashboardHeader(title=div(img(src="iceslogo.png"),"wgeel")),
				
				################################################################################################
				# SIDEBAR
				################################################################################################
				
				dashboardSidebar(
						# A button that stops the application
						extendShinyjs(text = jscode, functions = c("closeWindow")),
						actionButton("close", "Close window"),  
						passwordInput("password", "Password:"),
						actionButton("passwordbutton", "Go"),
						verbatimTextOutput("passwordtest"),
						h3("Data"),      
						sidebarMenu(   
								
								# menuItem("Import",tabName= "import", icon= icon("align-left")),
								# menuItem("Import Time Series",tabName= "import_ts", icon= icon("align-left")),					
								# menuItem("Edit Data", tabName="editAll", icon=icon("table")),
								# menuItem("Plot duplicates", tabName='plot_duplicates',icon= icon("area-chart")),
								# menuItem("New Participants", tabName='integrate_new_participants',icon= icon("user-friends")),
								menuItem("Import Data module", tabName="Importmodule", icon=icon("align-left")),
								menuItem("Import Time Series module",tabName= "Importtsmodule", icon= icon("align-left")),	
								menuItem("Import DCF module",tabName= "Importdcfmodule", icon= icon("align-left")),		
								menuItem("Edit Data module", tabName="editAllmodule", icon=icon("table")),
								menuItem("Plot duplicates module", tabName='plot_duplicates_module',icon= icon("area-chart")),
								menuItem("New Participants module", tabName="newparticipantstabmodule", icon=icon("user-friends"))
								#menuSubItem("Plot duplicates",  tabName="plot_duplicates"),
								#menuSubItem("plot2", tabName="plot2")
								,
								pickerInput(
										inputId = "main_assessor",
										label = "Main assessor (National)", 
										choices = participants,
										selected="Cedric Briand")
						
						),
						pickerInput(
								inputId = "secondary_assessor",
								label = "Secondary assessor (Data)", 
								choices = participants,
								selected="Cedric Briand"
						
						)
				
				
				), 
				
				################################################################################################
				# BODY
				################################################################################################
				
				dashboardBody(
						useShinyjs(), # to be able to use shiny js           
						tabItems(
								
								
								tabItem("Importmodule",
										importstep0UI("importstep0module"),
										importstep1UI("importstep1module"),
										importstep2UI("importstep2module")
								),
								tabItem("Importtsmodule",
										importtsstep0UI("importtsstep0module"),
										importtsstep1UI("importtsstep1module"),
										importtsstep2UI("importtsstep2module")
								),
								tabItem("Importdcfmodule",
										importdcfstep0UI("importdcfstep0module"),
										importdcfstep1UI("importdcfstep1module"),
										importdcfstep2UI("importdcfstep2module")
								),
								tabItem("newparticipantstabmodule",
										newparticipantsUI("newparticipantsmodule")),
								tabItem("plot_duplicates_module",
										plotduplicatesUI("plotduplicatesmodule"))
						
						)
				)
		)
)

