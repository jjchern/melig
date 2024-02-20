
# Medicaid income cutoff for childless adults ------------------------

library(tidyverse)

read_csv("data-raw/childless_adults.csv", skip = 2, n_max = 52) |>
  select(-Footnotes) |>
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") |>
  select(state, fips, usps, everything()) |>
  gather(year, cutoff, -state:-usps) |>
  separate(year, c("month", "year")) |>
  mutate(year = as.integer(year)) |>
  mutate(cutoff = as.numeric(cutoff * 100)) |>
  print() -> childless_adults

usethis::use_data(childless_adults, overwrite = TRUE)
