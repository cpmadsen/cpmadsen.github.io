output$bigfoot_map = renderLeaflet({
  leaflet() %>% 
    addProviderTiles("Esri.WorldImagery",
                     group = "Satellite",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addProviderTiles("OpenStreetMap",
                     group = "OSM",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addScaleBar(position = "bottomright") %>%
    #setView(lat = 48.55, -123.340, zoom = 9.5) %>%
    leaflet.extras::addResetMapButton() %>%
    hideGroup(c("Satellite")) %>% 
    addLayersControl(baseGroups = c("OSM","Satellite"),
                     options = layersControlOptions(collapsed = F))
})

MappingDat = reactive({
  
})
#Reactively repopulate the map based on the selection.
observe({
  leafletProxy("leafmap") %>% 
    clearShapes() %>% 
    addPolygons(data = MappingDat(),
                label = ~paste0(location,": ",productivity)
    )
})