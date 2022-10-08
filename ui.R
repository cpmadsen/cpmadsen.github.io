library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinymaterial)
library(shinyjs)
library(tidyverse)
library(sf)
library(leaflet)
library(leaflet.extras)
library(leaflet.extras2)
library(plotly)
library(DT)
library(lubridate)
library(scales)
library(feedeR)
library(slickR)
library(htmltools)

rm(list = ls())
setwd("F:/R Projects/cpmadsen.github.io/")

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")
uk_map_polys = read_sf("data/cyclingUK/uk_map_polys.gpkg")
uk_map_dat = read_csv("data/cyclingUK/uk_map_data.csv")
background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
background_img_2 = "carousel_pictures/river_view.png"
background_img_3 = "carousel_pictures/Germany_BlackForest.png"

source("00_MainPage.R")
source("01_Basic.R")
source("02_BigFoot.R")
source("03_UK_Cycling.R")


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
             "Cycling in England" = "uk_cycling")
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
  
  cycling_panel
  # tabPanel 1 - 
  # tabPanel(title = "Simple Example"),
  # 
  # # tabPanel 2 - 
  # bigfoot_panel,
  # 
  # # tabPanel 3 - 
  # tabPanel(title = "Advanced Example")
)