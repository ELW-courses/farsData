
<!-- README.md is generated from README.Rmd. Please edit that file -->

# farsData

<!-- badges: start -->

<!-- badges: end -->

The goal of farsData is to assist with reading, analyzing, and
visualizing data acquired from the US National Highway Traffic Safety
Administration’s Fatality Analysis Reporting System (FARS) database.
This package and repo are part of the John Hopkins Coursera course:
Mastering R Package Development, to demonstrate how to create a package,
run tests, and include a Travis badge.

## Installation

You can install the development version of farsData with:

``` r
library(devtools)
install.packages("ELW-courses/farsData")
```

## Example

The following example shows how to provide a summary of the FARS data
for every month in 2014 and 2015.

``` r
library(farsData)
fars_summarize_years(c(2014, 2015))
#> Warning: `tbl_df()` was deprecated in dplyr 1.0.0.
#> ℹ Please use `tibble::as_tibble()` instead.
#> ℹ The deprecated feature was likely used in the farsData package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> # A tibble: 12 × 3
#>    MONTH `2014` `2015`
#>    <dbl>  <int>  <int>
#>  1     1   2168   2368
#>  2     2   1893   1968
#>  3     3   2245   2385
#>  4     4   2308   2430
#>  5     5   2596   2847
#>  6     6   2583   2765
#>  7     7   2696   2998
#>  8     8   2800   3016
#>  9     9   2618   2865
#> 10    10   2831   3019
#> 11    11   2714   2724
#> 12    12   2604   2781
```

The follwing example shows how to provide a map with plotted FARS data
for the state of Tennessee (STATE = 47) in 2013.

``` r
library(farsData)
fars_map_state(47, 2013)
```

