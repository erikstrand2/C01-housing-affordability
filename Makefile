# Search path
VPATH = data data-raw eda reports scripts

# Processed data files
DATA = ipums.rds hmda.rds boundaries.shp

# EDA studies
EDA = 

# Reports
REPORTS =

# All targets
all : $(DATA) $(EDA) $(REPORTS)

# Data dependencies


# EDA study and report dependencies


# Pattern rules
%.shp : %.R
	Rscript $<
%.rds : %.R
	Rscript $<
%.md : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<", output_options = list(html_preview = FALSE))'
