### Static Options

my_palette = "Dark2"
box_height = '400px'
halfbox_h = '200px'

### Elements

# 1. Summary boxes
# month_pick_input = sliderTextInput(
#   inputId = 'months_picked',
#   label = "Month", 
#   choices = c("Jan","Feb","Mar","Apr","May","Jun"),
#   selected = c("May","Jun"),
#   width = '100%'
# )

month_pick_input = sliderInput(
  inputId = 'months_picked',
  label = "",
  min = 1, 
  max = 6,
  value = c(5:6),
  width = '100%'
)

# gross_profit_summary_box_element = textOutput('gross_profit_text')
# 
# gross_profit_summary_change_box_element = textOutput('gross_profit_change_text')

# gross_profit_summary_box_element = valueBox(
#   value = rock_dat %>%
#     filter(location == "Vancouver") %>%
#     slice_tail(n = 1) %>%
#     pull(gross_profit),
#   "Gross",
#   icon = icon('dollar'),
#   color = 'purple',
#   width = 12
# )

# 2. Membership line graph
membership_line_element = plotly::ggplotly(
  rock_dat %>% 
    ggplot(aes(x = date, y = members)) + 
    geom_col(aes(fill = location), 
             color = 'black',
             position = position_dodge2(padding = 0.3)) +
    geom_line(aes(col = location, group = location),
              alpha = 0.8,
              size = 1) +
    geom_point(aes(x = date, y = members, col = location), 
               shape = 1, size = 4, stroke = 1) +
    scale_y_continuous(limits = c(0,1200)) + 
    scale_fill_brewer(palette = my_palette) +
    scale_color_brewer(palette = my_palette) +
    labs(title = 'Membership',
         fill = "Location",
         x = "Month", 
         y = "Number of Subscription Members") + 
    theme_minimal() + 
    theme(axis.title = element_text(size = 16),
          axis.text = element_text(size = 14),
          title = element_text(size = 20, face = 'bold')) + 
    guides(col = "none"),
  height = as.numeric(str_extract(box_height,"[0-9]*"))
)

# 3. Employee line graph
employee_line_element = plotly::ggplotly(
  rock_dat %>% 
    ggplot(aes(x = date, y = employees)) + 
    geom_col(aes(fill = location), 
             col = 'black',
             position = position_dodge2(padding = 0.3)) +
    geom_line(aes(col = location, group = location),
              alpha = 0.8,
              size = 1) +
    geom_point(aes(x = date, y = employees, col = location),
               shape = 1, size = 4, stroke = 1) +
    scale_y_continuous(limits = c(0,70)) + 
    scale_fill_brewer(palette = my_palette) +
    scale_color_brewer(palette = my_palette) +
    labs(title = 'Employees',
         fill = "Location",
         x = "Month", 
         y = "Number of Employees") + 
    theme_minimal() + 
    theme(axis.title = element_text(size = 16),
          axis.text = element_text(size = 14),
          title = element_text(size = 20, face = 'bold')) + 
    guides(col = "none"),
  height = as.numeric(str_extract(box_height,"[0-9]*"))
)

# 4. Gross Profit Breakdown Line Graph
gross_prof_line_element = plotly::ggplotly(
  rock_dat %>% 
    pivot_longer(cols = c("revenue","cost","gross_profit"), 
                 names_to = "Type",values_to = "Amount") %>% 
    mutate(Type = case_when(
      Type == 'revenue' ~ 'Revenue',
      Type == 'cost' ~ 'Cost',
      Type == 'gross_profit' ~ "Gross Profit",
      T ~ Type 
    )) %>% 
    mutate(Type = factor(Type, levels = c("Revenue","Cost","Gross Profit"))) %>% 
    group_by(date,Type) %>% 
    summarise(Amount = sum(Amount)) %>% 
    ggplot(aes(x = date, y = Amount)) + 
    geom_col(aes(fill = Type), 
             color = 'black',
             position = position_dodge2(padding = 0.3)) +
    geom_line(aes(col = Type, group = Type),
              alpha = 0.8,
              size = 1) +
    geom_point(aes(x = date, y = Amount, col = Type), 
               shape = 1, size = 4, stroke = 1) +
    scale_y_continuous(limits = c(0,50000),
                       labels = scales::pretty_breaks()) + 
    scale_fill_brewer(palette = my_palette) +
    scale_color_brewer(palette = my_palette) +
    labs(title = 'Gross Profit Breakdown',
         fill = "",
         x = "Month", 
         y = "Month Total ($ CAD)") + 
    theme_minimal() + 
    theme(axis.title = element_text(size = 16),
          axis.text = element_text(size = 14),
          title = element_text(size = 20, face = 'bold')) + 
    guides(col = "none"),
  height = as.numeric(str_extract(box_height,"[0-9]*"))
)

gross_profit_summary_element = div(
  h3('Gross Profit'),
  valueBoxOutput('gross_profit_summary',width = '100%'))

gross_profit_change_summary_element = div(
  h3('Gross Profit Change'),
  valueBoxOutput('gross_profit_change_summary', width = '100%'))

revenue_summary_element = div(
  h3('Revenue'),
  valueBoxOutput('revenue_summary',width = '100%'))

revenue_change_summary_element = div(
  h3('Revenue Change'),
  valueBoxOutput('revenue_change_summary', width = '100%'))

cost_summary_element = div(
  h3('Cost Profit'),
  valueBoxOutput('cost_summary',width = '100%'))

cost_change_summary_element = div(
  h3('Cost Change'),
  valueBoxOutput('cost_change_summary', width = '100%'))

### Design Blocks

top_row = fluidRow(
    column(width = 4,
           fluidRow(box(revenue_summary_element, width = 12, height = halfbox_h)),
           fluidRow(box(revenue_change_summary_element, width = 12, height = halfbox_h))
    ),
    column(width = 8,
           box(gross_prof_line_element, width = 12, height = box_height)
    )
)

# Was from style of box
# width = 12, 
# height = box_height,
# style = 'text-size:20px'
# #tags$style(HTML('height:400px;'))
middle_row = fluidRow(
    column(width = 4,
           fluidRow(box(cost_summary_element, width = 12, height = halfbox_h)),
           fluidRow(box(cost_change_summary_element, width = 12, height = halfbox_h))
    ),
    column(width = 8,
           box(membership_line_element, width = 12, height = box_height)
    )
)

bottom_row = fluidRow(
    column(width = 4,
           fluidRow(box(gross_profit_summary_element, width = 12, height = halfbox_h)),
           fluidRow(box(gross_profit_change_summary_element, width = 12, height = halfbox_h))
    ),
    column(width = 8,
           box(employee_line_element, width = 12, height = box_height)
    )
)

rock_gym = tabItem(
  tabName = "rock_gym",
  # title = "CFO Dashboard (June, 2022)",
  box(title = "Month to Compare", month_pick_input, width = 10),
  top_row,
  middle_row,
  bottom_row
)