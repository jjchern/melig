
# Medicaid and CHIP income cutoff for prenant women ------------------------

library(dplyr)

pregnant_women = readr::read_csv("data-raw/pregnant_women.csv", skip = 3)

pregnant_women = pregnant_women %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(pregnant_women, overwrite = TRUE)
