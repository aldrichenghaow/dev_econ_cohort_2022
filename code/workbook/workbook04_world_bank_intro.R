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

require(here)

# create the import_data function
import_data <- function(file_path){
  # take in the .csv file
  data <- read_csv(here("data/prelim/data_world_bank", file_path), 
                   skip = 3) %>%
    select(-"Indicator Code") %>%
    pivot_longer(
      # tidy up the data and make indicator names on the first row
      cols = c(4:64),
      names_to = "year",
      values_to = "values"
    ) %>%
    pivot_wider(
      names_from = c("Indicator Name"),
      values_from = "values"
    ) %>%
    # convert variable into numeric type
    mutate(year = as.numeric(year))
  return(data)
}
# import data frames in the data_world_bank file and merge them into one
# list .csv data files
merged_data <- list.files(here("data/prelim/data_world_bank"), pattern = "*.csv")
paste("data_world_bank", merged_data, sep="/")
# set the right directory
setwd(homedir)
# merge data frames into one
all_data <- plyr:::ldply(merged_data, import_data)  
glimpse(all_data)

## Data analysis work
### Question 1: Explore the difference in the unemployment rate between females and males in the U.S.
# let's use the following filtered data frame for convenience, as you only need two variables for this
gender_united_states <- all_data %>%
  # use the filter function to obtain only the data in the US
  filter(`Country Name` == "United States") %>%
  # select useful variables for this part of data exploration
  select(`year`,
         `Unemployment, female (% of female labor force) (national estimate)`,
         `Unemployment, male (% of male labor force) (national estimate)`)

# let's then do some data visualization work....

### Question 2: Explore the relationship between advanced education and unemployment rate in the United States
# this is the filtered data frame
advanced_level_education_us <- all_data %>%
  # obtain the data of United States
  filter(`Country Name` == "United States") %>%
  # select only useful variables
  select(`Country Name`, 
         `year`, 
         `Unemployment, total (% of total labor force) (national estimate)`,
         `Unemployment with advanced education (% of total labor force with advanced education)`)

# code something here!
