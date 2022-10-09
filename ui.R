library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
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
source("02_BigFoot.R")
source("03_UK_Traffic.R")


# Define UI for application that draws a histogram
ui = shinydashboardPlus::dashboardPage(
  
  skin = 'black',
  
  #useShinyjs(),
  dashboardHeader(title = "CMadsen Portfolio"
  ),
  dashboardSidebar(
    sidebarMenu(
      id = 'tabs',
      shinydashboard::menuItem("Home", tabName = 'home', badgeColor = "green"),
      shinydashboard::menuItem("Where in the World is Bigfoot?", tabName = 'bigfoot'),
      shinydashboard::menuItem('Traffic in the UK', tabName = 'uk_traffic')
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    tabItems(
      main_page,
      bigfoot_panel,
      uk_traffic
    )
  )
)