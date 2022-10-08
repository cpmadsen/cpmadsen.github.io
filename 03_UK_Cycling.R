cycling_panel = material_tab_content(
  tab_id = 'uk_cycling',
  material_side_nav(
    shiny.fluent::Slider.shinyInput(inputId = 'cycling_year',
                                    label = "",
                                    min = min(uk_map_dat$Year),
                                    max = max(uk_map_dat$Year),
                                    value = max(uk_map_dat$Year))
  ),
  material_row(
    material_column(
      material_card(title = 'type summary 1'),
      material_card(title = "type summary 2")
    ),
    material_card(title = 'map',
                  leafletOutput('cycling')),
    material_column(
      material_card(title = "blast summaries"),
      material_card(title = "table summary")
    )
  ),
  material_row(
    material_card(title = 'bar chart'),
    material_card(title = 'plot'),
    material_card(title = 'something else')
  )
)