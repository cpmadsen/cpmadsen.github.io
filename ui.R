library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(tidyverse)
library(sf)
library(shinyjs)
library(leaflet)
library(leaflet.extras)
library(plotly)
library(DT)
library(shinyWidgets)
library(shinymaterial)

source("00_MainPage.R")
source("01_Basic.R")
source("02_BigFoot.R")
source("03_Advanced.R")

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")
background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
background_img_2 = "carousel_pictures/river_view.png"
background_img_3 = "carousel_pictures/Germany_BlackForest.png"

# Define UI for application that draws a histogram
ui = material_page(
  
  useShinyjs(),
  title = "Portfolio",
  
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "mainpage_styles.css")
  # ),
  
  material_tabs(
    tabs = c("Home" = "home",
             "Example 1" = "example_1",
             "Where in the World is Bigfoot?" = "bigfoot_tab",
             "Example 3" = "example_3")
  ),
  #Define tab content.
  
  home_panel,
  
  material_tab_content(
    tab_id = 'example_1',
    material_card(
      title = "Card 1",
      h3("This is a test")
    )
  ),
  
  bigfoot_panel,
  
  material_tab_content(
    tab_id = 'example_3',
    material_card(
      title = "Card",
      h1("Hello world!")
    )
  )
  # tabPanel 1 - 
  # tabPanel(title = "Simple Example"),
  # 
  # # tabPanel 2 - 
  # bigfoot_panel,
  # 
  # # tabPanel 3 - 
  # tabPanel(title = "Advanced Example")
)