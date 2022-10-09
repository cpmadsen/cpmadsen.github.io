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
 style = sprintf(backgroundImageCSS,"waterfall_gif.gif"),
 # img(src="waterfall_gif.gif", align = "left",height='500px',width='400px'),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
           align = "center",
           h1("EXPLORE. VISUALIZE. INFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ), 
  
  #material_parallax(image_source = background_img_1),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
                    align = "center",
                    h1("DESIGN. PERFECT. PERFORM."),
                    tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ),
  
  #material_parallax(image_source = background_img_2),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
                    align = "center",
                    h1("DESIGN. PERFECT. PERFORM."),
                    tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ),
  
  #material_parallax(image_source = background_img_3)
)