shinyServer(function(input, output, session) {
  ### Reactively filtering mydata with incident_characteristics ###
  getindex=reactive({
    switch(input$bycharacteristic,
           "All"=1:nrow(mydata),
           "Drug involvement"=grep("Drug involvement",mydata$incident_characteristics),
           "Stolen/Illegally owned gun"=grep("Stolen/Illegally owned gun",mydata$incident_characteristics,fixed=T),
           "School/Child involved"=grep("School|Child",mydata$incident_characteristics),
           "Political Violence"=grep("Political Violence",mydata$incident_characteristics))
  })
  
  ### Further reactively filtering mydata with total number of victims ###
  getdata=reactive({
    switch(input$byvictim,
           "All"=mydata[getindex(),],
           "No injuries"=mydata[getindex(),]%>%filter(n_victims==0),
           "1+ victim(s)"=mydata[getindex(),]%>%filter(n_victims>0),
           "Mass shooting (4+ victims)"=mydata[getindex(),]%>%filter(n_victims>=4))
  })
  
  ### Get aggregated reactive data by states within the given timeframe ###
  ### Used later in bar plot ###
  getstatedata=reactive({
    getdata() %>% filter((date>=input$trange[1]) & (date<=input$trange[2]))%>%
      group_by(state) %>% summarise(Number_of_Incidents=n()) 
  })
  
  ### Get reactive data within given timeframe ###
  ### Used later in map plot ###
  getdatamap=reactive({
       getdata() %>% 
           filter((date>=input$timerange[1]) & (date<=input$timerange[2]))
       
  })
  
  output$avgBox <- renderInfoBox(
    infoBox("Avg Per State",
            round(mean(getstatedata()$Number_of_Incidents)), 
            icon = icon("calculator"), fill = TRUE)
  )
  
  output$by_state_plotly <- renderPlotly({
    ggplotly(getstatedata() %>%
               ggplot(aes(x=reorder(state, -Number_of_Incidents), y=Number_of_Incidents, fill=Number_of_Incidents, text=state)) +
               geom_bar(stat='identity') + scale_fill_gradient(low="yellow", high="red")+
               labs(x='', y='Number of incidents') + theme(axis.text.x = element_text(angle = 45, hjust = 1)),
               tooltip=c("text", "y") 
             ) 
  })
  
  output$by_year_plotly <- renderPlotly({
    ggplotly(getdata() %>%filter(year!=2013 & year!=2018) %>% group_by(year) %>% 
               summarise(Number_of_Incidents=n()) %>%
               ggplot(aes(x=year, y=Number_of_Incidents)) + geom_bar(stat='identity', fill='red') +
               labs(x='Year', y='Number of incidents', title='Incidents by Year')
             )
  })
  
  output$by_quarter_plotly <- renderPlotly({
    ggplotly(getdata() %>% filter(year!=2013 & year!=2018) %>% group_by(quarter) %>% 
               summarise(Number_of_Incidents=n()) %>%
               ggplot(aes(x=quarter, y=Number_of_Incidents)) + geom_bar(stat='identity', fill='orange') +
               labs(x='Quarter', y='Number of incidents', title='Incidents by Quarter')
             )
  })
  
  output$by_month_plotly <- renderPlotly({
    ggplotly(getdata() %>% filter(year!=2013 & year!=2018) %>% group_by(month) %>% 
               summarise(Number_of_Incidents=n()) %>%
               ggplot(aes(x=month, y=Number_of_Incidents)) + geom_bar(stat='identity', fill='yellow') +
               labs(x='Month', y='Number of incidents', title='Incidents by Month')
             )
  })
  
  output$mymap=renderLeaflet({
    leaflet() %>% 
      addProviderTiles(providers$Esri.WorldStreetMap) %>% 
      setView(lng=-96, lat=37.8, zoom=4)
  })
  
  observe({
    proxy=leafletProxy("mymap", data=getdatamap()) %>% 
         clearMarkers() %>%
         clearMarkerClusters() %>%
         addCircleMarkers( ~longitude,~latitude,
                           clusterOptions=markerClusterOptions(),
                         popup=~paste('<b><font color="Black">','Incidence Information','</font></b><br/>',
                                     'Date:', date,'<br/>',
                                     'No. of Victims:', n_victims, '<br/>',
                                     'Location:', city,'<br/>',
                                     '<a href="',incident_url,'" target="_blank">Incident_URL</a>')
                         )
  })
  
  
  output$table <- DT::renderDataTable({
    datatable(data=getdata()%>%select(id,date,state,city,n_killed,n_injured,incident_characteristics), rownames=FALSE) 
  })
  
})