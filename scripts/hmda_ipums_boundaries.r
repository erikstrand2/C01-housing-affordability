# This script reads in HMDA, IPUMS, and MSA boundary data and joins the,

# Author: Erik Strand
# Version: 2020-02-03

# Libraries
library(tidyverse)
library(sf)

# Parameters

  # HMDA data source
file_hmda <- here::here("/data/hmda.rds")

  # IPUMS data source
file_ipums <- here::here("/data/ipums.rds")

  # MSA boundary shapefile data source
file_msa_sf <- here::here("/data/boundaries.shp")

#===============================================================================

hmda <- read_rds(file_hmda)
ipums <- read_rds(file_ipums)
boundaries <- st_read(file_msa_sf)

# IN PROGRESS
# hmda_ipums_boundaries <-
#   hmda %>%
#   left_join(
#     ipums %>%
#       left_join(boundaries, by = "msa_code"),
#     by = "msa_code"
#   )





