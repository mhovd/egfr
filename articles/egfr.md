# Getting started with egfr

``` r

library(egfr)
```

## Overview

**egfr** provides a vectorised set of equations for estimating
glomerular filtration rate (eGFR) and creatinine clearance from serum
creatinine, cystatin C, or both. This vignette shows the most common
workflows.

> These equations are screening tools and are **not** a substitute for
> measured GFR or clinical judgement.

## A single estimate

The CKD-EPI 2021 creatinine equation is the recommended race-free
default for adults:

``` r

egfr_ckdepi_cr_2021(creatinine = 1.0, age = 50, sex = "female")
#> [1] 68.6335
```

## Vectorisation

Every argument is vectorised, so you can score a whole cohort in one
call:

``` r

egfr_ckdepi_cr_2021(
  creatinine = c(0.8, 1.2, 1.5),
  age        = c(40, 65, 72),
  sex        = c("female", "male", "female")
)
#> [1] 95.46369 67.11141 36.79633
```

## Working with units

Creatinine defaults to mg/dL. Pass `creatinine_units = "umol/l"` to
supply SI units instead:

``` r

egfr_ckdepi_cr_2021(88.4, 50, "female", creatinine_units = "umol/l")
#> [1] 68.6335
```

You can also convert explicitly:

``` r

convert_creatinine(88.4, from = "umol/l", to = "mg/dl")
#> [1] 1
```

## Cystatin C and combined equations

If you have cystatin C, or both biomarkers, use the matching function:

``` r

egfr_ckdepi_cys_2021(cystatin = 1.0, age = 50, sex = "female")
#> [1] 76.18999
egfr_ckdepi_cr_cys_2021(creatinine = 1.0, cystatin = 1.0, age = 50, sex = "female")
#> [1] 74.03625
```

## Staging the result

Classify an eGFR value into a KDIGO GFR category:

``` r

result <- egfr_ckdepi_cr_2021(1.0, 50, "female")
ckd_stage(result)
#> [1] "G2"
```

## Body surface area adjustment

Most equations return values normalised to 1.73 m^2. To obtain an
absolute (de-indexed) GFR, compute the body surface area and adjust:

``` r

area <- bsa(weight = 70, height = 175)
gfr_bsa_adjust(result, bsa = area, to = "absolute")
#> [1] 73.32053
```

## Where to go next

See the [function reference](https://mhovd.github.io/egfr/reference/)
for the full list of adult, paediatric, and neonatal equations and
helpers.
