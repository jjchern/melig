
# Medicaid income cutoff for parents ---------------------------

library(tidyverse)

read_csv("data-raw/parents.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>%
  # WA 2002: Data not reported.
  # filter(is.na(cutoff))
  print() -> parents

usethis::use_data(parents, overwrite = TRUE)
