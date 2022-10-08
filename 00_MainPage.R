# background_img_1 = "carousel_pictures/Germany_Dresden_ForestCenterTown.png"
# background_img_2 = "carousel_pictures/river_view.png"
# background_img_3 = "carousel_pictures/Germany_BlackForest.png"

main_page = material_tab_content(
  tab_id = "home",

  #tags$script(src = "Javascript_Parallax.js"),
  
  material_row(
    material_column(width = 2),
    material_column(width = 8,
           align = "center",
           h1("EXPLORE. VISUALIZE. INFORM."),
           tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    material_column(width = 2)
  ), 
  
  material_parallax(image_source = background_img_1),
  
  material_row(
    material_column(width = 2),
    material_column(width = 8,
                    align = "center",
                    h1("DESIGN. PERFECT. PERFORM."),
                    tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    material_column(width = 2)
  ),
  
  material_parallax(image_source = background_img_2),
  
  material_row(
    material_column(width = 2),
    material_column(width = 8,
                    align = "center",
                    h1("DESIGN. PERFECT. PERFORM."),
                    tags$style(type="text/css", "#string { height: 100px; width: 100%; text-align:center; font-size: 50px;}")
    ),
    material_column(width = 2)
  ),
  
  material_parallax(image_source = background_img_3)
)