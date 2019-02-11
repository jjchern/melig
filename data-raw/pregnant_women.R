
# Medicaid and CHIP income cutoff for prenant women ------------------------

library(tidyverse)

read_csv("data-raw/pregnant_women.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff * 100)) %>%
  print() -> pregnant_women

usethis::use_data(pregnant_women, overwrite = TRUE)
