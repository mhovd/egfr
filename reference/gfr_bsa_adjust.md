# Normalise or de-normalise GFR using body surface area

Converts between absolute creatinine clearance (mL/min) and
BSA-normalised GFR (mL/min/1.73m^2).

## Usage

``` r
gfr_bsa_adjust(gfr, bsa, to = c("normalized", "absolute"))
```

## Arguments

- gfr:

  Numeric vector of GFR values.

- bsa:

  Numeric vector of body surface area in m^2 (e.g. from
  [`bsa()`](https://mhovd.github.io/egfr/reference/bsa.md)).

- to:

  Either `"normalized"` (absolute -\> per 1.73m^2, the default) or
  `"absolute"` (per 1.73m^2 -\> absolute).

## Value

Numeric vector of converted GFR.

## Examples

``` r
gfr_bsa_adjust(100, bsa = 2.0, to = "normalized")
#> [1] 86.5
gfr_bsa_adjust(90, bsa = 2.0, to = "absolute")
#> [1] 104.0462
```
