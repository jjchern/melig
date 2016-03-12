
# Medicaid and CHIP income cutoff for children, 2000-2015 ------------------------

library(dplyr)

infant0_1 = readr::read_csv("data-raw/infants_age_0_1_medicaid.csv", skip = 3)
infant0_1 = infant0_1 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff),
         type = "Medicaid",
         agegrp = "0-1") %>%
  select(state, fips, usps, type, agegrp, everything())
infant0_1

children1_5 = readr::read_csv("data-raw/children_age_1_5_medicaid.csv", skip = 3)
children1_5 = children1_5 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff),
         type = "Medicaid",
         agegrp = "1-5") %>%
  select(state, fips, usps, type, agegrp, everything())
children1_5

children6_18 = readr::read_csv("data-raw/children_age_6_18_medicaid.csv", skip = 3)
children6_18 = children6_18 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff),
         type = "Medicaid",
         agegrp = "6-18") %>%
  select(state, fips, usps, type, agegrp, everything())
children6_18

chip0_18 = readr::read_csv("data-raw/children_age_0_18_chip.csv", skip = 3)
chip0_18 = chip0_18 %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  left_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(cutoff = as.integer(cutoff),
         type = "CHIP",
         agegrp = "0-18") %>%
  select(state, fips, usps, type, agegrp, everything())
chip0_18

children = infant0_1 %>%
  bind_rows(children1_5) %>%
  bind_rows(children6_18) %>%
  bind_rows(chip0_18) %>%
  arrange(fips, year)
children

devtools::use_data(children, overwrite = TRUE)
