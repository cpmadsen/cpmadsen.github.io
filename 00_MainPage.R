background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
background_img_2 = "carousel_pictures/river_view.png"
background_img_3 = "carousel_pictures/Germany_BlackForest.png"

backgroundImageCSS <- "/* background-color: #cccccc; */
                       height: 100vh;
                       background-position: absolute;
                       background-repeat: no-repeat;
                       background-attachment: scroll;
                       background-size: cover;
                       background-image: url('%s');
                       "

home_panel = #shinymaterial::material_page(
  #include_nav_bar = F,
  tabPanel(title = "Home",
  
  #tags$script(src = "Javascript_Parallax.js"),
  
  fluidRow(
    column(width = 2),
    column(width = 8,
           align = "center",
           h1("EXPLORE. VISUALIZE. INFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    column(width = 2)
  ), 
  
  #material_parallax(image_source = background_img_2),
  
  # material_row(
  #   material_column(width = 2),
  #   material_column(width = 8,
  #                   align = "center",
  #                   h1("DESIGN. PERFECT. PERFORM."),
  #                   tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
  #   ),
  #   material_column(width = 2)
  # ), 
  style = sprintf(backgroundImageCSS,  background_img_1)
  
  
  # #slickROutput("slickr", width="200%",height="300px"),
  # 
  # # parent container
  # shiny::panel(class="landing-wrapper",
  #          
  #          # child element 1: images
  #          tags$div(class="landing-block background-content",
  #                   
  #                   # first image
  #                   img(src=background_img_1),
  #                   
  #                   HTML("<br><br><br><br><br><br><br><br><br>"),
  #                   
  #                   # second image
  #                   img(src=background_img_2),
  #                   
  #                   HTML("<br><br><br><br><br><br><br><br><br>"),
  #                   
  #                   # third image
  #                   img(src=background_img_3)
  #                   
  #          ),
  #          
  #          # child element 2: content
  #          tags$div(class="landing-block foreground-content",
  #                   tags$div(class="foreground-text",
  #                            tags$h1("Welcome"),
  #                            tags$p("This shiny app demonstrates
  #                                how to create a 2 x 2 layout
  #                                         using css grid and
  #                                         overlaying content."),
  #                            tags$p("Isn't this cool?"),
  #                            tags$p("Yes it is!")
  #                   )
  #          )
  # )
  # )
)