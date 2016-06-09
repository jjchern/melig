
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/jjchern/melig.svg?branch=master)](https://travis-ci.org/jjchern/melig)

About `melig`
=============

The R package `melig` contains information on **M**edicaid income **elig**ibility limits, collected by [the Kaiser Family Foundation](http://kff.org/data-collection/trends-in-medicaid-income-eligibility-limits/). It includes the following datasets:

-   `children.rda`:
    -   [Medicaid and CHIP Income Eligibility Limits for Children, 2000-2016](http://kff.org/medicaid/state-indicator/medicaidchip-upper-income-eligibility-limits-for-children/)
    -   [Medicaid Income Eligibility Limits for Infants Ages 0 – 1, 2000-2016](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-infants-ages-0-1/)
    -   [Medicaid Income Eligibility Limits for Children Ages 1 – 5, 2000-2016](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-1-5/)
    -   [Medicaid Income Eligibility Limits for Children Ages 6-18, 2000-2016](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-6-18/)
    -   [Separate Children’s Health Insurance Program (CHIP) Income Eligibility Limits for Children, 2000-2016](http://kff.org/medicaid/state-indicator/separate-childrens-health-insurance-program-chip-income-eligibility-limits-for-children/)
-   `prenant_wom.rda`: [Medicaid and CHIP Income Eligibility Limits for Pregnant Women, 2003-2016](http://kff.org/medicaid/state-indicator/medicaid-and-chip-income-eligibility-limits-for-pregnant-women/)
-   `parents.rda`: [Medicaid Income Eligibility Limits for Parents, 2002-2016](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-parents/)
-   `childless_adults.rda`: [Medicaid Income Eligibility Limits for Other Non-Disabled Adults, 2011-2016](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-other-non-disabled-adults/)

The datasets have been [tidied](http://vita.had.co.nz/papers/tidy-data.pdf).

The [`/data-raw/`](https://github.com/jjchern/melig/tree/master/data-raw) folder contains raw data and R scripts.

Useful Links
============

-   [Medicaid Income Eligibility Limits (Most Recent Data)](http://kff.org/state-category/medicaid-chip/medicaidchip-eligibility-limits/)
-   [Annual Updates on Eligibility Rules, Enrollment and Renewal Procedures, and Cost-Sharing Practices in Medicaid and CHIP](http://kff.org/medicaid/report/annual-updates-on-eligibility-rules-enrollment-and/)

Installing the Package
======================

``` r
# install.packages("devtools")
devtools::install_github("jjchern/melig")
```

Usage
=====

Long and Wide Formats
---------------------

``` r
library(dplyr, warn.conflicts = FALSE)
library(formattable)

# the datasets have been tidied
melig::parents
#> Source: local data frame [714 x 6]
#> 
#>                   state  fips  usps   month  year cutoff
#>                   <chr> <int> <chr>   <chr> <chr>  <int>
#> 1               Alabama     1    AL January  2002     21
#> 2                Alaska     2    AK January  2002     79
#> 3               Arizona     4    AZ January  2002    107
#> 4              Arkansas     5    AR January  2002     21
#> 5            California     6    CA January  2002    107
#> 6              Colorado     8    CO January  2002     42
#> 7           Connecticut     9    CT January  2002    157
#> 8              Delaware    10    DE January  2002    122
#> 9  District of Columbia    11    DC January  2002    200
#> 10              Florida    12    FL January  2002     66
#> ..                  ...   ...   ...     ...   ...    ...

# but you can covert it back to the original wide format
melig::parents %>% 
  tidyr::unite_("monyear", c("month", "year"), sep = " ") %>% 
  tidyr::spread(monyear, cutoff)
#> Source: local data frame [51 x 17]
#> 
#>                   state  fips  usps April 2003 December 2009 January 2002
#> *                 <chr> <int> <chr>      <int>         <int>        <int>
#> 1               Alabama     1    AL         20            24           21
#> 2                Alaska     2    AK         81            81           79
#> 3               Arizona     4    AZ        200           106          107
#> 4              Arkansas     5    AR         20            17           21
#> 5            California     6    CA        107           106          107
#> 6              Colorado     8    CO         47            66           42
#> 7           Connecticut     9    CT        107           191          157
#> 8              Delaware    10    DE        120           121          122
#> 9  District of Columbia    11    DC        200           207          200
#> 10              Florida    12    FL         63            53           66
#> ..                  ...   ...   ...        ...           ...          ...
#> Variables not shown: January 2008 <int>, January 2009 <int>, January 2011
#>   <int>, January 2012 <int>, January 2013 <int>, January 2014 <int>,
#>   January 2015 <int>, January 2016 <int>, July 2004 <int>, July 2005
#>   <int>, July 2006 <int>.
```

States that Have Income Cutoffs Greater Than 100 Federal Poverty Guidelines in 2014
-----------------------------------------------------------------------------------

``` r
# for parents
melig::parents %>% 
  filter(year == 2014) %>% 
  filter(cutoff >= 100) %>% 
  select(state, fips, usps, pa_cutoff = cutoff) %>% 
  formattable(
    list(pa_cutoff = normalize_bar("lightgreen", 0.2))
  )
```

|                 state|  fips|  usps|                                                                                                                                     pa\_cutoff|
|---------------------:|-----:|-----:|----------------------------------------------------------------------------------------------------------------------------------------------:|
|                Alaska|     2|    AK|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 38.51%">128</span>|
|               Arizona|     4|    AZ|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              Arkansas|     5|    AR|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|            California|     6|    CA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              Colorado|     8|    CO|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|           Connecticut|     9|    CT|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 86.78%">201</span>|
|              Delaware|    10|    DE|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|  District of Columbia|    11|    DC|  <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 100.00%">221</span>|
|                Hawaii|    15|    HI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              Illinois|    17|    IL|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|                  Iowa|    19|    IA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              Kentucky|    21|    KY|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|                 Maine|    23|    ME|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 23.31%">105</span>|
|              Maryland|    24|    MD|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|         Massachusetts|    25|    MA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              Michigan|    26|    MI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|             Minnesota|    27|    MN|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 89.42%">205</span>|
|                Nevada|    32|    NV|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|            New Jersey|    34|    NJ|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|            New Mexico|    35|    NM|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|              New York|    36|    NY|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|          North Dakota|    38|    ND|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|                  Ohio|    39|    OH|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|                Oregon|    41|    OR|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|          Rhode Island|    44|    RI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|             Tennessee|    47|    TN|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 27.27%">111</span>|
|               Vermont|    50|    VT|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|            Washington|    53|    WA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|         West Virginia|    54|    WV|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 45.12%">138</span>|
|             Wisconsin|    55|    WI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 20.00%">100</span>|

``` r

# for childless adults
melig::childless_adults %>% 
  filter(year == 2014) %>% 
  filter(cutoff >= 100) %>% 
  select(state, fips, usps, ca_cutoff = cutoff) %>% 
  formattable(
    list(ca_cutoff = normalize_bar("lightgreen", 0.2))
  )
```

|                 state|  fips|  usps|                                                                                                                                     ca\_cutoff|
|---------------------:|-----:|-----:|----------------------------------------------------------------------------------------------------------------------------------------------:|
|               Arizona|     4|    AZ|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Arkansas|     5|    AR|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|            California|     6|    CA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Colorado|     8|    CO|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|           Connecticut|     9|    CT|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Delaware|    10|    DE|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|  District of Columbia|    11|    DC|  <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 100.00%">215</span>|
|                Hawaii|    15|    HI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Illinois|    17|    IL|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|                  Iowa|    19|    IA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Kentucky|    21|    KY|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Maryland|    24|    MD|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|         Massachusetts|    25|    MA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              Michigan|    26|    MI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|             Minnesota|    27|    MN|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 93.04%">205</span>|
|                Nevada|    32|    NV|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|            New Jersey|    34|    NJ|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|            New Mexico|    35|    NM|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|              New York|    36|    NY|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|          North Dakota|    38|    ND|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|                  Ohio|    39|    OH|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|                Oregon|    41|    OR|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|          Rhode Island|    44|    RI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|               Vermont|    50|    VT|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|            Washington|    53|    WA|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|         West Virginia|    54|    WV|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 46.43%">138</span>|
|             Wisconsin|    55|    WI|   <span style="display: block; direction: rtl; border-radius: 4px; padding-right: 2px; background-color: lightgreen; width: 20.00%">100</span>|

Income Cutoffs for Parents in 2013--2015
----------------------------------------

``` r
melig::parents %>% 
  mutate(
    year = if_else(year == "2009" & month == "December", "2010", year),
    year = year %>% as.integer()
  ) %>% 
  filter(year %in% 2013:2015) %>% 
  select(-month, -state) %>% 
  tidyr::spread(year, cutoff) %>% 
  rename(
    pa_cutoff_2013 = `2013`,
    pa_cutoff_2014 = `2014`,
    pa_cutoff_2015 = `2015`
  ) %>% 
  formattable(
    list(
     pa_cutoff_2013 = color_tile("white", "orange"),
     pa_cutoff_2014 = color_tile("white", "orange"),
     pa_cutoff_2015 = color_tile("white", "orange")
    )
  )
```

|  fips|  usps|                                                                                                        pa\_cutoff\_2013|                                                                                                        pa\_cutoff\_2014|                                                                                                        pa\_cutoff\_2015|
|-----:|-----:|-----------------------------------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------------------------------------------:|
|     1|    AL|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf6">23</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">16</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">18</span>|
|     2|    AK|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe2af">78</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffcd73">128</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc65e">146</span>|
|     4|    AZ|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd68b">106</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|     5|    AR|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">16</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|     6|    CA|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd68b">106</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|     8|    CO|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd68b">106</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|     9|    CT|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffaf1e">191</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffad18">201</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffad19">201</span>|
|    10|    DE|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffcf79">120</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    11|    DC|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa90b">206</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">221</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">221</span>|
|    12|    FL|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffeccb">56</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff6e7">35</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff7ea">34</span>|
|    13|    GA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff0d5">48</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff4e2">39</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff6e5">38</span>|
|    15|    HI|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc762">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    16|    ID|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff5e4">37</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffaf1">27</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf3">27</span>|
|    17|    IL|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc761">139</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    18|    IN|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf4">24</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf5">24</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffcf7">24</span>|
|    19|    IA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe2ac">80</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    20|    KS|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff8eb">31</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff5e3">38</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff6e5">38</span>|
|    21|    KY|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffecca">57</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    22|    LA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf4">24</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf5">24</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffcf7">24</span>|
|    23|    ME|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffab13">200</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd790">105</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd891">105</span>|
|    24|    MD|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffcf77">122</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    25|    MA|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffca69">133</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    26|    MI|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe9c1">64</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    27|    MN|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">215</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffac13">205</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    28|    MS|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff9ee">29</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff9ee">29</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffaf2">28</span>|
|    29|    MO|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff6e6">35</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffbf5">24</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffcf8">23</span>|
|    30|    MT|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffedce">54</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd2">52</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff0d5">51</span>|
|    31|    NE|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffecc9">58</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffedce">55</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffeed0">55</span>|
|    32|    NV|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe0a7">84</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    33|    NH|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff0d7">47</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe5b5">75</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    34|    NJ|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffab13">200</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    35|    NM|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffdfa6">85</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    36|    NY|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc253">150</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    37|    NC|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff0d7">47</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff2da">45</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff3dd">45</span>|
|    38|    ND|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffecca">57</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    39|    OH|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffda98">96</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    40|    OK|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd2">51</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff0d7">48</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff2db">46</span>|
|    41|    OR|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff4e1">39</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    42|    PA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffecc9">58</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff5e3">38</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    44|    RI|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffb42b">181</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    45|    SC|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffdda1">89</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe8bf">67</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe9c1">67</span>|
|    46|    SD|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd3">50</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffeecf">54</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd3">53</span>|
|    47|    TN|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffcf77">122</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd588">111</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd994">103</span>|
|    48|    TX|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffaf3">25</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffdfb">19</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fffefd">19</span>|
|    49|    UT|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff3dd">42</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff1d8">47</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff2db">46</span>|
|    50|    VT|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffaf1e">191</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    51|    VA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff8ed">30</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd2">52</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff3dd">45</span>|
|    53|    WA|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe6b8">71</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    54|    WV|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff8eb">31</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc967">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc968">138</span>|
|    55|    WI|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffab13">200</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffda96">100</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffda97">100</span>|
|    56|    WY|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffefd3">50</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffecc9">59</span>|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffedcc">58</span>|

Income Cutoffs for Childless Adults in 2013--2015
-------------------------------------------------

``` r
melig::childless_adults %>% 
  mutate(
    year = if_else(year == "2009" & month == "December", "2010", year),
    year = year %>% as.integer()
  ) %>% 
  filter(year %in% 2013:2015) %>% 
  select(-month, -state) %>% 
  tidyr::spread(year, cutoff) %>% 
  rename(
    ca_cutoff_2013 = `2013`,
    ca_cutoff_2014 = `2014`,
    ca_cutoff_2015 = `2015`
  ) %>% 
  formattable(
    list(
     ca_cutoff_2013 = color_tile("white", "orange"),
     ca_cutoff_2014 = color_tile("white", "orange"),
     ca_cutoff_2015 = color_tile("white", "orange")
    )
  )
```

|  fips|  usps|                                                                                                        ca\_cutoff\_2013|                                                                                                        ca\_cutoff\_2014|                                                                                                        ca\_cutoff\_2015|
|-----:|-----:|-----------------------------------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------------------------------------------:|-----------------------------------------------------------------------------------------------------------------------:|
|     1|    AL|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|     2|    AK|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|     4|    AZ|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd486">100</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|     5|    AR|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|     6|    CA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|     8|    CO|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #fff6e6">20</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|     9|    CT|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffe1aa">70</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    10|    DE|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd07a">110</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    11|    DC|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">211</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">215</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa500">215</span>|
|    12|    FL|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    13|    GA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    15|    HI|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd486">100</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    16|    ID|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    17|    IL|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    18|    IN|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    19|    IA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    20|    KS|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    21|    KY|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    22|    LA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    23|    ME|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    24|    MD|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    25|    MA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    26|    MI|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    27|    MN|   <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffdfa4">75</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffa90b">205</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    28|    MS|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    29|    MO|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    30|    MT|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    31|    NE|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    32|    NV|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    33|    NH|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    34|    NJ|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    35|    NM|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    36|    NY|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd486">100</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    37|    NC|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    38|    ND|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    39|    OH|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    40|    OK|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    41|    OR|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    42|    PA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    44|    RI|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    45|    SC|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    46|    SD|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    47|    TN|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    48|    TX|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    49|    UT|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    50|    VT|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffba3d">160</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    51|    VA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|
|    53|    WA|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    54|    WV|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffc55b">138</span>|
|    55|    WI|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd588">100</span>|  <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffd588">100</span>|
|    56|    WY|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|    <span style="display: block; padding: 0 4px; direction: rtl; border-radius: 4px; background-color: #ffffff">0</span>|

Income Cutoffs for Children
---------------------------

*Note*: The children dataset, `melig::children`, has

-   a `type` variable that separates Medicaid and CHIP programs, and
-   an `agegrp` variable that indicates specific age groups.

Because the age information for the CHIP programs (`type == CHIP`) is not available from the source data, I assign a value of "0-18" to the corresponding `age` variable, though some states' CHIP programs don't cover all children under age 19 in some years.

``` r
# the data
melig::children
#> Source: local data frame [3,060 x 8]
#> 
#>      state  fips  usps     type agegrp   month  year cutoff
#>      <chr> <int> <chr>    <chr>  <chr>   <chr> <chr>  <int>
#> 1  Alabama     1    AL Medicaid    0-1 October  2000    133
#> 2  Alabama     1    AL Medicaid    1-5 October  2000    133
#> 3  Alabama     1    AL Medicaid   6-18 October  2000    100
#> 4  Alabama     1    AL     CHIP   0-18 October  2000    200
#> 5  Alabama     1    AL Medicaid    0-1 January  2002    133
#> 6  Alabama     1    AL Medicaid    1-5 January  2002    133
#> 7  Alabama     1    AL Medicaid   6-18 January  2002    100
#> 8  Alabama     1    AL     CHIP   0-18 January  2002    200
#> 9  Alabama     1    AL Medicaid    0-1   April  2003    133
#> 10 Alabama     1    AL Medicaid    1-5   April  2003    133
#> ..     ...   ...   ...      ...    ...     ...   ...    ...

# IL
melig::children %>% 
  filter(usps == "IL") 
#> Source: local data frame [60 x 8]
#> 
#>       state  fips  usps     type agegrp   month  year cutoff
#>       <chr> <int> <chr>    <chr>  <chr>   <chr> <chr>  <int>
#> 1  Illinois    17    IL Medicaid    0-1 October  2000    200
#> 2  Illinois    17    IL Medicaid    1-5 October  2000    133
#> 3  Illinois    17    IL Medicaid   6-18 October  2000    133
#> 4  Illinois    17    IL     CHIP   0-18 October  2000    185
#> 5  Illinois    17    IL Medicaid    0-1 January  2002    200
#> 6  Illinois    17    IL Medicaid    1-5 January  2002    133
#> 7  Illinois    17    IL Medicaid   6-18 January  2002    133
#> 8  Illinois    17    IL     CHIP   0-18 January  2002    185
#> 9  Illinois    17    IL Medicaid    0-1   April  2003    200
#> 10 Illinois    17    IL Medicaid    1-5   April  2003    133
#> ..      ...   ...   ...      ...    ...     ...   ...    ...
```

Save as Other Data Formats
--------------------------

``` r
# save as Stata format
haven::write_dta(melig::parents, "pa0216.dta")

# or
rio::export(melig::parents, "pa0216.dta")
```

Or download the `*.rda` file and try the [rioweb](https://lbraglia.shinyapps.io/rioweb) made by \[@lbraglia\](<https://github.com/lbraglia>).
