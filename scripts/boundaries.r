# This script reads in Metropolitan Statistical Area (MSA) boundary
# shapefiles from the U.S. Census Bureau and cleans the data.

# Source:
# https://catalog.data.gov/dataset/tiger-line-shapefile-2017-nation-u-s-current-metropolitan-statistical-area-micropolitan-statist

# Author: Erik Strand
# Version: 2020-02-03

# Libraries
library(tidyverse)
library(sf)

# Parameters

  # Location of raw shapefile
sf_raw <- here::here("/data-raw/boundaries")

  # Output file
file_out <- here::here("/data/boundaries.shp")

#===============================================================================

read_sf(sf_raw) %>%
  select(
    msa_code = CBSAFP,
    msa_name = NAME,
    geometry
  ) %>%
  mutate(msa_code = as.integer(msa_code)) %>%
  write_sf(file_out)
