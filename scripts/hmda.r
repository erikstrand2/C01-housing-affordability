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

  # HMDA URL file
file_url <- "https://files.consumerfinance.gov/hmda-historic-loan-data/hmda_2017_nationwide_first-lien-owner-occupied-1-4-family-records_labels.zip"

  # MSA lookup table file location
file_msa <- here::here("/data/msa.rds")

  # Cleaned & tidied data location
file_out <- here::here("/data/hmda.rds")

  # Columns to read in
var_cols <-
  cols_only(
    as_of_year = col_double(),
    loan_purpose = col_double(),
    loan_amount_000s = col_double(),
    msamd_name = col_character(),
    msamd = col_integer(),
    state_name = col_character(),
    state_code = col_double(),
    county_name = col_character(),
    county_code = col_double(),
    census_tract_number = col_character(),
    applicant_income_000s = col_double()
  )

#===============================================================================

read_csv(file = file_raw, col_types = var_cols) %>%
  filter(
    loan_purpose == 1,
    !is.na(msamd)
  ) %>%
  drop_na(census_tract_number, applicant_income_000s) %>%
  mutate(
    year = as_of_year,
    loan_amount = loan_amount_000s * 1000,
    census_tract_number = as.double(census_tract_number) * 100,
    applicant_income = applicant_income_000s * 1000,
    msa_code = msamd
  ) %>%
  left_join(read_rds(file_msa), by = c("msa_code" = "div_code")) %>%
  mutate(msa_code = if_else(is.na(msa_code.y), msa_code, msa_code.y)) %>%
  select(
    -c(
      loan_purpose,
      loan_amount_000s,
      applicant_income_000s,
      msa_code.y,
      msamd,
      loan_amount
    )
  ) %>%
  group_by(
    year,
    msamd_name,
    state_name,
    state_code,
    county_name,
    county_code,
    msa_code,
    applicant_income
  ) %>%
  summarize(owners = n()) %>%
  write_rds(path = file_out, compress = "gz")

test <- read_csv(file_url)

