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
setwd(file.path(prelimdir, "data_world_bank"))
df <- fread("API_AFG_DS2_en_csv_v2_1223036.csv") %>% as.data.table

# clean data
colnames(df) <- df %>% 
  slice(1) %>% 
  as.character()
df <- df %>% slice(2:nrow(df))

# colnames(df) <- df[1] %>% as.character()
# df <- df[-1]

# pivot to longer
longdf <- df %>% pivot_longer(cols = 5:ncol(df), names_to = "year")
longdf <- longdf %>% filter(!is.na(value))
colnames(longdf) <- colnames(longdf) %>% str_to_lower()
temp <- longdf %>% filter(`indicator name` == "Gross domestic savings (current US$)")
temp %>% ggplot(aes(x = year, y = value)) +
  geom_point()
