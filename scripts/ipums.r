# This script reads in data from my IPUMS extract and cleans and tidies it.

# Author: Erik Strand
# Version: 2020-02-02

# Libraries
library(tidyverse)
library(ipumsr)

# Parameters

  # IPUMS ddi file path
ddi_file <- here::here("/data-raw/ipums.xml")

  # IPUMS .dat file path
dat_file <- here::here("/data-raw/ipums.dat.gz")

  # Cleaned data output file in CSV form to remove var. labels
file_out_csv <- here::here("/data/ipums.csv")

  # Final cleaned data output file
file_out <- here::here("/data/ipums.rds")

  # Surveys to include
surveys <- 201701

#===============================================================================

read_ipums_micro(
  ddi = read_ipums_ddi(ddi_file = ddi_file),
  data_file = dat_file
) %>%
  filter(PERNUM == 1) %>%
  select(
    year = YEAR,
    survey = SAMPLE,
    hh_weight = HHWT,
    state_fips = STATEFIP,
    msa_code = MET2013,
    tenure = OWNERSHP,
    hh_income = HHINCOME
  ) %>%
  filter(
    tenure == 2,
    hh_income >= 0,
    survey %in% surveys,
    msa_code > 0
  ) %>%
  mutate(
    msa_code = as.integer(msa_code)
  ) %>%
  write_csv(path = file_out_csv)

read_csv(file_out_csv) %>%
  write_rds(file_out, compress = "gz")

# Currently not working
# if (exists(file_out_csv)) file.remove(file_out_csv)
