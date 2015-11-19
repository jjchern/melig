
# Medicaid income cutoff for parents, 2002-2015 ---------------------------

library(dplyr)

pa0215 = readr::read_csv("data-raw/pa0215.csv", skip = 3)

pa0215 = pa0215 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(pa0215, overwrite = TRUE)
