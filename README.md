
<!-- README.md is generated from README.Rmd. Please edit that file -->

# About `melig`

The R package `melig` contains information on **M**edicaid income
**elig**ibility limits, collected by [the Kaiser Family
Foundation](http://kff.org/data-collection/trends-in-medicaid-income-eligibility-limits/).
It includes the following datasets:

- `children.rda`:
  - [Medicaid Income Eligibility Limits for Infants Ages 0–1,
    2000–2023](https://www.kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-infants-ages-0-1/)
  - [Medicaid Income Eligibility Limits for Children Ages 1–5,
    2000–2023](https://www.kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-1-5/)
  - [Medicaid Income Eligibility Limits for Children Ages 6–18,
    2000–2023](https://www.kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-6-18/)
  - [Separate Children’s Health Insurance Program (CHIP) Income
    Eligibility Limits for Children,
    2000–2023](https://www.kff.org/medicaid/state-indicator/separate-childrens-health-insurance-program-chip-income-eligibility-limits-for-children/)
  - [Medicaid/CHIP Upper Income Eligibility Limits for Children,
    2000–2023](https://www.kff.org/medicaid/state-indicator/medicaidchip-upper-income-eligibility-limits-for-children/)
- `prenant_wom.rda`: [Medicaid and CHIP Income Eligibility Limits for
  Pregnant Women,
  2003–2023](https://www.kff.org/medicaid/state-indicator/medicaid-and-chip-income-eligibility-limits-for-pregnant-women/)
- `parents.rda`: [Medicaid Income Eligibility Limits for Parents,
  2002–2023](https://www.kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-parents/)
- `childless_adults.rda`: [Medicaid Income Eligibility Limits for Other
  Non-Disabled Adults,
  2011–2023](https://www.kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-other-non-disabled-adults/)

The datasets are stored in long format.

The
[`/data-raw/`](https://github.com/jjchern/melig/tree/master/data-raw)
folder contains raw data and R scripts.

# Installing the Package

You can install `melig` from Github with:

``` r
# install.packages("remotes")

# Install the development version
remotes::install_github("jjchern/melig")

# Install the released version
remotes::install_github("jjchern/melig@v0.1.0")

# To uninstall the package, use:
# remove.packages("melig")
```

# Useful Links

- [Medicaid Income Eligibility Limits (Most Recent
  Data)](http://kff.org/state-category/medicaid-chip/medicaidchip-eligibility-limits/)
- [Annual Updates on Eligibility Rules, Enrollment and Renewal
  Procedures, and Cost-Sharing Practices in Medicaid and
  CHIP](http://kff.org/medicaid/report/annual-updates-on-eligibility-rules-enrollment-and/)

# Usage

## Long and Wide Formats

``` r
library(tidyverse)
library(formattable)

# List all available datasets
data(package = "melig") %>% 
    pluck("results") %>% 
    as_tibble() %>% 
    select(Package, Item)
#> # A tibble: 4 × 2
#>   Package Item            
#>   <chr>   <chr>           
#> 1 melig   childless_adults
#> 2 melig   children        
#> 3 melig   parents         
#> 4 melig   pregnant_women

# The datasets are in long format
melig::parents
#> # A tibble: 1,092 × 6
#>    state                fips  usps  month    year cutoff
#>    <chr>                <chr> <chr> <chr>   <int>  <dbl>
#>  1 United States        <NA>  <NA>  January  2002     68
#>  2 Alabama              01    AL    January  2002     21
#>  3 Alaska               02    AK    January  2002     79
#>  4 Arizona              04    AZ    January  2002    107
#>  5 Arkansas             05    AR    January  2002     21
#>  6 California           06    CA    January  2002    107
#>  7 Colorado             08    CO    January  2002     42
#>  8 Connecticut          09    CT    January  2002    157
#>  9 Delaware             10    DE    January  2002    122
#> 10 District of Columbia 11    DC    January  2002    200
#> # ℹ 1,082 more rows

# But you can always convert them back to the original wide format
melig::parents %>% 
  unite_("monyear", c("month", "year"), sep = " ") %>% 
  spread(monyear, cutoff)
#> # A tibble: 52 × 24
#>    state  fips  usps  `April 2003` `December 2009` `January 2002` `January 2008`
#>    <chr>  <chr> <chr>        <dbl>           <dbl>          <dbl>          <dbl>
#>  1 Alaba… 01    AL              20              24             21             26
#>  2 Alaska 02    AK              81              81             79             81
#>  3 Arizo… 04    AZ             200             106            107            200
#>  4 Arkan… 05    AR              20              17             21             18
#>  5 Calif… 06    CA             107             106            107            106
#>  6 Color… 08    CO              47              66             42             66
#>  7 Conne… 09    CT             107             191            157            191
#>  8 Delaw… 10    DE             120             121            122            106
#>  9 Distr… 11    DC             200             207            200            207
#> 10 Flori… 12    FL              63              53             66             56
#> # ℹ 42 more rows
#> # ℹ 17 more variables: `January 2009` <dbl>, `January 2011` <dbl>,
#> #   `January 2012` <dbl>, `January 2013` <dbl>, `January 2014` <dbl>,
#> #   `January 2015` <dbl>, `January 2016` <dbl>, `January 2017` <dbl>,
#> #   `January 2018` <dbl>, `January 2019` <dbl>, `January 2020` <dbl>,
#> #   `January 2021` <dbl>, `January 2022` <dbl>, `January 2023` <dbl>,
#> #   `July 2004` <dbl>, `July 2005` <dbl>, `July 2006` <dbl>
```

## Save as Other Data Formats

``` r
# save as Stata format
haven::write_dta(melig::parents, "pa0218.dta")

# or
rio::export(melig::parents, "pa0218.dta")
```

Or download the `*.rda` file and try the
[rioweb](https://lbraglia.shinyapps.io/rioweb) made by
@[lbraglia](https://github.com/lbraglia).

## Explore the Vignette

For a more detailed exploration of the Medicaid income eligibility
cutoffs data, check out the
[vignette](https://jjchern.github.io/melig/articles/medicaid-income-eligibility-cutoffs-overview.html).
To access the vignette within R, after installing the package, you can
view the vignette using the following command in your R console:

``` r
vignette("medicaid-income-eligibility-cutoffs-overview")
```
