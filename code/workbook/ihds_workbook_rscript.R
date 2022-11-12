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

# (INSERT YOUR NAME)

# import data
file.path(prelimdir, "ihds1", "DS0002") %>% setwd()
ihds1_filename <- dir() %>% str_subset(".rda")
file.path(getwd(), ihds1_filename) %>% load(envir = globalenv())
tmpname <- ls() %>% str_subset("da2")
ihds1 <- tmpname %>% get()
rm(list = c(tmpname, "tmpname", ihds1_filename))

# plot data
plot(ihds1$HHED5ADULT, ihds1$INCOME, ylim = c(0,150000))

# plot data with ggplot
tmpdf <- ihds1 %>% select(HHED5ADULT, INCOME)
tmpdf %>% ggplot(aes(x = HHED5ADULT, y = INCOME)) +
  geom_boxplot() +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 4)) +
  scale_y_continuous(limits = c(0, 150000), expand = c(0,0)) +
  theme_bw()

# select variables and subset rows
littable <- ihds1 %>% 
  select(IDHH, STATEID, DISTID, HHED2) %>%
  filter(STATEID == "(01) Jammu & Kashmir")
