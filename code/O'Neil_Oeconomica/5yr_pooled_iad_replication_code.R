library(estimatr)
library(data.table)
library(tidyverse)
library(ggplot2)
library(testthat)
library(janitor)
library(rprojroot)

dat <- read.csv("/Users/aidanoneil/Documents/GitHub/dev_econ_cohort_2022/data/prelim/income_and_democracy/5yr.csv")

# Freedom house index

# add lagged variables
dat <- dat %>%
  dplyr::mutate(lagged_fhpolrigaug = lag(fhpolrigaug)) %>%
  as.data.table
dat <- dat %>%
  dplyr::mutate(lagged_lrgdpch = lag(lrgdpch)) %>%
  as.data.table

# run and save regression
col_1 <- lm(fhpolrigaug ~ lagged_fhpolrigaug + lagged_lrgdpch, data = dat[sample == 1])
summary(col_1)

# cluster standard errors
summary(col_1, vcov = vcovCL(model, cluster = dat$code))

# Polity index

dat <- dat %>%
  dplyr::mutate(lagged_polity4 = lag(polity4)) %>%
  as.data.table
dat <- dat %>%
  dplyr::mutate(lagged_lrgdpch = lag(lrgdpch)) %>%
  as.data.table

# run and save regression
col_1 <- lm(polity4 ~ lagged_polity4 + lagged_lrgdpch, data = dat[sample == 1])
summary(col_1)

# cluster standard errors
summary(col_1, vcov = vcovCL(model, cluster = dat$code))

