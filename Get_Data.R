library(tidyverse)
library(rvest)
library(snakecase)
library(lubridate)
library(rnaturalearth)
library(rgeos)

rm(list = ls())
gc()

bigfoot = read_html("https://www.bfro.net/GDB/default.asp")

usa_dat = bind_rows(
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[5]],
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[6]]
  ) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  mutate(most_recent_report = my(most_recent_report),
         last_posted = my(last_posted)) %>% 
  rename(num_listings = of_listings)
  
can_dat = bind_rows(
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[8]],
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[9]]
) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  mutate(most_recent_report = my(most_recent_report),
         last_posted = my(last_posted)) %>% 
  rename(num_listings = of_listings)

int_dat = bind_rows(
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[11]],
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[12]]
) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  mutate(most_recent_report = my(most_recent_report),
         last_posted = my(last_posted)) %>% 
  rename(num_listings = of_listings)

#Get USA state shapefiles, attach bigfoot USA data.
library(fiftystater)
usa_sf = sf::st_as_sf(fifty_states, coords = c("long", "lat")) %>% 
  group_by(id, piece) %>% 
  summarize(do_union=FALSE) %>%
  st_cast("POLYGON") %>% 
  ungroup() %>% 
  group_by(id) %>% 
  summarise() %>% 
  mutate(state = str_to_title(id)) %>% 
  dplyr::select(-id)

usa_sf = usa_states %>% 
  inner_join(usa_dat)

# Get Canada shapefile, simplify, and attach bigfoot data.
canada = raster::getData(country = 'CAN', level = 1)
canada = st_as_sf(canada)
canada_simple = sf::st_simplify(canada, dTolerance = 500)

canada_sf = canada_simple %>% 
  mutate(NAME_1 = replace(NAME_1, NAME_1 == "Québec", "Quebec")) %>% 
  rename(province = NAME_1) %>% 
  inner_join(can_dat)

#Get international country shapefiles, attach bigfoot international data.
world_sf = rnaturalearth::ne_countries(returnclass = "sf")

world_sf = world_sf %>% 
  rename(country_region = admin) %>% 
  inner_join(int_dat) %>% 
  select(country_region,num_listings,most_recent_report,last_posted)

write_sf(usa_sf, "data/usa_bigfoot.gpkg")
write_sf(canada_sf, "data/canada_bigfoot.gpkg")
write_sf(world_sf, "data/international_bigfoot.gpkg")
