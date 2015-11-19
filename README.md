<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/jjchern/melig.svg?branch=master)](https://travis-ci.org/jjchern/melig)

About `melig`
=============

The R package `melig` contains information on **M**edicaid income **elig**ibility limits, collected by [the Kaiser Family Foundation](http://kff.org/data-collection/trends-in-medicaid-income-eligibility-limits/). It includes the following datasets:

-   `ch0015.rda`:
    -   [Medicaid and CHIP Income Eligibility Limits for Children, 2000-2015](http://kff.org/medicaid/state-indicator/medicaidchip-upper-income-eligibility-limits-for-children-2000-2015/)
    -   [Medicaid Income Eligibility Limits for Infants Ages 0 – 1, 2000-2015](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-infants-ages-0-1-2000-2015/)
    -   [Medicaid Income Eligibility Limits for Children Ages 1 – 5, 2000-2015](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-1-5-2000-2015/)
    -   [Medicaid Income Eligibility Limits for Children Ages 6-18, 2000-2015](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-children-ages-6-18-2000-2015/)
    -   [Separate Children’s Health Insurance Program (CHIP) Income Eligibility Limits for Children, 2000-2015](http://kff.org/medicaid/state-indicator/separate-childrens-health-insurance-program-chip-income-eligibility-limits-for-children-2000-2015/#)
-   `pw0315.rda`: [Medicaid and CHIP Income Eligibility Limits for Pregnant Women, 2003-2015](http://kff.org/medicaid/state-indicator/medicaid-and-chip-income-eligibility-limits-for-pregnant-women-2003-2015/)
-   `pa0215.rda`: [Medicaid Income Eligibility Limits for Parents, 2002-2015](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-parents-2002-2015)
-   `ca1115.rda`: [Medicaid Income Eligibility Limits for Other Non-Disabled Adults, 2011-2015](http://kff.org/medicaid/state-indicator/medicaid-income-eligibility-limits-for-other-non-disabled-adults-2011-2015/)

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
library(dplyr)

# the datasets have been tidied
melig::pa0215
#> Source: local data frame [663 x 6]
#> 
#>                   state  fips  usps   month  year cutoff
#>                   (chr) (int) (chr)   (chr) (chr)  (int)
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
melig::pa0215 %>% 
  tidyr::unite_("monyear", c("month", "year"), sep = " ") %>% 
  tidyr::spread(monyear, cutoff)
#> Source: local data frame [51 x 16]
#> 
#>                   state  fips  usps April 2003 December 2009 January 2002
#>                   (chr) (int) (chr)      (int)         (int)        (int)
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
#> Variables not shown: January 2008 (int), January 2009 (int), January 2011
#>   (int), January 2012 (int), January 2013 (int), January 2014 (int),
#>   January 2015 (int), July 2004 (int), July 2005 (int), July 2006 (int)
```

States that Have Income Cutoff Greater Than 100 Federal Poverty Guidelines in 2014
----------------------------------------------------------------------------------

``` r
# for parents
melig::pa0215 %>% 
  filter(year == 2014) %>% 
  filter(cutoff >= 100) %>% 
  select(state, fips, usps, pa_cutoff = cutoff) %>% 
  pander::pander()
```

<table>
<colgroup>
<col width="29%" />
<col width="9%" />
<col width="9%" />
<col width="15%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">state</th>
<th align="center">fips</th>
<th align="center">usps</th>
<th align="center">pa_cutoff</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">Alaska</td>
<td align="center">2</td>
<td align="center">AK</td>
<td align="center">128</td>
</tr>
<tr class="even">
<td align="center">Arizona</td>
<td align="center">4</td>
<td align="center">AZ</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Arkansas</td>
<td align="center">5</td>
<td align="center">AR</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">California</td>
<td align="center">6</td>
<td align="center">CA</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Colorado</td>
<td align="center">8</td>
<td align="center">CO</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Connecticut</td>
<td align="center">9</td>
<td align="center">CT</td>
<td align="center">201</td>
</tr>
<tr class="odd">
<td align="center">Delaware</td>
<td align="center">10</td>
<td align="center">DE</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">District of Columbia</td>
<td align="center">11</td>
<td align="center">DC</td>
<td align="center">221</td>
</tr>
<tr class="odd">
<td align="center">Hawaii</td>
<td align="center">15</td>
<td align="center">HI</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Illinois</td>
<td align="center">17</td>
<td align="center">IL</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Iowa</td>
<td align="center">19</td>
<td align="center">IA</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Kentucky</td>
<td align="center">21</td>
<td align="center">KY</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Maine</td>
<td align="center">23</td>
<td align="center">ME</td>
<td align="center">105</td>
</tr>
<tr class="even">
<td align="center">Maryland</td>
<td align="center">24</td>
<td align="center">MD</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Massachusetts</td>
<td align="center">25</td>
<td align="center">MA</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Michigan</td>
<td align="center">26</td>
<td align="center">MI</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Minnesota</td>
<td align="center">27</td>
<td align="center">MN</td>
<td align="center">205</td>
</tr>
<tr class="even">
<td align="center">Nevada</td>
<td align="center">32</td>
<td align="center">NV</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">New Jersey</td>
<td align="center">34</td>
<td align="center">NJ</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">New Mexico</td>
<td align="center">35</td>
<td align="center">NM</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">New York</td>
<td align="center">36</td>
<td align="center">NY</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">North Dakota</td>
<td align="center">38</td>
<td align="center">ND</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Ohio</td>
<td align="center">39</td>
<td align="center">OH</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Oregon</td>
<td align="center">41</td>
<td align="center">OR</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Rhode Island</td>
<td align="center">44</td>
<td align="center">RI</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Tennessee</td>
<td align="center">47</td>
<td align="center">TN</td>
<td align="center">111</td>
</tr>
<tr class="odd">
<td align="center">Vermont</td>
<td align="center">50</td>
<td align="center">VT</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Washington</td>
<td align="center">53</td>
<td align="center">WA</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">West Virginia</td>
<td align="center">54</td>
<td align="center">WV</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Wisconsin</td>
<td align="center">55</td>
<td align="center">WI</td>
<td align="center">100</td>
</tr>
</tbody>
</table>

``` r

# for childless adults
melig::ca1115 %>% 
  filter(year == 2014) %>% 
  filter(cutoff >= 100) %>% 
  select(state, fips, usps, ca_cutoff = cutoff) %>% 
  pander::pander()
```

<table>
<colgroup>
<col width="29%" />
<col width="9%" />
<col width="9%" />
<col width="15%" />
</colgroup>
<thead>
<tr class="header">
<th align="center">state</th>
<th align="center">fips</th>
<th align="center">usps</th>
<th align="center">ca_cutoff</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center">Arizona</td>
<td align="center">4</td>
<td align="center">AZ</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Arkansas</td>
<td align="center">5</td>
<td align="center">AR</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">California</td>
<td align="center">6</td>
<td align="center">CA</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Colorado</td>
<td align="center">8</td>
<td align="center">CO</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Connecticut</td>
<td align="center">9</td>
<td align="center">CT</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Delaware</td>
<td align="center">10</td>
<td align="center">DE</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">District of Columbia</td>
<td align="center">11</td>
<td align="center">DC</td>
<td align="center">215</td>
</tr>
<tr class="even">
<td align="center">Hawaii</td>
<td align="center">15</td>
<td align="center">HI</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Illinois</td>
<td align="center">17</td>
<td align="center">IL</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Iowa</td>
<td align="center">19</td>
<td align="center">IA</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Kentucky</td>
<td align="center">21</td>
<td align="center">KY</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Maryland</td>
<td align="center">24</td>
<td align="center">MD</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Massachusetts</td>
<td align="center">25</td>
<td align="center">MA</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Michigan</td>
<td align="center">26</td>
<td align="center">MI</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Minnesota</td>
<td align="center">27</td>
<td align="center">MN</td>
<td align="center">205</td>
</tr>
<tr class="even">
<td align="center">Nevada</td>
<td align="center">32</td>
<td align="center">NV</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">New Jersey</td>
<td align="center">34</td>
<td align="center">NJ</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">New Mexico</td>
<td align="center">35</td>
<td align="center">NM</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">New York</td>
<td align="center">36</td>
<td align="center">NY</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">North Dakota</td>
<td align="center">38</td>
<td align="center">ND</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Ohio</td>
<td align="center">39</td>
<td align="center">OH</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Oregon</td>
<td align="center">41</td>
<td align="center">OR</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Rhode Island</td>
<td align="center">44</td>
<td align="center">RI</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">Vermont</td>
<td align="center">50</td>
<td align="center">VT</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Washington</td>
<td align="center">53</td>
<td align="center">WA</td>
<td align="center">138</td>
</tr>
<tr class="even">
<td align="center">West Virginia</td>
<td align="center">54</td>
<td align="center">WV</td>
<td align="center">138</td>
</tr>
<tr class="odd">
<td align="center">Wisconsin</td>
<td align="center">55</td>
<td align="center">WI</td>
<td align="center">100</td>
</tr>
</tbody>
</table>

Income Cutoffs for Children
---------------------------

*Note*: The children dataset, `melig::ch0015`, has

-   a `type` variable that separates Medicaid and CHIP programs, and
-   an `agegrp` variable that indicates specific age groups.

Because the age information for the CHIP programs (`type == CHIP`) is not available from the source data, I assign a value of "0-18" to the corresponding `age` variable, though some states' CHIP programs don't cover all children under age 19 in some years.

``` r
# the data
melig::ch0015
#> Source: local data frame [2,856 x 8]
#> 
#>      state  fips  usps     type agegrp   month  year cutoff
#>      (chr) (int) (chr)    (chr)  (chr)   (chr) (chr)  (int)
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
melig::ch0015 %>% 
  filter(usps == "IL") 
#> Source: local data frame [56 x 8]
#> 
#>       state  fips  usps     type agegrp   month  year cutoff
#>       (chr) (int) (chr)    (chr)  (chr)   (chr) (chr)  (int)
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
haven::write_dta(melig::pa0215, "pa0215.dta")

# or
rio::export(melig::pa0215, "pa0215.dta")
```

Or download the `*.rda` file and try the (rioweb)[<https://lbraglia.shinyapps.io/rioweb>] made by [@lbraglia](<https://github.com/lbraglia>).
