# EKFC cystatin C eGFR (2023)

Estimates GFR from serum cystatin C using the sex- and race-free EKFC
cystatin C equation (Pottel et al., 2023).

## Usage

``` r
egfr_ekfc_cys(cystatin, age)
```

## Arguments

- cystatin:

  Numeric vector of serum cystatin C in mg/L.

- age:

  Numeric vector of age in years.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## References

Pottel H, Bjork J, Rule AD, et al. Cystatin C-based equation to estimate
GFR without the inclusion of race and sex. N Engl J Med.
2023;388(4):333-343.
[doi:10.1056/NEJMoa2203769](https://doi.org/10.1056/NEJMoa2203769)

## Examples

``` r
egfr_ekfc_cys(cystatin = 0.9, age = 50)
#> [1] 88.54123
```
