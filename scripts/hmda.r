# This script reads in Home Mortgage Disclosure Act data downloaded from
# the Consumer Financial Protection Bureau website, tidies it, and cleans it to
# use in my C01 challenge.

# Author: Erik Strand
# Version: 2020-02-02

# Libraries
library(tidyverse)

# Parameters

  # HMDA data file location
file_raw <- here::here("/data-raw/hmda.zip")

  # Cleaned & tidied data location
file_out <- here::here("/data/hmda.rds")

#===============================================================================

read_csv(file = file_raw) %>%
  filter(
    loan_purpose == 1,
    !is.na(msamd)
  ) %>%
  drop_na(census_tract_number, applicant_income_000s) %>%
  mutate(
    loan_amount = loan_amount_000s * 1000,
    census_tract_number = as.integer(census_tract_number) * 100,
    applicant_income = applicant_income_000s * 1000
  ) %>%
  select(
    as_of_year,
    applicant_income,
    loan_amount,
    msamd_name,
    msa_code = msamd,
    state_name,
    state_code,
    county_name,
    county_code,
    census_tract_number
  ) %>%
  write_rds(path = file_out, compress = "gz")
