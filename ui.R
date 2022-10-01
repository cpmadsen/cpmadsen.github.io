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
           selectInput(inputId = "bigfoot_filter",
                       label = "",
                       multiple = F,
                       selectize = F,
                       selected = c("Canada"),
                       choices = c("Canada","USA","World")),
           leafletOutput('bigfoot_map')),
  
  # tabPanel 3 - 
  tabPanel(title = "Advanced Example")
)
