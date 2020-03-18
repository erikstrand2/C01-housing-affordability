#

# Author: Name
# Version: 2020-03-16

# Libraries
library(tidyverse)

# Parameters

files_hmda <- here::here(str_glue("/hmda/hmda_{2007:2017}.rds"))

file_out <- here::here("/data/hmda_all.rds")

#===============================================================================

test <- map_dfr(files_hmda, read_rds)


write_rds(test, file_out, compress = "gz")
