bigfoot_panel = material_tab_content(
  tab_id = 'bigfoot_tab',
  #title = "Where in the world is Bigfoot?",
  material_row(
    material_column(width = 8,
                    material_row(
                      material_column(
                        width = 4,
                        material_card(
                          title = "Map Controls",
                          selectInput(inputId = "bigfoot_filter",
                                      label = "Select Area of Analysis",
                                      multiple = F,
                                      selectize = F,
                                      selected = c("Canada"),
                                      choices = c("Canada","USA","World")),
                          HTML("<br><br><br><br><br><br>"),
                          sliderInput(inputId = "bigfoot_daterange",
                                      label = "Select Sighting Date Range",
                                      min = year(min(bigfoot_dat$most_recent_report)),
                                      max = year(max(bigfoot_dat$most_recent_report)),
                                      value = c(year(min(bigfoot_dat$most_recent_report)),
                                                year(max(bigfoot_dat$most_recent_report))),
                                      timeFormat = "%YYYY",
                                      sep = ""
                          ),
                          HTML("<br><br><br><br><br>")
                        )
                      ), #End of map control column.
                      material_column(
                        width = 8,
                        material_card(
                          title = tagList(shiny::icon("paw"),"Bigfoot in the World"), 
                          leafletOutput('bigfoot_map',width = "100%", height = 400))
                      ) #End of map column.
                    ), #End of map and map control row.
                    material_row(
                      material_column(width = 4,
                                      material_card(title = "Total Reports",
                                                    color = 'teal lighten-2',
                                                    divider = T,
                                                    span(textOutput("total_summary"), style="font-size:30px;"))
                      ),
                      material_column(width = 4,
                                      material_card(title = "Most Recent Report",
                                                    color = '#64b5f6 blue lighten-2',
                                                    divider = T,
                                                    span(textOutput('most_recent_report'), style = "font-size:30px;"))
                      ),
                      material_column(width = 4,
                                      material_card(title = "Most Recent Location",
                                                    color = '#9575cd deep-purple lighten-2',
                                                    divider = T,
                                                    span(textOutput('recent_report_location'), style = "font-size:30px;"))
                      )
                    ) #End of summary widget row.
    ),
    material_column(width = 4,
                    material_card(
                      title = tagList(shiny::icon("map"),"Reports Broken Down by Region"), 
                      HTML("<br><br>"),
                      numericInput(
                        inputId = "binning_number",
                        label = "Number of Groups to Show",
                        value = 8,
                        min = 1,
                        max = 12
                      ),
                      HTML("<br><br>"),
                      plotlyOutput('bigfoot_barplot')
                    )     
    ) #End of bar plot column.
  ),
  material_row(
    material_column(width = 12, 
                    material_card(
                      title = tagList(shiny::icon("newspaper"),"Bigfoot in the News"), 
                      dataTableOutput('bigfoot_news_table')
                    )
    ) #End of column 1 in fluidRow 2.
  ) #End of bottom fluidRow for bigfoot page.
) #End of bigfoot tabPanel.
