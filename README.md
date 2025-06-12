
# mdtab2xlsx

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `mdtab2xlsx` is to convert tables stored or created as markdown files to excel files 

## Installation

You can install the development version of mdtab2xlsx like so:

``` r
# Install devtools if you haven't already
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Install your package
devtools::install_github("dnzambuli/mdtab2xlsx")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mdtab2xlsx)

## basic example code using a mortality table md file
desired_list = list(
    `Age(x)` = "integer",
    `l_x` = "integer",
    `q_x` = "numeric"
)
mdxlsx(temp_file,
desired_list,
"./test_output")

# read the created file as 
read_data <- readxl::read_excel(test_output.xlsx)
View(read_data)
```

## Issues

If you encounter any bugs or have feature requests, please open an issue [here](https://github.com/dnzambuli/mdtab2xlsx/issues).
