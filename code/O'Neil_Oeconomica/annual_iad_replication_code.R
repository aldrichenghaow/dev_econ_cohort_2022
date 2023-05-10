library(estimatr)
library(data.table)
library(tidyverse)
library(ggplot2)
library(testthat)
library(janitor)
library(rprojroot)

dat <- read.csv("/Users/aidanoneil/Documents/GitHub/dev_econ_cohort_2022/data/prelim/income_and_democracy/annual.csv")

# Freedom house index

dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_polity4 = lag(polity4)) %>%
  as.data.table
dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_lrgdpch = lag(lrgdpch)) %>%
  as.data.table

# make year a factor
dat[, year := as.factor(year)]
dat[, country := as.factor(country)]

# run and save regression
col_1 <- lm(polity4 ~ lagged_polity4 + lagged_lrgdpch + year + country, data = dat[sample == 1])
summary(col_1)

# cluster standard errors
summary(col_1, vcov = vcovCL(model, cluster = dat$code))

# Polity index

# add lagged variables
dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_fhpolrigaug = lag(fhpolrigaug)) %>%
  as.data.table
dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_lrgdpch = lag(lrgdpch)) %>%
  as.data.table

# make year a factor
dat[, year := as.factor(year)]
dat[, country := as.factor(country)]

# run and save regression
col_1 <- lm(fhpolrigaug ~ lagged_fhpolrigaug + lagged_lrgdpch + year + country, data = dat[sample == 1])
summary(col_1)

# cluster standard errors
summary(col_1, vcov = vcovCL(model, cluster = dat$code))

# Polity index - annual

dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_polity4 = lag(polity4)) %>%
  as.data.table
dat <- dat %>%
  group_by(country) %>%
  dplyr::mutate(lagged_lrgdpch = lag(lrgdpch)) %>%
  as.data.table

# make year a factor
dat[, year := as.factor(year)]
dat[, country := as.factor(country)]

# run and save regression
col_1 <- lm(polity4 ~ lagged_polity4 + lagged_lrgdpch + year + country, data = dat[sample == 1])
summary(col_1)

# cluster standard errors
summary(col_1, vcov = vcovCL(model, cluster = dat$code))

