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
require(lmtest)
require(sandwich)
require(dplyr)
require(survey)
require(stargazer)

# load directories
homedir <-
  find_root(criterion = has_file("dev_econ_cohort_2022.Rproj"))
codedir <- file.path(homedir, "code")
setwd(codedir)
source("paths.R")

###############################################################################
###############################################################################

setwd(file.path(prelimdir, "income_and_democracy"))
df1 <- fread("p5v2018.csv") %>% as.data.table

df2 <- df1 %>% select(-one_of('p5','cyear','ccode','flag','fragment','democ', 
                      'autoc', 'polity','durable', 'xrreg','xrcomp','xropen',
                      'xconst', 'parreg', 'exrec','exconst','polcomp','prior',
                      'emonth','parcomp','eday','eyear','eprec','interim',
                      'bmonth', 'bday','byear','bprec','post','change',
                      'd5', 'sf', 'regtrans')) #remove additional columns
                      
df3 <- df2[!(df2$year<=1850)] #remove years before 1850
df4 = na.omit(df3) #remove N/A data

##normalize -10 to 10 polity on a 0 to 1 scale => increments of 0.05

df4[df4 == -10] <- 0
df4[df4 == -9] <- 0.05
df4[df4 == -8] <- 0.1
df4[df4 == -7] <- 0.15
df4[df4 == -6] <- 0.2
df4[df4 == -5] <- 0.25
df4[df4 == -4] <- 0.3
df4[df4 == -3] <- 0.35
df4[df4 == -2] <- 0.4
df4[df4 == -1] <- 0.45
df4[df4 == 0] <- 0.5
df4[df4 == 1] <- 0.55
df4[df4 == 2] <- 0.6
df4[df4 == 3] <- 0.65
df4[df4 == 4] <- 0.7
df4[df4 == 5] <- 0.75
df4[df4 == 6] <- 0.8
df4[df4 == 7] <- 0.85
df4[df4 == 8] <- 0.9
df4[df4 == 9] <- 0.95
df4[df4 == 10] <- 1

polity_data = df4 #cleaned data
