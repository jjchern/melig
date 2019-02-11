
# Medicaid income cutoff for childless adults ------------------------

library(tidyverse)

read_csv("data-raw/childless_adults.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(cutoff = as.numeric(cutoff * 100)) %>%
  print() -> childless_adults

usethis::use_data(childless_adults, overwrite = TRUE)
