bigfoot_panel = tabPanel(
  title = "Where in the world is Bigfoot?",
  fluidRow(
    column(width = 8,
           box(title = tagList(shiny::icon("paw"),"Bigfoot in the World"), 
               status = "navy", 
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               leafletOutput('bigfoot_map',width = "100%", height = 400),
               absolutePanel(id = "controls", class = "panel panel-default",
                             top = 380, left = 55, width = 250, fixed=TRUE,
                             draggable = TRUE, height = "auto",
                             #title = "Bigfoot Data Controls",
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
                                                   max(bigfoot_dat$most_recent_report)))
               ) #end of absolute panel for leaflet map of bigfoot.
           ),
           infoBoxOutput('total_summary'),
           infoBoxOutput('most_recent_report'),
           infoBoxOutput('recent_report_location')
    ), #end of column 1 in bigfoot page.
    column(width = 4,
           box(title = tagList(shiny::icon("map"),"Reports Broken Down by Region"), 
               status = "purple", 
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               height = 300,
               numericInput(
                 inputId = "binning_number",
                 label = "Number of Groups to Show",
                 value = 8,
                 min = 1,
                 max = 12
               ),
               plotlyOutput('bigfoot_barplot')#,
               # absolutePanel(class = "panel panel-default",
               #               top = 1000, left = 1250, width = 250, fixed=TRUE,
               #               draggable = T, height = "auto",
               #               title = "",
               #               numericInput(
               #                 inputId = "binning_number",
               #                 label = "Number of Groups to Show",
               #                 value = 8,
               #                 min = 1,
               #                 max = 12
               #               )
               #)
           )
    ) 
  ),#End of fluidRow 1.
  fluidRow(
    column(width = 12, 
           box(title = tagList(shiny::icon("newspaper"),"Bigfoot in the News"), 
               status = "teal", 
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               dataTableOutput('bigfoot_news_table')
           )
    ) #End of column 1 in fluidRow 2.
  ) #End of bottom fluidRow for bigfoot page.
) #End of bigfoot tabPanel.
