
# Medicaid income cutoff for childless adults ------------------------

library(dplyr)

childless_adults = readr::read_csv("data-raw/childless_adults.csv", skip = 3)

childless_adults = childless_adults %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(childless_adults, overwrite = TRUE)
