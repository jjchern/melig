
# Medicaid and CHIP income cutoff for children --------------------------------

library(tidyverse)

read_csv("data-raw/infants_age_0_1_medicaid.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(type = "Medicaid", agegrp = "0-1") %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>% # filter(is.na(cutoff))
  # TN 2000 and 2002 have not upper limits
  mutate(cutoff = if_else(usps == "TN" & year %in% c(2000, 2002), 9999, cutoff)) %>%
  select(state, fips, usps, type, agegrp, everything()) %>%
  print() -> infant0_1

read_csv("data-raw/children_age_1_5_medicaid.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(type = "Medicaid", agegrp = "1-5") %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>% # filter(is.na(cutoff))
  # TN 2000 and 2002 have not upper limits
  mutate(cutoff = if_else(usps == "TN" & year %in% c(2000, 2002), 9999, cutoff)) %>%
  select(state, fips, usps, type, agegrp, everything()) %>%
  print() -> children1_5

read_csv("data-raw/children_age_6_18_medicaid.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  tidyr::gather(year, cutoff, -state:-usps) %>%
  tidyr::separate(year, c("month", "year")) %>%
  mutate(type = "Medicaid", agegrp = "6-18") %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>% # filter(is.na(cutoff))
  # TN 2000 and 2002 have not upper limits
  mutate(cutoff = if_else(usps == "TN" & year %in% c(2000, 2002), 9999, cutoff)) %>%
  select(state, fips, usps, type, agegrp, everything()) %>%
  print() -> children6_18

read_csv("data-raw/children_age_0_18_chip.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(type = "CHIP", agegrp = "0-18") %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>% # filter(is.na(cutoff)), No CHIP program
  select(state, fips, usps, type, agegrp, everything()) %>%
  print() -> chip0_18

read_csv("data-raw/children_chip_mcaid.csv", skip = 2) %>%
  select(-Footnotes) %>%
  filter(Location != "United States") %>%
  rename(state = Location) %>%
  inner_join(fips::fips, by = "state") %>%
  select(state, fips, usps, everything()) %>%
  gather(year, cutoff, -state:-usps) %>%
  separate(year, c("month", "year")) %>%
  mutate(type = "CHIP/Mcaid Upper", agegrp = "0-18") %>%
  mutate(cutoff = as.integer(cutoff) * 100) %>% # filter(is.na(cutoff))
  # TN 2000 and 2002 have not upper limits
  mutate(cutoff = if_else(usps == "TN" & year %in% c(2000, 2002), 9999, cutoff)) %>%
  select(state, fips, usps, type, agegrp, everything()) %>%
  print() -> chip_mcaid_upper

infant0_1 %>%
  bind_rows(children1_5) %>%
  bind_rows(children6_18) %>%
  bind_rows(chip0_18) %>%
  bind_rows(chip_mcaid_upper) %>%
  arrange(fips, year) %>%
  print() -> children

usethis::use_data(children, overwrite = TRUE)
