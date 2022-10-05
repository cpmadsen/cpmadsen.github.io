bigfoot_panel = material_tab_content(
  tab_id = 'bigfoot_tab',
  #title = "Where in the world is Bigfoot?",
  material_row(
    material_column(width = 2,
                    material_card(
                      title = "Map Controls",
                      selectInput(inputId = "bigfoot_filter",
                                  label = "Select Area of Analysis",
                                  multiple = F,
                                  selectize = F,
                                  selected = c("Canada"),
                                  choices = c("Canada","USA","World")),
                      sliderInput(inputId = "bigfoot_daterange",
                                  label = "Select Sighting Date Range",
                                  min = min(bigfoot_dat$most_recent_report),
                                  max = max(bigfoot_dat$most_recent_report),
                                  value = c(min(bigfoot_dat$most_recent_report),
                                            max(bigfoot_dat$most_recent_report))
                      )),
                    material_card(title = " ",
                                  color = 'teal lighten-2',
                                  textOutput('total_summary')),
                    material_card(title = " ",
                                  textOutput('most_recent_report')),
                    material_card(title = " ",
                                  textOutput('most_recent_location'))
                    ), #End of first column with map controls.
    material_column(width = 6,
                    material_card(
                      title = tagList(shiny::icon("paw"),"Bigfoot in the World"), 
                      leafletOutput('bigfoot_map',width = "100%", height = 400))
    ), #End of middle column with leaflet map.
    material_column(width = 4,
           material_card(
             title = tagList(shiny::icon("map"),"Reports Broken Down by Region"), 
               numericInput(
                 inputId = "binning_number",
                 label = "Number of Groups to Show",
                 value = 8,
                 min = 1,
                 max = 12
               ),
               plotlyOutput('bigfoot_barplot')#,
           )
    ) #End of third column, with scatterplot.
  ),#End of fluidRow 1.
  material_row(
    material_column(width = 12, 
           material_card(
             title = tagList(shiny::icon("newspaper"),"Bigfoot in the News"), 
               dataTableOutput('bigfoot_news_table')
           )
    ) #End of column 1 in fluidRow 2.
  ) #End of bottom fluidRow for bigfoot page.
) #End of bigfoot tabPanel.
