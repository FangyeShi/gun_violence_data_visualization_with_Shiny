shinyUI(dashboardPage(skin="purple",
                      dashboardHeader(title = "Gun Violence Data Visualization",titleWidth = "30%"), 
                      dashboardSidebar(
                        sidebarMenu(
                          #Due to some overriding issue, not including sidebarUserPanel here.
                          #sidebarUserPanel("Fangye Shi",
                          #                 image = "https://github.com/identicons/FangyeShi.png"
                          #                 ),
                          menuItem("Map",tabName = "map",icon = icon("map")),
                          menuItem("EDA Charts", tabName = "charts", icon = icon("bar-chart")),
                          menuItem("Data", tabName = "data", icon = icon("table"))
                          ),
                        selectizeInput("byvictim", "Choose number of victims to display:", 
                                           choices = c("All","No injuries" , "1+ victim(s)" , "Mass shooting (4+ victims)" ),
                                           selected="All"
                                           ),
                        selectizeInput("bycharacteristic", "Choose incident characteristics to display:", 
                                       choices = c("All","Drug involvement" , "Stolen/Illegally owned gun" , "School/Child involved","Political Violence" ),
                                       selected="All"
                        )
                      ), 
                      dashboardBody(
                        tags$head(
                          tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
                        ),
                        tabItems(
                          tabItem(tabName = "data",
                                  fluidRow(box(DT::dataTableOutput("table"), width = 12)) #changing width to 12 makes it take up whole page
                                  ),
                          tabItem(tabName='charts',
                                    tabBox(
                                      tabPanel("Group by State",
                                              div(style = 'overflow-y:scroll;height:600px;',
                                                fluidRow(box(infoBoxOutput("avgBox",width="100%"),width=6),
                                                         box(sliderInput(inputId = "trange", label = h4("Select range of dates"), min=as.Date("2013-01-05"), max=as.Date("2018-03-31"), step =30,
                                                                     value = c(as.Date("2013-01-05"),as.Date("2018-03-31"))),width=6)
                                                         ),
                                                fluidRow(plotlyOutput("by_state_plotly",width="100%",height = 500))
                                               )
                                              ),
                                      tabPanel("Group by Year/Quarter/Month",
                                               div(style = 'overflow-y:scroll;height:600px;',
                                                plotlyOutput("by_year_plotly",width="100%"),
                                                plotlyOutput("by_quarter_plotly",width="100%"),
                                                plotlyOutput("by_month_plotly",width="100%")
                                                )
                                               ),
                                      width=12L
                                    )
                                 ),
                          tabItem(tabName='map',
                                  leafletOutput("mymap",width = '100%',height = 600),
                                  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, 
                                                top = 10, left = "auto", right = 15, bottom = "auto",
                                                width = 700, height = "auto",
                                                sliderInput(inputId = "timerange", label = h4("Select range of dates"),
                                                            min=as.Date("2013-01-05"), 
                                                            max=as.Date("2018-03-31"), step =1,
                                                            value = c(as.Date("2018-01-01"),as.Date("2018-03-31")),
                                                            width='700px'))
                          )
                        )
                      )
))
                                  
                          
