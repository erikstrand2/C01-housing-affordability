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
surveys <-
  c(
    200701,
    200801,
    200901,
    201001,
    201101,
    201201,
    201301,
    201401,
    201501,
    201601,
    201701
  )

#===============================================================================

ipums <- read_ipums_micro(
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
  group_by(year, msa_code, hh_income) %>%
  summarize(renters = sum(hh_weight)) %>%
  ungroup() %>%
  write_csv(path = file_out_csv)

read_csv(file_out_csv) %>%
  write_rds(file_out, compress = "gz")
