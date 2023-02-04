# This R script file contains solutions to exercises in our second workbook.

# Exercise 1
adelie_penguins <- filter(.data = penguins, species == "Adelie")
summarize(.data = adelie_penguins, avg_mass = mean(body_mass_g, na.rm = TRUE))
adelie_penguins

# Exercise 2
#---without piping---#
gentoo_penguins <- filter(.data = penguins, species == "Gentoo")
gentoo_penguins_sex <- group_by(.data = gentoo_penguins, sex)
summarize(
  .data = gentoo_penguins_sex,
  bill_length = mean(bill_length_mm, na.rm = TRUE)
)

#---with piping---#
gentoo_bill_leng_by_sex <- penguins %>%
  filter(species == "Gentoo") %>%
  group_by(sex) %>%
  summarize(
    bill_length = mean(bill_length_mm, na.rm = TRUE)
  )
gentoo_bill_leng_by_sex

# Exercise 3
#---without piping---#
chinstrap_penguins <- filter(.data = penguins, species == "Chinstrap")
chinstrap_penguins_sex <- group_by(.data = chinstrap_penguins, sex)
summarize(
  .data = chinstrap_penguins_sex,
  bill_length = mean(bill_length_mm, na.rm = TRUE),
  bill_depth = mean(bill_depth_mm, na.rm = TRUE)
)

#---with piping---#
chinstrap_penguins_bill <- penguins %>%
  filter(species == "Chinstrap") %>%
  group_by(sex) %>%
  summarize(
    bill_length = mean(bill_length_mm, na.rm = TRUE),
    bill_depth = mean(bill_depth_mm, na.rm = TRUE)
  )
chinstrap_penguins_bill