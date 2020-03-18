# This file converts longform HARI data into an abbreviated tibble.

# Author: Erik Strand
# Version: 2020-02-19

# Libraries
library(tidyverse)
library(sf)

# Parameters

  # Longform HARI data file
file_hari_long <- here::here("/data/hari_long.rds")

  # Boundaries shapefile
file_boundaries <- here::here("/data/boundaries.shp")

  # Output file for abbreviated HARI data
file_out_hari <- here::here("/data/hari.shp")

  # proj4 string for hari CRS
hari_albers <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
#===============================================================================

read_rds(file_hari_long) %>%
  select(year, msa_code, hari, hari_ntl) %>%
  group_by(year, msa_code) %>%
  slice(n()) %>%
  mutate_all(~ if_else(is.nan(.), NA_real_, .)) %>%
  left_join(read_sf(file_boundaries), by = "msa_code") %>%
  st_as_sf() %>%
  st_transform(st_crs(hari_albers)) %>%
  write_sf(file_out_hari)
