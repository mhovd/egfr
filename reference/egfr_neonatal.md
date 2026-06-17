# Neonatal creatinine eGFR (2022)

Estimates GFR in term-born neonates using the equation of Smeets et al.
(2022). Requires IDMS-standardised creatinine.

## Usage

``` r
egfr_neonatal(
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

## References

Smeets NJL, IntHout J, van der Burgh MJP, et al. SCr- and cystatin
C-based equations to estimate GFR in term-born neonates. J Am Soc
Nephrol. 2022;33(7):1277-1292.
[doi:10.1681/ASN.2021111453](https://doi.org/10.1681/ASN.2021111453)

## Examples

``` r
egfr_neonatal(creatinine = 0.5, height = 50)
#> [1] 31
```
