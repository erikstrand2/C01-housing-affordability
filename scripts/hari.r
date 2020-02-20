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
#===============================================================================

hari <-
  read_rds(file_hari_long) %>%
  group_by(msa_code) %>%
  select(msa_code, hari) %>%
  top_n(hari, n = 1) %>%
  left_join(read_sf(file_boundaries), by = "msa_code") %>%
  write_sf(file_out_hari)
