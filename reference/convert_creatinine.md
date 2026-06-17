# Convert serum creatinine between mg/dL and umol/L

Convert serum creatinine between mg/dL and umol/L

## Usage

``` r
convert_creatinine(creatinine, from = "mg/dl", to = "umol/l")
```

## Arguments

- creatinine:

  Numeric vector of serum creatinine.

- from, to:

  Units, either `"mg/dl"` or `"umol/l"`.

## Value

Numeric vector of converted creatinine.

## Examples

``` r
convert_creatinine(88.4, from = "umol/l", to = "mg/dl")
#> [1] 1
convert_creatinine(1.0, from = "mg/dl", to = "umol/l")
#> [1] 88.4
```
