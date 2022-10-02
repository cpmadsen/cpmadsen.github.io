library(shiny)
library(tidyverse)
library(leaflet)
library(leaflet.extras)

source("01_Basic.R")
#source("02_BigFoot.R")
source("03_Advanced.R")
source("CarouselSlider.R")

# Define UI for application that draws a histogram
ui = navbarPage(

  # Application title
  title = "Portfolio",
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "mainpage_styles.css")
  ),
  
  # tabPanel 1 - 
  tabPanel(title = "Simple Example"),
  
  # tabPanel 2 - 
  tabPanel(title = "Where in the world is Bigfoot?",
           leafletOutput('bigfoot_map'),
           absolutePanel(id = "controls", class = "panel panel-default",
                         top = 75, left = 55, width = 250, fixed=TRUE,
                         draggable = TRUE, height = "auto",
                         title = "Bigfoot Data Controls",
             selectInput(inputId = "bigfoot_filter",
                         label = "Select Area of Analysis",
                         multiple = F,
                         selectize = F,
                         selected = c("Canada"),
                         choices = c("Canada","USA","World")),
             # selectInput(inputId = "bigfoot_plotvar",
             #             label = "Select Variable to Visualize",
             #             multiple = F,
             #             selectize = F,
             #             selected = ("Number of reports"),
             #             choices = c("Number of reports","Date of most recent report")),
             sliderInput(inputId = "bigfoot_daterange",
                         label = "Select Sighting Date Range",
                         min = min(bigfoot_dat$most_recent_report),
                         max = max(bigfoot_dat$most_recent_report),
                         value = c(min(bigfoot_dat$most_recent_report),
                                   max(bigfoot_dat$most_recent_report)))
           )),
  
  # tabPanel 3 - 
  tabPanel(title = "Advanced Example")
)
