# Schwartz bedside paediatric eGFR (2009)

Estimates GFR in children using the bedside Schwartz equation (Schwartz
et al., 2009). Requires IDMS-standardised creatinine.

## Usage

``` r
egfr_schwartz(
  creatinine,
  height,
  creatinine_units = "mg/dl",
  height_units = "cm"
)
```

## Arguments

- creatinine:

  Numeric vector of serum creatinine.

- height:

  Numeric vector of height.

- creatinine_units:

  Units of `creatinine`: `"mg/dl"` (default) or `"umol/l"`.

- height_units:

  Units of `height`: `"cm"` (default) or `"m"`.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## Validity

Derived in 349 children with CKD aged 1-16 years. Requires
IDMS-standardised creatinine.

## References

Schwartz GJ, Munoz A, Schneider MF, et al. New equations to estimate GFR
in children with CKD. J Am Soc Nephrol. 2009;20(3):629-637.
[doi:10.1681/ASN.2008030287](https://doi.org/10.1681/ASN.2008030287)

## Examples

``` r
egfr_schwartz(creatinine = 0.5, height = 120)
#> [1] 99.12
```
