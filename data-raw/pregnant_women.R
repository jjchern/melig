
# Medicaid and CHIP income cutoff for pregnant women ------------------------

library(tidyverse)

read_csv("data-raw/pregnant_women.csv", skip = 2, n_max = 52) |>
  select(-Footnotes) |>
  rename(state = Location) |>
  left_join(fips::fips, by = "state") |>
  select(state, fips, usps, everything()) |>
  gather(year, cutoff, -state:-usps) |>
  separate(year, c("month", "year")) |>
  mutate(year = as.integer(year)) |>
  mutate(cutoff = as.numeric(cutoff * 100)) |>
  print() -> pregnant_women

usethis::use_data(pregnant_women, overwrite = TRUE)
