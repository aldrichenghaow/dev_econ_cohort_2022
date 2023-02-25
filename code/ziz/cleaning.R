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
  rawdfs[[i]] <- fread(file = rawdfs_list[i], skip = 4, header = TRUE) %>%
    as.data.table()
  rawdfs[[i]] %>% setnames(
    c("Country Name", "Country Code", "Indicator Name", "Indicator Code"),
    c("countryname", "countrycode", "indicator", "indicatorcode")
  )
  rawdfs[[i]][, c("countrycode", "indicatorcode") := NULL]
  rawdfs[[i]] <-
    rawdfs[[i]] %>% melt(
      c("countryname", "indicator"),
      rawdfs[[i]] %>%
        colnames() %>%
        str_subset(pattern = "[0-9]{4}"),
      "year",
      "values"
    )
  rawdfs[[i]] <-
    rawdfs[[i]] %>% dcast(countryname + year ~ indicator,
                          value.var = "values")
}
rm(i)

# combine data frames
alldf <- rbindlist(rawdfs)

# variables names
idvars <- colnames(alldf)[1:3]
statvars <- colnames(alldf)[4:ncol(alldf)] %>%
  as.data.table() %>%
  setnames(".", "statistic")

# country names
knames <- unique(alldf$countryname) %>%
  as.data.table() %>%
  setnames(".", "kname")

# # output country-specific tables
# setwd(file.path(datadir, "world_bank_cleaned"))
# saveme <- function (df) {
#   kname = unique(df[, countryname])
#   fwrite(df, paste0(kname, ".csv"))
# }
# lapply(rawdfs, saveme)

# output combined table
fwrite(alldf, file = "All_Countries.csv")
