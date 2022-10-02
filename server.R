library(shiny)
library(tidyverse)
library(sf)
library(lubridate)

rm(list=ls())

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # # # # # # # # # # 
  # Tab 2 - Bigfoot #
  # # # # # # # # # # 
  
  #If user has filtered Dat(), apply and make MappingDat()
  MappingDat = reactive({
    bigfoot_dat %>% 
      filter(unit %in% input$bigfoot_filter) %>% 
      filter(most_recent_report >= input$bigfoot_daterange[1],
             most_recent_report <= input$bigfoot_daterange[2])
  })
  
  MappingCoords = reactive({
    map_centroids %>% 
      filter(region %in% input$bigfoot_filter)
  })
  
  MyPal = reactive({
    # if(input$bigfoot_plotvar == "Number of reports"){
    colorNumeric(palette = "Spectral",
                  domain = MappingDat()$num_listings,
                  reverse = T)
    # } 
    # else if(input$bigfoot_plotvar == "Date of most recent report"){
    #   colorBin(palette = "Spectral",
    #                domain = year(MappingDat()$most_recent_report),
    #                reverse = T)
    # }
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
      setView(lat = 55.4, lng =  -93.3, zoom = 3) %>%
      addPolygons(data = bigfoot_dat %>% filter(unit == "Canada"),
                  label = ~paste0(subunit,",",
                                  num_listings,
                                  " sightings of ",local_name,", most recent: ",
                                  most_recent_report),
                  color = ~MyPal()(num_listings)
      ) %>%
      addLegend(position = "topright",
                pal = MyPal(),
                values = MappingDat()$num_listings,
                layerId = "temp_legend") %>%
      addLayersControl(baseGroups = c("OSM","Satellite"),
                       options = layersControlOptions(collapsed = F))
  })
  
  #Reactively populate the map with polygons (or buffered points)
  # that map users have added.
  observe({
    leafletProxy("bigfoot_map") %>% 
      clearShapes() %>% 
      removeControl(layerId = "temp_legend") %>% 
      addPolygons(data = MappingDat(),
                  label = ~paste0(subunit,", ",
                                  num_listings,
                                  " sightings of ",local_name,", most recent: ",
                                  most_recent_report),
                  color = ~MyPal()(num_listings)) %>% 
      addLegend(pal = MyPal(),
                values = MappingDat()$num_listings) %>% 
      setView(lng = MappingCoords()$X,
              lat = MappingCoords()$Y,
              zoom = MappingCoords()$zoom)
    # 
    # if(input$bigfoot_filter == "Canada"){
    #   map = map %>% 
    #     setView(lat = 60.0812, lng = -102.8931, zoom = 3) %>%
    #     addPolygons(data = canada_bigfoot,
    #                 label = ~paste0(num_listings," sightings, most recent: ",most_recent_report)
    #     ) %>% 
    #     addLegend(pal = MyPal(),
    #               values = canada_bigfoot$num_listings)
    # }else if(input$bigfoot_filter == "USA"){
    #   map = map %>% 
    #     setView(lat = 48.0812, lng = -102.8931, zoom = 2) %>%
    #     addPolygons(data = usa_bigfoot,
    #                 label = ~paste0(num_listings," sightings, most recent: ",most_recent_report)
    #     )
    # }else if(input$bigfoot_filter == "World"){
    #   map = map %>% 
    #     setView(lat = 40, lng = 0, zoom = 1) %>%
    #     addPolygons(data = international_bigfoot,
    #                 label = ~paste0(num_listings," sightings, most recent: ",most_recent_report)
    #     )
    # }
    })
})
