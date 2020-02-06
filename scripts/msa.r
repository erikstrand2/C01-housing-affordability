# This script creates a lookup table between MSA codes and division codes, which
# exist for the largest MSAs. This lookup table is later used to clean HMDA data.

# Source: CSV copied from Bureau of Labor Statistics website:
# https://www.bls.gov/sae/additional-resources/metropolitan-and-necta-divisions-published-by-ces.htm

# Author: Erik Strand
# Version: 2020-02-05

# Libraries
library(tidyverse)

# Parameters

  # Read in messy data
file_msa <- here::here("/data-raw/msa.csv")

  # Output file
file_out <- here::here("/data/msa.rds")
#===============================================================================

msa <-
  read_csv(file_msa) %>%
  rename(msa_code = Code, msa_name = `Metropolitan Statistical Area`) %>%
  drop_na() %>%
  mutate(
    msa_code = str_trim(msa_code),
    division = str_detect(msa_name, "Division")
  ) %>%
  pivot_wider(names_from = division, values_from = msa_code) %>%
  mutate(
    msa_code = as.integer(`FALSE`),
    div_code = as.integer(`TRUE`)
  ) %>%
  select(-c(msa_name, `FALSE`, `TRUE`)) %>%
  fill(msa_code, .direction = "down") %>%
  filter(!is.na(div_code)) %>%
  write_rds(file_out)


