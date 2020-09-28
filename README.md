
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fiderent

<!-- badges: start -->

[![R build
status](https://github.com/fmichonneau/fiderent/workflows/R-CMD-check/badge.svg)](https://github.com/fmichonneau/fiderent/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/fiderent)](https://CRAN.R-project.org/package=fiderent)
<!-- badges: end -->

fiderent allows you to compare whether files with the same file names in
two different folders are actually identical. Determining whether two
files are identical is sometimes done based on their timestamps or their
sizes. There are many situations where these methods is not suitable. A
more robust method is to compare their [md5sum
hashes](https://en.wikipedia.org/wiki/Md5sum).

I created this package to identify the files that were changed
subsequent Jekyll builds. Once this list of file was identified, I could
then invalidate them in their CloudFront distribution. I created a
[GitHub Action](https://github.com/fmichonneau/ga-compare-folders) that
relies on this package.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fmichonneau/fiderent")
```

## Example

To demonstrate the use of the package, let’s compare the files that have
changed between the versions 0.8.0 and 0.8.0.1 of the `dplyr` package.

``` r
## download the two dplyr archives
download.file(
  "https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.8.0.tar.gz",
  "dplyr_0.8.0.tar.gz"
)
download.file(
  "https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.8.0.1.tar.gz",
  "dplyr_0.8.0.1.tar.gz"
)

## extract them in two different folders
untar("dplyr_0.8.0.tar.gz",  exdir = "dplyr_0.8.0")
untar("dplyr_0.8.0.1.tar.gz",  exdir = "dplyr_0.8.0.1")

## load the fiderent package
library(fiderent)

## get the full comparison between the two folders
compare_folders("dplyr_0.8.0", "dplyr_0.8.0.1")
#> # A tibble: 440 x 4
#>    files         `/home/francois/R-dev/fid… `/home/francois/R-dev/fid… identical
#>    <fs::path>    <chr>                      <chr>                      <lgl>    
#>  1 /DESCRIPTION  f0632e50b2e4d6fa21db08455… ba5d03865dd38f7d6f0c299c8… FALSE    
#>  2 /LICENSE      c7180788a8ec3035d54fc733f… c7180788a8ec3035d54fc733f… TRUE     
#>  3 /MD5          e9846e4a590600faa337b4aeb… 46d2c1d85e01a994674fd6b87… FALSE    
#>  4 /NAMESPACE    e884ab3192f1a0a21b9b4a7f4… e884ab3192f1a0a21b9b4a7f4… TRUE     
#>  5 /NEWS.md      caf1e85bd53dfc528c0fe22d5… caf1e85bd53dfc528c0fe22d5… TRUE     
#>  6 /R/RcppExpor… e19f85e800b3b920f4bdd9b2d… e19f85e800b3b920f4bdd9b2d… TRUE     
#>  7 /R/all-equal… 385c938e7ddaf4321adf4ee19… 385c938e7ddaf4321adf4ee19… TRUE     
#>  8 /R/bench-com… 9d5b6b054df3934c26af87b53… 9d5b6b054df3934c26af87b53… TRUE     
#>  9 /R/bind.r     1f12f8b0dc718ffd7ddb1d89e… 1f12f8b0dc718ffd7ddb1d89e… TRUE     
#> 10 /R/case_when… 8d39ad0a1e4b1341b5b9a4956… 8d39ad0a1e4b1341b5b9a4956… TRUE     
#> # … with 430 more rows

## extract just the names of the files that have changed
library(dplyr)
compare_folders("dplyr_0.8.0", "dplyr_0.8.0.1") %>%
  filter(!identical) %>%
  pull(files)
#> /DESCRIPTION
#> /MD5
#> /build/dplyr.pdf
#> /inst/include/dplyr/hybrid/vector_result/ntile.h
```

## Etymology

Try to say “different folders” ten times very fast.

## Code of Conduct

Please note that the fiderent project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
