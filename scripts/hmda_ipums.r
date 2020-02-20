# This script reads in HMDA, IPUMS, and MSA boundary data and joins them.

# Author: Erik Strand
# Version: 2020-02-03

# Libraries
library(tidyverse)

# Parameters

  # HMDA data source
file_hmda <- here::here("/data/hmda.rds")

  # IPUMS data source
file_ipums <- here::here("/data/ipums.rds")

  # Output shapefile, currently RDS as shp is too large
file_out <- here::here("/data/hmda_ipums.rds")

  # Create income brackets
brackets <- tibble(bracket = seq(0, 250000, 10000))

  # Function to normalize income brackets for HMDA and IPUMS data
find_bracket <- function(x) {
  brackets %>%
    filter(bracket <= x) %>%
    max(.$bracket)
}

#===============================================================================

hmda <- read_rds(file_hmda)
ipums <- read_rds(file_ipums)

hmda <-
  hmda %>%
  filter(
    msa_code %in% ipums$msa_code,
    !(state_code %in% c(2, 15))
  ) %>%
  mutate(
    hh_inc_bracket = map_dbl(applicant_income, find_bracket)
  ) %>%
  group_by(
    year,
    msa_code,
    hh_inc_bracket
  ) %>%
  summarize(owners = sum(owners))

ipums <-
  ipums %>%
  mutate(
    hh_inc_bracket = map_dbl(hh_income, find_bracket)
  ) %>%
  group_by(year, msa_code, hh_inc_bracket) %>%
  summarize(renters = sum(renters))


hmda %>%
  full_join(ipums, by = c("year", "msa_code", "hh_inc_bracket")) %>%
  mutate(
    owners = replace_na(owners, 0),
    renters = replace_na(renters, 0)
  ) %>%
  write_rds(file_out, compress = "gz")

