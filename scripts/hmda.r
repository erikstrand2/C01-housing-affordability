# This file processes all HMDA data from 2007-2017 and
# cleans it into one file. Run on RICE.

# Author: Erik Strand
# Version: 2020-03-12

# Libraries
library(tidyverse)

# Parameters

  # MSA lookup table file location
file_msa <- here::here("msa.rds")

  # Files for HMDA data from years 2007-2017
files_hmda <- here::here(str_glue("hmda_{2007:2017}.zip"))

  # Output file for processed data
file_out_all <- here::here("hmda.rds")

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

read_hmda <- function(file_raw) {
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
    summarize(owners = n())
}

map(files_hmda, read_hmda) %>%
  write_rds(file_out_all, compress = "gz")
