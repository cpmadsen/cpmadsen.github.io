usa_bigfoot = read_sf("data/usa_bigfoot.gpkg")
canada_bigfoot = read_sf("data/canada_bigfoot.gpkg")
international_bigfoot = read_sf("data/international_bigfoot.gpkg")

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # # # # # # # # # # 
  # Tab 2 - Bigfoot #
  # # # # # # # # # # 
  
  #If user has filtered Dat(), apply and make MappingDat()
  MappingDat = reactive({
    if(input$bigfoot_filter == "USA"){
      return(usa_bigfoot)
    } 
    if(input$bigfoot_filter == "Canada"){
      return(canada_bigfoot)
    } 
    if(input$bigfoot_filter == "World"){
      return(international_bigfoot)
    } 
  })
  
  output$bigfoot_map = renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldImagery",
                       group = "Satellite",
                       options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
      addProviderTiles("OpenStreetMap",
                       group = "OSM",
                       options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
      addScaleBar(position = "bottomright") %>%
      leaflet.extras::addResetMapButton() %>%
      hideGroup(c("Satellite")) %>% 
      setView(lat = 60.0812, lng = -102.8931, zoom = 3) %>% 
      addPolygons(data = canada_bigfoot,
                  label = ~paste0(num_listings," sightings, most recent: ",most_recent_report)
      ) %>% 
      addLayersControl(baseGroups = c("OSM","Satellite"),
                       options = layersControlOptions(collapsed = F))
  })
  
  #Reactively populate the map with polygons (or buffered points)
  # that map users have added.
  observeEvent(input$bigfoot_filter, {
    map = leafletProxy("bigfoot_map") %>% 
      clearShapes() %>% 
      addPolygons(data = MappingDat(),
                  label = ~paste0(num_listings," sightings, most recent: ",most_recent_report)
      )
    # if(input$bigfoot_filter == "Canada"){
    #   map = map %>% 
    #     setView(lng = 60.0812, -102.8931, zoom = 8)
    # }
    # if(input$bigfoot_filter == "USA"){
    #   map = map %>% 
    #     setView(lng = 40.6722, -100.7837, zoom = 8)
    # }
    # if(input$bigfoot_filter == "World"){
    #   map = map %>% 
    #     setView(lng = 0, 0, zoom = 12)
    # }
  })

})
