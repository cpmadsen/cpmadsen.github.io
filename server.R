rm(list=ls())
setwd("F:/R Projects/cpmadsen.github.io")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  source(file.path('rock_gym_server.R'), local = T)$value
  source(file.path('bigfoot_server.R'), local = T)$value
  source(file.path('uk_cycling_server.R'), local = T)$value

})