### Measurements used throughout the UI design.

uk_map_height = '500px'

### Elements within the tab

# 1. Year selector for data.
uk_year_selector_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("calendar"),"Cycling Stats Year Selector"), 
  status = "success",
  solidHeader = T,
  width = 12,
  sliderInput(inputId = 'uk_cycling_year',
            label = 'Year of Analysis',
            min = min(uk_cyclingaccs$year),
            max = max(uk_cyclingaccs$year),
            value = 2005,
            animate = T,
            width = '90%',
            sep = "")
)

# 2 (multi) Summary infoboxes (6)
uk_cycling_total_fatalities = infoBoxOutput('uk_fatal_accidents', width = 4)
uk_cycling_total_serious_injures = infoBoxOutput('uk_serious_accidents', width = 4)
uk_cycling_total_accidents = infoBoxOutput('uk_total_accidents', width = 4)
uk_cycling_total_projects = infoBoxOutput('uk_tot_proj', width = 4)
uk_cycling_total_schemes_cost = valueBoxOutput('uk_tot_scheme_cost', width = 4)
uk_cycling_df_t_funding = infoBoxOutput('uk_tot_df_t_funding', width = 4)

# 3. Map for center of dashboard tab.
uk_cycling_map_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("map")," Cycling Accidents in England"),
  status = "navy",
  solidHeader = T,
  collapsible = T,
  width = 12,
  height = uk_map_height,
  leafletOutput('uk_cycling_leaflet', height = uk_map_height)
)

# 4. Linegraph of accidents by region
uk_cycling_linegraph_element = plotOutput('cycling_lineplot', height = '250px')

# 5. Donut plot of accidents by region
cycling_acc_region_donut_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("circle")," Accidents by Region Donut"),
  status = "purple",
  solidHeader = T,
  collapsible = T,
  width = 12,
  height = uk_map_height,
  plotlyOutput('cycling_acc_region_donut', height = uk_map_height)
)
#cycling_acc_region_donut_element = plotlyOutput('cycling_acc_region_donut', height = uk_map_height)

### Design Blocks
uk_toprow_block = fluidRow(uk_year_selector_element)

uk_map_block = fluidRow(
  column(width = 4,
         cycling_acc_region_donut_element),
  column(width = 8,
         uk_cycling_map_element
  )
)

uk_linegraph_block = fluidRow(
  shinydashboardPlus::box(
    title = tagList(shiny::icon("figure")," Time Analysis"), 
    status = "primary",
    solidHeader = T,
    collapsible = T,
    width = 12,
    uk_cycling_linegraph_element
  )
)

uk_thirdrow_block = fluidRow(
  shinydashboardPlus::box(
    title = tagList(shiny::icon("thumbs-up")," Positive Summaries"), 
    status = "success",
    solidHeader = T,
    collapsible = T,
    uk_cycling_total_projects,
    uk_cycling_total_schemes_cost,
    uk_cycling_df_t_funding
  ),
  shinydashboardPlus::box(
    title = tagList(shiny::icon("thumbs-down")," Negative Summaries"), 
    status = "danger",
    solidHeader = T,
    collapsible = T,
    uk_cycling_total_fatalities,
    uk_cycling_total_serious_injures,
    uk_cycling_total_accidents
  )
)

### Panel design


uk_cycling = tabItem(
  tabName = 'uk_cycling',
 
  uk_toprow_block,
  
  uk_map_block,
  
  uk_linegraph_block,
  
  uk_thirdrow_block
)