library(geodata)
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




#### Cycling in the UK

setwd("data/cyclingUK/")

uk_map = read_sf('UK_DISTRICTS_COUNTIES_CENSUS2011.shp')

uk_map = uk_map %>%
  dplyr::select(LAD11NM,ALL_RES) %>%
  rename(name = LAD11NM,
         population = ALL_RES)

uk_map_simpler = uk_map %>%
  st_make_valid() %>%
  group_by(name) %>%
  summarise(population = sum(population)) %>%
  st_simplify(uk_map, dTolerance = 1000)


ggplot() + geom_sf(data = uk_map_simpler %>% filter(name == "Birmingham")) + 
  geom_sf(data = uk_map %>% filter(name == "Birmingham"))

# Subset the geographic data for just those areas we have data.
uk_map_sub = 
  uk_map_simpler %>% 
  filter(str_detect(name, "(Yorkshire|Cambridgeshire|Bristol|Manchester|Norwich|Birmingham)")) %>%
  mutate(name = replace(name, str_detect(name, "Cambridgeshire"), "Cambridgeshire")) %>% 
  group_by(name) %>% 
  summarise(population = sum(population)) %>% 
  mutate(region = case_when(
    name == "Cambridgeshire" ~ "East of England", 
    name == "Bristol, City of" ~ "South West", 
    name == "Birmingham" ~ "West Midlands", 
    name == "East Riding of Yorkshire" ~ "Yorkshire and the Humber", 
    name == "Manchester" ~ "North West", 
    name == "Norwich" ~ "East of England"
  ))

ggplot() + geom_sf(data = uk_map_sub)

# Read in cycling data.
cycle_safety_fund = readxl::read_excel('Cycling-Walking-Investment-Schedule.xlsx', 
                   sheet = 'Cycle Safety Fund', skip = 1) %>% 
  setNames(to_snake_case(colnames(.))) %>% 
  .[-7,c(2,5)] %>% 
  setNames(c('city','y2018_19')) %>% 
  mutate(city = case_when(
    str_detect(city, "Bristol") ~ "Bristol, City of",
    str_detect(city, "Birmingham") ~ "Birmingham",
    str_detect(city, "Cambridgeshire") ~ "Cambridgeshire",
    str_detect(city, "Yorkshire") ~ "East Riding of Yorkshire",
    str_detect(city, "Manchester") ~ "Manchester",
    str_detect(city, "Norwich") ~ "Norwich",
    T ~ "Missing"
  )) %>% 
  rename(name = city)

# Attach the cycling data.
uk_map_sub = uk_map_sub %>% 
  inner_join(cycle_safety_fund)

# traffic_accidents = c(2012:2021) %>% 
#   map(~ readxl::read_excel('All_road_accidents_not_just_cycling.xlsx', sheet = paste0('NTS0623_',as.character(.x))) %>% 
#         mutate(year = .x)) %>% 
#   map(~ .x %>% .[c(10:19),c(1,7,8)] %>% 
#         setNames(c("TrafficAccidents","Unweighted"))) %>% 
#   bind_rows()
# 
# colnames(traffic_accidents)[2] = "NationalTrafficAccidents"
# colnames(traffic_accidents)[3] = "Year"
# 
# #Attach the traffic accident data
# uk_map_sub %>% 
#   left_join(traffic_accidents %>% 
#               mutate(NationalTrafficAccidents = as.numeric(NationalTrafficAccidents)) %>% 
#               group_by(Year) %>% 
#               summarise(NationalTrafficAccidents = sum(NationalTrafficAccidents)))

# Read in cycling-specific accidents
#cycling_acc_outcomes = readxl::read_excel('CyclingAccidentOutcomes_byOutcome.xlsx')

cycling_acc_regions = readxl::read_excel('CyclingAccidentOutcomes_region.xlsx')

uk_map_sub = uk_map_sub %>% 
  left_join(cycling_acc_regions %>% 
              rename(region = Region))

map_data = uk_map_sub %>% 
  st_drop_geometry() %>% 
  pivot_longer(cols = starts_with('20'), names_to = 'Year', values_to = 'AccNumber')
  
uk_map_sub = uk_map_sub %>% 
  select(name)

write_csv(map_data, "data/cyclingUK/uk_map_data.csv")

write_sf(uk_map_sub,"data/cyclingUK/uk_map_polys.gpkg")


### Just England traffic map.
england_sf = rnaturalearth::ne_states(geounit = 'england', returnclass = 'sf')

uk_traffic_dat = readxl::read_excel('data/cyclingUK/CyclingAccidentOutcomes_region.xlsx') %>% 
  rename(region = Region) %>% 
  mutate(region = case_when(
    region == "London" ~ "Greater London",
    region == "East of England" ~ "East",
    T ~ region))

england_sf = england_sf %>% 
  group_by(region) %>% 
  summarise()

cyclingaccidents = england_sf %>% 
  left_join(uk_traffic_dat)

cyclingaccidents_l = cyclingaccidents %>% 
  pivot_longer(cols = starts_with('20'), names_to = 'year', values_to = 'num_accidents')

cyclingaccidents_l = cyclingaccidents_l %>% 
  mutate(year = as.numeric(year),
         num_accidents = round(num_accidents))

# Cycle Rail Awards

rail_awards = read_csv('data/cyclingUK/cycle-rail-fund-awards.csv')

rail_awards = rail_awards %>% 
  mutate(Region = case_when(
    str_detect(Region, "York") ~ "Yorkshire and the Humber",
    Region == "East/South East" ~ "East",
    Region == "East of England" ~ "East",
    Region == "London" ~ "Greater London",
    Region == "NorthWest" ~ "North West",
    Region == "East of England and West Midlands" ~ "East",
    Region == "South" ~ "South West",
    T ~ Region
  ))

rail_awards = rail_awards %>% 
  setNames(snakecase::to_snake_case(colnames(.))) %>% 
  mutate(financial_year = str_extract(financial_year,"[0-9]*(?=\\/)")) %>%
  mutate(total_scheme_cost = as.numeric(str_remove(str_extract(total_scheme_cost,"[0-9]{1}.*"), "\\,")),
         df_t_funding = as.numeric(str_remove(str_extract(df_t_funding,"[0-9]{1}.*"), "\\,"))) %>% 
  group_by(region,financial_year) %>% 
  summarise(annual_total_schemes_cost = sum(total_scheme_cost,na.rm=T),
            annual_df_t_funding = sum(df_t_funding,na.rm=T),
            total_projects_by_region = n()) %>% 
  filter(!is.na(region))

cyclingaccidents_l = cyclingaccidents_l %>% 
  left_join(rail_awards %>% 
              rename(year = financial_year) %>% 
              mutate(year = as.numeric(year))) 

write_sf(cyclingaccidents_l, "data/cyclingUK/uk_cyclingaccidents.gpkg")

#Yearly accident outcome summaries
uk_cyclingacc_outcomes = readxl::read_excel('data/cyclingUK/CyclingAccidentOutcomes_byOutcome.xlsx')
uk_cyclingacc_outcomes = uk_cyclingacc_outcomes %>% 
  pivot_longer(cols = starts_with('20'), names_to = 'year', values_to = 'num_accidents') %>% 
  mutate(year = as.numeric(year)) %>% 
  mutate(num_accidents = round(num_accidents))
openxlsx::write.xlsx(uk_cyclingacc_outcomes,
                     'data/cyclingUK/cycling_accident_outcome_summaries.xlsx')
