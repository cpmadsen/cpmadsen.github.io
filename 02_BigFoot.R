### Measurements used throughout the UI design.

map_height = '500px'

### Elements within the tab

# # 1. Map controls
# mapcontrol_element = shinydashboardPlus::box(
#   collapsible = T,
#   width = 12,
#   height = map_height,
#   status = 'warning',
#   icon = icon('gear'),
#   title = "Map Controls",
#   selectInput(inputId = "bigfoot_filter",
#               label = "Select Area of Analysis",
#               multiple = F,
#               selectize = F,
#               selected = c("Canada"),
#               choices = c("Canada","USA","World")),
#   sliderInput(inputId = "bigfoot_daterange",
#               label = "Select Sighting Date Range",
#               min = year(min(bigfoot_dat$most_recent_report)),
#               max = year(max(bigfoot_dat$most_recent_report)),
#               value = c(year(min(bigfoot_dat$most_recent_report)),
#                         year(max(bigfoot_dat$most_recent_report))),
#               timeFormat = "%YYYY",
#               sep = ""
#   ),
#   footer = 'test footer')

# 2. Map for center of dashboard tab.
map_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("paw"),"Bigfoot in the World"), 
  status = "success",
  solidHeader = T,
  width = 12,
  height = map_height,
  sidebar = boxSidebar(
    id = 'mapcontrol_sidebar',
    width = 50,
    startOpen = F,
    selectInput(inputId = "bigfoot_filter",
                label = "Select Area of Analysis",
                multiple = F,
                selectize = F,
                selected = c("Canada"),
                choices = c("Canada","USA","World")),
    sliderInput(inputId = "bigfoot_daterange",
                label = "Select Sighting Date Range",
                min = year(min(bigfoot_dat$most_recent_report)),
                max = year(max(bigfoot_dat$most_recent_report)),
                value = c(year(min(bigfoot_dat$most_recent_report)),
                          year(max(bigfoot_dat$most_recent_report))),
                timeFormat = "%YYYY",
                sep = "")
  ),
  leafletOutput('bigfoot_map',height = map_height))

# 3. Vertical bar plot for beside map.
vertbarplot_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("map"),"Reports Broken Down by Region"), 
  width = 12,
  height = map_height,
  numericInput(
    inputId = "binning_number",
    label = "Number of Groups to Show",
    value = 8,
    min = 1,
    max = 12
  ),
  plotlyOutput('bigfoot_barplot')
)     

# 4. Summary Blocks

totalnumber_element = infoBoxOutput('total_summary')

recentdate_element = infoBoxOutput('most_recent_date')

recentplace_element = infoBoxOutput('most_recent_place')

# 5. Bigfoot in the news.
bigfootnews_element = shinydashboardPlus::box(
  title = tagList(shiny::icon("newspaper"),"Bigfoot in the News"),
  #gradient = T,
  width = 12,
  boxToolSize = 'sm',
  color = 'red',
  #solidHeader = T,
  dataTableOutput('bigfoot_news_table')
) 

### Design Blocks

toprow_block = fluidRow(
  #column(width = 3, mapcontrol_element),
  column(width = 8, map_element),
  column(width = 4, vertbarplot_element)
)

middlerow_block = fluidRow(
  totalnumber_element,
  recentdate_element,
  recentplace_element
)

bottomrow_block = fluidRow(bigfootnews_element)

### Panel design

bigfoot_panel = tabItem(
  tabName = "bigfoot",
  h2("Where in the World is Bigfoot?"),
  toprow_block,
  middlerow_block,
  bottomrow_block
)
