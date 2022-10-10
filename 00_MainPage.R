# background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
# background_img_2 = "carousel_pictures/river_view.png"
# background_img_3 = "carousel_pictures/Germany_BlackForest.png"

backgroundImageCSS <- "/* background-color: #cccccc; */
                       height: 91vh;
                       background-position: center;
                       background-repeat: no-repeat;
                       /* background-size: cover; */
                       background-image: url('%s');
                       "

main_page = tabItem(
  tabName = "home",
  
  #tags$script(src = "Javascript_Parallax.js"),
  # shinyWidgets::setBackgroundImage(src = "waterfall_gif.gif", 
  #                                  shinydashboard = T),
  
  fluidRow(column(width = 8,
                  h2("Explore your Data to Make Informed Decisions"),
                  HTML("<br><br><br>"),
                  h4("Financial records and databases can seem opaque and confusing; however, I can make your data transparent and highlight important trends and decision points."),
                  HTML("<br><br><br>"),
                  h4("With over 6 years of experience analysing and visualizing tabular and spatial datasets, I've learned efficient workflows for producing meaningful figures and reports."),
                  HTML("<br><br><br>"),
                  h4("Best of all, informative dashboards don't have to break the bank - explore the example dashboards in my portfolio to see what can be produced in 5 - 20 hours of work.")
  ),
  column(
    width = 4,
    style = sprintf(backgroundImageCSS,"waterfall_gif.gif")
  )
  ),

  fluidRow(
    column(width = 2),
    column(width = 8,
           align = "center",
           h1("EXPLORE. VISUALIZE. INFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ), 
  
  parallax_image(background_img_1),
  
  p("This is a test",
    style = "height:1000px;background-color:red;font-size:36px"),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
           align = "center",
           h1("DESIGN. PERFECT. PERFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ),
  
  parallax_image(background_img_2),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
           align = "center",
           h1("DESIGN. PERFECT. PERFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ),
  
  parallax_image(background_img_3)
)