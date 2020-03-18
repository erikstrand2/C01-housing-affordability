# This script uses HMDA and IPUMS data to calculate the HARI for metropolitan
# statistical areas (MSAs) in the U.S. Methodology is from Goodman, Li, and
# Zhu's 2018 report.

# Source: https://www.urban.org/sites/default/files/publication/97496/housing_affordability_local_and_national_perspectives_1.pdf

# Author: Erik Strand
# Version: 2020-02-16

# Libraries
library(tidyverse)

# Parameters

  # Joined HMDA-IPUMS dataset file
file_hmda_ipums <- here::here("/data/hmda_ipums.rds")

  # File with national indexes
file_national_index <- here::here("/data/national_index.rds")

  # Output file for long-form HARI data
file_out_hari_long <- here::here("/data/hari_long.rds")

#===============================================================================

national_index <- read_rds(file_national_index)

view(read_rds(file_hmda_ipums) %>%
  group_by(year, msa_code) %>%
  mutate(
    owners_prop = owners / sum(owners),
    renters_prop = renters / sum(renters),
    cum_prob = cumsum(owners_prop),
    rntr_afford = renters_prop * cum_prob,
    hari = if_else(renters == 0, NA_real_, cumsum(rntr_afford))
  )) %>%
  left_join(
    national_index %>% select(year, hh_inc_bracket, renters_prop),
    by = c("year", "hh_inc_bracket"),
    suffix = c("", "_ntl")
  ) %>%
  mutate(
    rntr_afford_ntl = renters_prop_ntl * cum_prob,
    hari_ntl = cumsum(rntr_afford_ntl)
  ) %>%
  ungroup() %>%
  write_rds(file_out_hari_long)

