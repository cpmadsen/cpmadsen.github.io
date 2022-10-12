# # # # # # # # # #
# Tab 1 - Rock Gym#
# # # # # # # # # #

RockDat = reactive({
  rock_dat %>%
    mutate(month = month(date)) %>%
    filter(month >= input$months_picked[1],
           month <= input$months_picked[2])
})

# Summary stats

output$rock_dat_test = renderDataTable({
  RockDat()
})

output$gross_profit_summary = renderValueBox({
  valueBox(
    subtitle = "Gross",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(gross_profit = last(gross_profit)) %>%
      pull(gross_profit),
    icon = icon('dollar'),
    color = 'green'
  )
})

output$gross_profit_change_summary = renderValueBox({
  valueBox(
    subtitle = "Change",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(gross_profit_change = round(100*(last(gross_profit) - first(gross_profit))/last(gross_profit),1)) %>%
      pull(gross_profit_change),
    icon = icon('triangle'),
    color = 'blue'
    )
})

output$revenue_summary = renderValueBox({
  valueBox(
    subtitle = "Gross",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(revenue = last(revenue)) %>%
      pull(revenue),
    icon = icon('dollar'),
    color = 'orange'
  )
})

output$revenue_change_summary = renderValueBox({
  valueBox(
    subtitle = "Change",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(revenue_change = round(100*(last(revenue) - first(revenue))/last(revenue),1)) %>%
      pull(revenue_change),
    icon = icon('triangle'),
    color = 'purple'
  )
})

output$cost_summary = renderValueBox({
  valueBox(
    subtitle = "Gross",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(cost = last(cost)) %>%
      pull(cost),
    icon = icon('dollar'),
    color = 'navy'
  )
})

output$cost_change_summary = renderValueBox({
  valueBox(
    subtitle = "Change",
    value = RockDat() %>%
      filter(location == "Vancouver") %>%
      summarise(revenue_change = round(100*(last(cost) - first(cost))/last(cost),1)) %>%
      pull(revenue_change),
    icon = icon('triangle'),
    color = 'teal'
  )
})