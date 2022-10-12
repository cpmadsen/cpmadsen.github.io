library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinyjs)
library(tidyverse)
library(ggiraph)
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
library(mailtoR)

rm(list = ls())
setwd("F:/R Projects/cpmadsen.github.io/")

rock_dat = read_csv("data/rock_dat.csv")
bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")
# uk_map_polys = read_sf("data/cyclingUK/uk_map_polys.gpkg")
# uk_map_dat = read_csv("data/cyclingUK/uk_map_data.csv")
# uk_traffic_dat = readxl::read_excel('data/cyclingUK/CyclingAccidentOutcomes_region.xlsx')
uk_cyclingaccs = read_sf("data/cyclingUK/uk_cyclingaccidents.gpkg")
uk_cyclingacc_outcomes = readxl::read_excel('data/cyclingUK/cycling_accident_outcome_summaries.xlsx')
background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
background_img_2 = "carousel_pictures/river_view.png"
background_img_3 = "carousel_pictures/Germany_BlackForest.png"

source("HelperFunctions.R")
source("00_MainPage.R")
source("01_RockClimbingGym.R")
source("02_BigFoot.R")
source("03_UK_Cycling.R")

# Define UI for application that draws a histogram
ui = shinydashboardPlus::dashboardPage(
  
  skin = 'black',
  
  #useShinyjs(),
  dashboardHeader(
    title = "Madsen Analytics"
  ),
  dashboardSidebar(
    sidebarMenu(
      id = 'tabs',
      shinydashboard::menuItem("Home", tabName = 'home', badgeColor = "green"),
      shinydashboard::menuItem("Rock Climbing Gym Dashboard", tabName = "rock_gym"),
      shinydashboard::menuItem("Where in the World is Bigfoot?", tabName = 'bigfoot'),
      shinydashboard::menuItem('Traffic in the UK', tabName = 'uk_cycling')
    )
  ),
  dashboardBody(
    tabItems(
      main_page,
      rock_gym,
      bigfoot_panel,
      uk_cycling
    ),
    tags$head(tags$style(HTML('* {font-family: "-webkit-body"};')))
  ),
  footer = dashboardFooter(
    left = fluidRow(
      column(width = 6,
             div(
               tags$a(
                 icon(name = 'envelope',
                      style = 'font-size:70px;'),
                 href = "mailto:madsen.chris26@gmail.com")),
             style = 'text-align:right;'),
      column(width = 6,
             div(
               tags$a(
                 icon(name = 'linkedin',
                      style = 'font-size:70px;'),
                 href = "https://www.linkedin.com/in/christopher-madsen-a164521a7/"))
      )
    )
  )
)