library(tidyverse)
library(sf)
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
  mutate(most_recent_report = my(most_recent_report)) %>% 
  rename(num_listings = of_listings) %>% 
  select(-last_posted)
  
can_dat = bind_rows(
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[8]],
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[9]]
) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  mutate(most_recent_report = my(most_recent_report)) %>% 
  rename(num_listings = of_listings) %>% 
  select(-last_posted)

int_dat = bind_rows(
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[11]],
  bigfoot %>% 
    html_table(header = T) %>% 
    .[[12]]
) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  mutate(most_recent_report = my(most_recent_report)) %>% 
  rename(num_listings = of_listings) %>% 
  select(-last_posted)

#Get USA state shapefiles, attach bigfoot USA data.
library(tigris)
states = tigris::states(resolution = '20m')

states = st_simplify(states, dTolerance = 500)

usa_sf = states %>% 
  rename(state = NAME) %>% 
  select(state) %>% 
  inner_join(usa_dat)

# library(fiftystater)
# usa_sf = sf::st_as_sf(fifty_states, coords = c("long", "lat")) %>% 
#   group_by(id, piece) %>% 
#   summarize(do_union=FALSE) %>%
#   st_cast("POLYGON") %>% 
#   ungroup() %>% 
#   group_by(id) %>% 
#   summarise() %>% 
#   mutate(state = str_to_title(id)) %>% 
#   dplyr::select(-id)
# 
# usa_sf = usa_sf %>% 
#   inner_join(usa_dat)

# Get Canada shapefile, simplify, and attach bigfoot data.
canada = raster::getData(country = 'CAN', level = 1)
canada = st_as_sf(canada)
canada_simple = sf::st_simplify(canada, dTolerance = 500)

canada_sf = canada_simple %>% 
  mutate(NAME_1 = replace(NAME_1, NAME_1 == "Québec", "Quebec")) %>% 
  rename(province = NAME_1) %>% 
  inner_join(can_dat) %>% 
  select(province,num_listings,most_recent_report)

#Get international country shapefiles, attach bigfoot international data.
world_sf = rnaturalearth::ne_countries(returnclass = "sf") %>% 
  mutate(admin = replace(admin, admin == "United States of America","USA"))

int_dat = int_dat %>% 
  rename(region = country_region) %>% 
  bind_rows(
    usa_dat %>% 
      summarise(num_listings = sum(num_listings),
                most_recent_report = max(most_recent_report)) %>% 
      mutate(region = "USA"),
    can_dat %>% 
      summarise(num_listings = sum(num_listings),
                most_recent_report = max(most_recent_report)) %>% 
      mutate(region = "Canada")
  )

world_sf = world_sf %>% 
  rename(region = admin) %>% 
  inner_join(int_dat) %>% 
  select(region,num_listings,most_recent_report)

bigfoot_dat = canada_sf %>% 
  rename(subunit = province) %>% 
  mutate(unit = "Canada") %>% 
  bind_rows(usa_sf %>% 
              rename(subunit = state) %>% 
              mutate(unit = "USA")) %>% 
  bind_rows(world_sf %>% 
              rename(subunit = region) %>% 
              mutate(unit = "World"))

bigfoot_dat = bigfoot_dat %>% 
  mutate(local_name = case_when(
    subunit == "China" ~ "野人",
    subunit == "Australia" ~ "Yowie",
    subunit == "Malaysia" ~ "Apemen",
    subunit == "Indonesia" ~ "Orang pendek",
    subunit == "Russia" ~ "Shurale",
    subunit == "Canada" ~ "Sasquatch",
    subunit == "USA" ~ "Bigfoot",
    unit == "Canada" ~ "Sasquatch",
    unit == "USA" ~ "Bigfoot"
  )
  )

write_sf(bigfoot_dat, "data/bigfoot_dat.gpkg")
# write_sf(usa_sf, "data/usa_bigfoot.gpkg")
# write_sf(canada_sf, "data/canada_bigfoot.gpkg")
# write_sf(world_sf, "data/international_bigfoot.gpkg")

# Make centroids that we can use to shift the focus of the 
# bigfoot map depending on the user input.
map_centroids = st_coordinates(
  bind_rows(
    usa_sf %>% st_centroid() %>% summarise() %>% st_centroid(),
    canada_sf %>% st_centroid() %>% summarise() %>% st_centroid(),
    world_sf  %>% 
      st_make_valid() %>% st_centroid() %>% summarise() %>% st_centroid()
  )
) %>% 
  as.data.frame() %>% 
  mutate(region = c("USA","Canada","World"),
         zoom = c(8,8,12)) %>% 
  as_tibble()

write_csv(map_centroids, "data/map_centroids.csv")
