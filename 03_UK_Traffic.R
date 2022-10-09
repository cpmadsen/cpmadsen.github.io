uk_traffic = tabItem(
  tabName = 'uk_traffic',
  # material_side_nav(
  #   shiny.fluent::Slider.shinyInput(inputId = 'cycling_year',
  #                                   label = "",
  #                                   min = min(uk_map_dat$Year),
  #                                   max = max(uk_map_dat$Year),
  #                                   value = max(uk_map_dat$Year))
  # ),
  fluidRow(
    column( width = 3,
      shinydashboardPlus::box(title = 'type summary 1'),
      shinydashboardPlus::box(title = "type summary 2")
    ),
    column(width = 6,
    shinydashboardPlus::box(title = 'map',
                  leafletOutput('cycling'))),
    column(width = 3,
      shinydashboardPlus::box(title = "blast summaries"),
      shinydashboardPlus::box(title = "table summary")
    )
  ),
  fluidRow(
    shinydashboardPlus::box(title = 'bar chart'),
    shinydashboardPlus::box(title = 'plot'),
    shinydashboardPlus::box(title = 'something else')
  )
)