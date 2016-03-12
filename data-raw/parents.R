
# Medicaid income cutoff for parents ---------------------------

library(dplyr)

parents = readr::read_csv("data-raw/parents.csv", skip = 3)

parents = parents %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(parents, overwrite = TRUE)
