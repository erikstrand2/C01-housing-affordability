# Search path
VPATH = data data-raw eda reports scripts

# Processed data files
DATA = ipums.rds hmda.rds boundaries.shp msa.rds hmda_ipums.rds hari_long.rds hari.shp

# EDA studies
EDA = basic_map.md

# Reports
REPORTS =

# All targets
all : $(DATA) $(EDA) $(REPORTS)

# Data dependencies
hmda.rds : msa.rds
hmda_ipums.rds : ipums.rds hmda.rds
hari_long.rds : hmda_ipums.rds
hari.shp : hari_long.rds boundaries.shp

# EDA study and report dependencies
basic_map.md : hari.shp

# Pattern rules
%.shp : %.R
	Rscript $<
%.rds : %.R
	Rscript $<
%.md : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<", output_options = list(html_preview = FALSE))'
