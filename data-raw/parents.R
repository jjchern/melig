
# Medicaid income cutoff for parents ---------------------------

library(tidyverse)

read_csv("data-raw/parents.csv", skip = 2, n_max = 52) %>%
  select(-Footnotes) %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(cutoff = as.numeric(cutoff) * 100) %>%
  # WA 2002: Data not reported.
  # filter(is.na(cutoff))
  print() -> parents

usethis::use_data(parents, overwrite = TRUE)
