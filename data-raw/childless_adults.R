
# Medicaid income cutoff for childless adults, 2011-2015 ------------------------

library(dplyr)

ca1115 = readr::read_csv("data-raw/ca1115.csv", skip = 3)

ca1115 = ca1115 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(ca1115, overwrite = TRUE)
