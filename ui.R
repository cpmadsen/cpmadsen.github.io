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
#library(summarywidget)

source("00_MainPage.R")
source("01_Basic.R")
source("02_BigFoot.R")
source("03_Advanced.R")

bigfoot_dat = read_sf("data/bigfoot_dat.gpkg")
map_centroids = read_csv("data/map_centroids.csv")

# Define UI for application that draws a histogram
ui = navbarPage(
    
    # Application title
    title = "Portfolio",
    
    # tags$head(
    #   tags$link(rel = "stylesheet", type = "text/css", href = "mainpage_styles.css")
    # ),
    
    #useShinydashboard(),
    
    home_panel,
    
    # tabPanel 1 - 
    tabPanel(title = "Simple Example"),
    
    # tabPanel 2 - 
    bigfoot_panel,
    
    # tabPanel 3 - 
    tabPanel(title = "Advanced Example")
  )