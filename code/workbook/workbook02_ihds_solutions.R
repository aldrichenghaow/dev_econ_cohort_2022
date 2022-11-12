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
file.path(prelimdir, "ihds1", "DS0002") %>% setwd()
ihds1_filename <- dir() %>% str_subset(".rda")
file.path(getwd(), ihds1_filename) %>% load(envir = globalenv())
tmpname <- ls() %>% str_subset("da2")
ihds1 <- tmpname %>% get()
rm(list = c(tmpname, "tmpname", "ihds1_filename"))

### TASK 1 SOLUTION
file.path(prelimdir, "ihds2", "DS0002") %>% setwd()
ihds2_filename <- dir() %>% str_subset(".rda")
file.path(getwd(), ihds2_filename) %>% load(envir = globalenv())
tmpname <- ls() %>% str_subset("da3")
ihds2 <- tmpname %>% get()
rm(list = c(tmpname, "tmpname", "ihds2_filename"))

# plot data
plot(ihds1$HHED5ADULT, ihds1$INCOME)
plot(ihds1$HHED5ADULT, ihds1$INCOME, ylim = c(0,150000))
tmpdf <- ihds1 %>% select(HHED5ADULT, INCOME)
tmpdf %>% ggplot(aes(x = HHED5ADULT, y = INCOME)) +
  geom_boxplot() +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 4)) +
  scale_y_continuous(limits = c(0, 150000), expand = c(0,0)) +
  theme_bw()

### TASK 2 SOLUTION
plot(ihds2$COTOTAL, ihds2$CO35, xlim = c(0, 250000), ylim = c(0, 15000))

# select variables and subset rows
littable <- ihds1 %>% 
  select(IDHH, STATEID, DISTID, HHED2) %>%
  filter(STATEID == "(01) Jammu & Kashmir")
