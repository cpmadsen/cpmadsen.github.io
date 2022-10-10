rm(list=ls())
setwd("F:/R Projects/cpmadsen.github.io")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #Make custom bigfoot icon
  bigfoot_icon = makeIcon("bigfoot_silhouette.png", iconWidth = 24, iconHeight = 30)
  
  # # # # # # # # # # 
  # Tab 2 - Bigfoot #
  # # # # # # # # # # 
  
  #If user has filtered Dat(), apply and make MappingDat()
  MappingDat = reactive({
    bigfoot_dat %>% 
      mutate(Year = year(most_recent_report)) %>% 
      filter(unit %in% input$bigfoot_filter) %>% 
      filter(Year >= input$bigfoot_daterange[1],
             Year <= input$bigfoot_daterange[2])
  })
  
  MappingCoords = reactive({
    map_centroids %>% 
      filter(region %in% input$bigfoot_filter)
  })
  
  Bigfoot_Location = reactive({
    MappingDat() %>% 
      slice_max(most_recent_report) %>% 
      st_centroid()
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
      addMarkers(data = Bigfoot_Location(),
                        icon = bigfoot_icon,
                 group = "Most Recent Report") %>% 
      addLegend(position = "bottomleft",
                pal = MyPal(),
                values = MappingDat()$num_listings,
                layerId = "temp_legend") %>%
      addLayersControl(baseGroups = c("OSM","Satellite"),
                       overlayGroups = c("Most Recent Report"),
                       options = layersControlOptions(collapsed = F),
                       position = "bottomleft")
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
      addMarkers(data = Bigfoot_Location(),
                        icon = bigfoot_icon) %>% 
      addLegend(pal = MyPal(),
                values = MappingDat()$num_listings) %>% 
      setView(lng = MappingCoords()$X,
              lat = MappingCoords()$Y,
              zoom = MappingCoords()$zoom)
    })
  
  output$bigfoot_barplot = renderPlotly({
    
    plotly::ggplotly(
      MappingDat() %>% 
        st_drop_geometry() %>% 
        mutate(subunit = fct_reorder(subunit,num_listings,.desc=T)) %>% 
        mutate(subunit = fct_lump(subunit, input$binning_number, w = num_listings)) %>% 
        group_by(subunit) %>% 
        summarise(most_recent_report = max(most_recent_report),
                  num_listings = sum(num_listings)) %>% 
        ggplot() + 
        geom_col(aes(x = subunit, y = num_listings)) + 
        scale_x_discrete(labels = scales::label_wrap(width = 8)) + 
        coord_flip() +
        #scale_fill_brewer(palette = "Dark2") +
        labs(x = "", y = "Number of Reports", title = "Reports by Region") +
        ggpubr::theme_pubr() + 
        theme(legend.position = "none")
   )
  })
  
  output$total_summary = renderInfoBox({
    infoBox(
      "Total Reports",
        MappingDat() %>%
          st_drop_geometry() %>%
          summarise(total = sum(num_listings)) %>%
          pull(total),
      icon = icon("credit-card"),
      color = 'lime', fill = T
    )
  })
  
  output$most_recent_date = renderInfoBox({
    infoBox(
      "Most Recent Report",
      MappingDat() %>% 
        st_drop_geometry() %>% 
        mutate(most_recent_report = lubridate::ymd(most_recent_report)) %>% 
        summarise(latest = max(most_recent_report)) %>% 
        pull(latest),
      icon = icon("credit-card"),
      color = 'orange', fill = T
    )
  })
  
  output$most_recent_place = renderInfoBox({
    infoBox(
      "Recent Report Location",
      MappingDat() %>% 
        st_drop_geometry() %>% 
        arrange(desc(most_recent_report)) %>% 
        slice(1) %>% 
        pull(subunit),
      icon = icon("credit-card"),
      color = 'purple', fill = T
    )
  })

  #News feed - slickR carousel
  output$bigfoot_news_table = renderDataTable({
    myquery <- feed.extract("https://news.google.com/rss/search?q=Bigfoot")
    myquery$items %>% 
      as_tibble() %>% 
      select(title,date,link) %>% 
      rename(Title = title, Date = date, Link = link) %>% 
      mutate(Date = str_extract(as.character(Date),".*(?= )")) %>% 
      DT::datatable(., options = list(lengthMenu = c(3, 5, 10), pageLength = 3))
  })
  
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
})
