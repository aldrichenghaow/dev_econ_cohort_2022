###############################################################################
###############################################################################

# COPY AND PASTE EVERYTHING HERE TO EACH CODE FOR CONSISTENCY
# DO NOT EXCEED WIDTH OF HASHTAGS (80 CHARACTERS)

# clear global environment
rm(list = ls(), envir = globalenv())

# clear memory
gc()

# load required libraries
require(tidyverse)
require(data.table)
require(ggplot2)
require(testthat)
require(janitor)
require(rprojroot)

# load directories
homedir <-
  find_root(criterion = has_file("dev_econ_cohort_2022.Rproj"))
codedir <- file.path(homedir, "code")
setwd(codedir)
source("paths.R")

###############################################################################
###############################################################################

# import data
setwd(file.path(prelimdir, "data_world_bank"))
rawdfs_list <- dir() %>% str_subset(".csv")
rawdfs <- list()

# function to read in individual data frames
for (i in seq_along(rawdfs_list)) {
  rawdfs[[i]] <- fread(file = rawdfs_list[i], skip = 4) %>%
    as.data.table()
}
rm(i)

# combine data frames
fulldf <- rawdfs %>%
  bind_rows() %>%
  row_to_names(row_number = 1) %>%
  unique() %>% as.data.table()

# manage memory
rm(rawdfs)
gc()

# rename columns
fulldf %>% setnames(
  c("Country Name", "Country Code", "Indicator Name"),
  c("countryname", "countrycode", "indicator")
)

# reshape year and indicator from long to wide/wide to long
fulldf <- fulldf[, `Indicator Code` := NULL]
fulldf <-
  fulldf %>% melt(
    c("countryname", "countrycode", "indicator"),
    fulldf %>%
      colnames() %>%
      str_subset(pattern = "[0-9]{4}"),
    "year",
    "values"
  )
fulldf <- fulldf[!is.na(values)]
fulldf <-
  fulldf %>% dcast(countryname + countrycode + year ~ indicator,
                   value.var = "values")

# change column types
fulldf[, year := as.numeric(year)]

# select variables
idvars <- colnames(fulldf)[1:3]
statvars <- colnames(fulldf)[4:ncol(fulldf)] %>%
  as.data.table() %>%
  setnames(".", "statistic")
knames <- unique(fulldf$countryname) %>%
  as.data.table() %>%
  setnames(".", "kname")

# clear memory
gc()
