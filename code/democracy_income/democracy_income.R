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
df <- fread("5yr.csv")

# create lagged variables and factor time
df[, `:=` (lagged_fhpolrigaug = shift(fhpolrigaug),
           lagged_lrgdpch = shift(lrgdpch)),
   by = c("country")]
df[, year := as.factor(year)]


# make_yr_dummy <- function (x) {
#   df[, as.character(x) := as.integer((year == x))]
# }
# lapply(df$year %>% unique(), make_yr_dummy)
# View(df)

# model1
require(sandwich)
require(lmtest)
require(multiwayvcov)
model1 <- lm(fhpolrigaug ~ lagged_fhpolrigaug + lagged_lrgdpch + year, data = df[sample == 1])
cluster_se <- sqrt(diag(cluster.vcov(model1, ~code, data = df)))
coeftest(model1, vcov = cluster.vcov(model, ~code, data = df))

coeftest(model1,
         vcov = sandwich,
         cluster = df$code)
