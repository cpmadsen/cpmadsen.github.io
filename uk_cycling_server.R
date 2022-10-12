# CYCLING IN THE UK #

CyclePal = reactive({
  colorNumeric(palette = 'Spectral',
               domain = CyclingAccidents()$num_accidents,
               reverse = T)
})

CyclingAccidents = reactive({
  uk_cyclingaccs %>%
    st_drop_geometry() %>% 
    filter(year == input$uk_cycling_year)
})

CyclingAccidents_polys = reactive({
  uk_cyclingaccs %>%
    filter(year == input$uk_cycling_year)
})

CyclingAccidentSummaries = reactive({
  uk_cyclingacc_outcomes %>% 
    filter(year == input$uk_cycling_year)
})

# Summary info boxes.
output$uk_fatal_accidents = renderInfoBox({
  infoBox(
    "Fatal Accidents",
    CyclingAccidentSummaries() %>% 
      filter(CycleAccOutcome == "Killed") %>% 
      pull(num_accidents),
    icon = icon("skull"),
    color = 'red', fill = T,
    width = 4
  )
})

output$uk_serious_accidents = renderInfoBox({
  infoBox(
    "Serious Injury Accidents",
    CyclingAccidentSummaries() %>% 
      filter(CycleAccOutcome == "Seriously injured") %>% 
      pull(num_accidents),
    icon = icon("warning"),
    color = 'orange', fill = T,
    width = 4
  )
})

output$uk_total_accidents = renderInfoBox({
  infoBox(
    "Total Accidents",
    CyclingAccidentSummaries() %>% 
      filter(CycleAccOutcome == "Total") %>% 
      pull(num_accidents),
    icon = icon("number"),
    color = 'orange', fill = T,
    width = 4
  )
})

output$uk_tot_proj = renderInfoBox({
  infoBox(
    "National Cycling Projects",
    CyclingAccidents() %>% 
      summarise(total = sum(total_projects_by_region, na.rm=T)) %>% 
      pull(total),
    icon = icon("pencil"),
    color = 'green', fill = T,
    width = 4
  )
})

output$uk_tot_scheme_cost = renderValueBox({
  valueBox(
    subtitle = "National Cycling Scheme Cost",
    value = CyclingAccidents() %>% 
      summarise(total = sum(annual_total_schemes_cost, na.rm=T)) %>% 
      pull(total),
    icon = icon("project"),
    color = 'blue',
    width = 4
  )
})

output$uk_tot_df_t_funding = renderInfoBox({
  infoBox(
    "National DF T Funding",
    CyclingAccidents() %>% 
      summarise(total = sum(annual_df_t_funding, na.rm=T)) %>% 
      pull(total),
    icon = icon("project"),
    color = 'purple', fill = T,
    width = 4
  )
})

output$uk_cycling_leaflet = renderLeaflet({
  leaflet() %>%
    addProviderTiles("Esri.WorldImagery",
                     group = "Satellite",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addProviderTiles("OpenStreetMap",
                     group = "OSM",
                     options = providerTileOptions(minZoom = 2, maxZoom = 19)) %>%
    addScaleBar(position = "bottomright") %>%
    addPolygons(data = uk_cyclingaccs %>% filter(year == 2005),
                label = ~paste0(region,": ",num_accidents, " accidents"),
                fillColor = ~CyclePal()(num_accidents),
                color = "black",
                fillOpacity = 0.5) %>% 
    addLegend(pal = CyclePal(),
              values = uk_cyclingaccs %>% filter(year == 2005) %>% pull(num_accidents)) %>% 
    leaflet.extras::addResetMapButton() %>%
    # leaflet.extras2::addTimeslider(data = uk_cyclingaccs_l,
    #                                options = timesliderOptions(
    #                                  position = 'bottomright',
    #                                  timeAttribute = "year",
    #                                  timeStrLength = 4,
    #                                  alwaysShowDate = TRUE
    #                                )) %>%
    hideGroup(c("Satellite")) %>%
    #setView(lat = 55.4, lng =  -93.3, zoom = 3) %>%
    addLayersControl(baseGroups = c("OSM","Satellite"),
                     options = layersControlOptions(collapsed = F))
})

observe({
  leafletProxy('uk_cycling_leaflet') %>%
    clearShapes() %>%
    addPolygons(data = CyclingAccidents_polys(),
                label = ~paste0(region,": ",num_accidents, " accidents"),
                fillColor = ~CyclePal()(num_accidents),
                color = "black",
                fillOpacity = 0.5)
})

# UK cycling line graph
output$cycling_lineplot = renderPlot({
  uk_cyclingaccs %>% 
    #mutate(year = factor(year, levels = c(2005:2016))) %>% 
    ggplot(aes(x = year, y = num_accidents, col = region, group = region)) + 
    geom_vline(data = CyclingAccidents(),
               aes(xintercept = year)) +
    geom_smooth(se = F, size = 2, alpha = 0.5) + 
    scale_x_discrete() +
    ggpubr::theme_pubr() + 
    theme(legend.position = 'bottom') + 
    labs(y = "Number of Accidents by Region", 
         x = "Year")
})

# UK cycling accidents by region.

output$cycling_acc_region_donut = renderPlotly({
  #CyclingAccidents() %>% 
  plot_ly() %>% 
    add_pie(data = CyclingAccidents(), 
            labels = ~region, 
            values = ~num_accidents,
            hole = 0.6) %>% 
    layout(showlegend = F,
           yaxis = list(showgrid=F,zeroline=F,showticklabels=F),
           xaxis = list(showgrid=F,zeroline=F,showticklabels=F)) %>% 
    plotly::add_text(data = CyclingAccidents(),
                     x = 0,
                     y = 0,
                     size = 10,
                     text = ~paste0("Total\n",sum(num_accidents)))
})