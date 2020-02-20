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

  # Output file for long-form HARI data
file_out_hari_long <- here::here("/data/hari_long.rds")

#===============================================================================

hari_long <-
  read_rds(file_hmda_ipums) %>%
  group_by(year, msa_code) %>%
  mutate(
    owners_prop = owners / sum(owners),
    renters_prop = renters / sum(renters),
    cum_prob = cumsum(owners_prop),
    rntr_afford = renters_prop * cum_prob,
    hari = cumsum(rntr_afford)
  ) %>%
  write_rds(file_out_hari_long)

