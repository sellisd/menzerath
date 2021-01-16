
<!-- README.md is generated from README.Rmd. Please edit that file -->

# menzerath

## Introduction

The menzerath package is used to describe fit and plot data following
the Menzerath’s law. Menzerath’s law (also known as Menzerath-Altmann
law) was initially formulated as a linguistic law describing the
relationship between the size of a linguistic construct and its
constituents. Consider for example the relationship between the size of
a word (`y`) and its syllables (`x`). According to Menzerath’s law the
expected relationship should follow the relationship:

\[ y = a \cdot x^b \cdot e^{-cx} \] where `a`, `b` and `c` are
parameters of the law.

## Installation

The package can be installed from github in R by running the following
commands:

``` r
install.packages("devtools")
devtools::install_github("sellisd/menzerath")
```

## Usage

To demonstrate how to use the package we are going to analyze a classic
dataset originally used by Altman 1980 in the mathematical formulation
of the Menzerath-Altmann law. The dataset relates the word size,
measured in terms of number of syllables to the average syllable size in
the word. The size of syllables is measured in terms of number of
phonemes.

First we load the library and have a look at the dataset

``` r
library(menzerath)
data(morpheme_syllable)
morpheme_syllable
#>   x    y
#> 1 1 3.10
#> 2 2 2.53
#> 3 3 2.29
#> 4 4 2.12
#> 5 5 2.09
```

We can transform the table to a menzerath object and create a plot:

``` r
ms <- menzerath(morpheme_syllable)
plot(ms)
```

<img src="man/figures/README-plot_morpheme_syllable-1.png" width="100%" />

Then estimate the parameters of the law:

``` r
fit_menzerath <- fit(ms)
print(fit_menzerath)
#> 
#> Call:
#> lm(formula = log(object$y) ~ log(object$x) + object$x, data = as.data.frame(x = object$x, 
#>     y = object$y, stringsAsFactors = FALSE))
#> 
#> Coefficients:
#>   (Intercept)  log(object$x)       object$x  
#>       1.08529       -0.36854        0.04764
```

As a linear fit is performed on log scale in order to get the estimated
parameters the coefficients have to be transformed. This is facilitated
by the `get_parameters` function:

``` r
get_parameters(fit_menzerath)
#> $a
#> [1] 2.9603
#> 
#> $b
#> [1] -0.3685362
#> 
#> $c
#> [1] -0.04764427
```

The fit can also be visualized with a ribbon plot:

``` r
plot(ms, fit=TRUE)
```

<img src="man/figures/README-morpheme_syllable_plot-1.png" width="100%" />
We can now repeat the same analysis in a more recent and larger dataset
(Torre et al., 2019). The `BG_word_time` dataset contains the
relationship between the size of breath groups and average word size (in
seconds). Breath groups are defined by pauses (e.g. for breathing)
during speech.

``` r
BG_word_time
#> # A tibble: 45,034 x 2
#>        x     y
#>    <dbl> <dbl>
#>  1     1 0.405
#>  2     1 0.329
#>  3     1 0.146
#>  4     9 0.318
#>  5    10 0.223
#>  6     1 0.442
#>  7     4 0.323
#>  8    11 0.213
#>  9     1 0.261
#> 10     7 0.309
#> # … with 45,024 more rows
```

``` r
BG_word_time_menzerath = menzerath(BG_word_time)
plot(BG_word_time_menzerath, fit=TRUE)
```

<img src="man/figures/README-BG_word_time_plot-1.png" width="100%" />

## Datasets

In the `menzerath` package a number of datasets are included in the form
of tibbles that can easily be loaded and manipulated to serve as
examples or test data. There are some classic datasets from Altmann 1980
and some more recent ones from Torre et al. 2019

### Datasets in package

  - `morpheme_syllable`: Dataset from Altmann 1980 linking morpheme size
    and syllable size.
  - `word_syllable_phoneme`: Dataset from Altman 1980 on syllable length
    in English words.
  - `word_syllable_time`: Dataset from Altman 1980 on syllable length in
    Bachka-German words.
  - `BG_word_characters`: Dataset from Torre et al. 2019 linking breadth
    group size and average word size (in number of characters).
  - `BG_word_phonemes`: Dataset from Torre et al. 2019 linking breadth
    group and average word size (in phonemes).
  - `BG_word_time`: Dataset from Torre et al. 2019 linking breadth group
    and word size (in seconds).

Further documentation and details about each dataset can be gained with
the `help` command, e.g:

``` r
help(morpheme_syllable)
```

## References

Altmann, G., 1980. Prolegomena to Menzerath’s law. Glottometrika, 2(2),
pp.1-10.

Torre Iván G., Luque Bartolo, Lacasa Lucas, Kello Christopher T. and
Hernández-Fernández Antoni 2019 On the physical origin of linguistic
laws and lognormality in speech R. Soc. open sci.6191023
<http://doi.org/10.1098/rsos.191023>

## Contributing

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.
