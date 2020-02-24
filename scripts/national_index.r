# This file calculates national renter and owner probabilities, for later use
# calculating MSA national index HARI figures.

# Author: Erik Strand
# Version: 2020-02-23

# Libraries
library(tidyverse)

# Parameters

  # Input file from HMDA & IPUMS joined data
file_hmda_ipums <- here::here("/data/hmda_ipums.rds")

  # Output file
file_out <- here::here("/data/national_index.rds")

#===============================================================================

read_rds(file_hmda_ipums) %>%
  group_by(year, hh_income = hh_inc_bracket) %>%
  summarize(
    owners = sum(owners),
    renters = sum(renters)
  ) %>%
  mutate(
    owners_prop = owners / sum(owners),
    renters_prop = renters / sum(renters),
    cum_prob = cumsum(owners_prop),
    rntr_afford = renters_prop * cum_prob,
    hari = cumsum(rntr_afford)
  ) %>%
  ungroup() %>%
  write_rds(file_out)
