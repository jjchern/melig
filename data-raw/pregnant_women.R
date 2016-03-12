
# Medicaid and CHIP income cutoff for prenant women, 2003-2015 ------------------------

library(dplyr)

pw0315 = readr::read_csv("data-raw/pw0315.csv", skip = 3)

pw0315 = pw0315 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff))

devtools::use_data(pw0315, overwrite = TRUE)
