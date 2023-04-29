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

# load data
setwd(file.path(prelimdir, "income_and_democracy"))
df <- fread("10yr.csv")

# create lagged variables and factor time
df[, `:=` (lagged_polity4 = shift(polity4),
           lagged_lrgdpch = shift(lrgdpch)),
   by = c("country")]
df[, year := as.factor(year)]
df[, code := as.factor(code)]

# make_yr_dummy <- function (x) {
#   df[, as.character(x) := as.integer((year == x))]
# }
# lapply(df$year %>% unique(), make_yr_dummy)
# View(df)

# clustered model
require(survey)
clusters <- svydesign(ids = ~code, data = df[sample == 1])
model2 <- svyglm(polity4 ~ lagged_polity4 + lagged_lrgdpch + year + code, design = clusters)
summary(model2)