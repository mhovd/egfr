# Neonatal creatinine eGFR (2022)

Estimates GFR in term-born neonates using the updated Schwartz-type
coefficient of Smeets et al. (2022). Requires IDMS-standardised
creatinine.

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

## Validity

Derived for **term-born** neonates (gestational age \>= 37 weeks) over
postnatal days 0-28. The authors explicitly note it is not intended for
preterm neonates, and that validation in a large neonatal cohort is
still required.

## References

Smeets NJL, IntHout J, van der Burgh MJP, Schwartz GJ, Schreuder MF, de
Wildt SN. Maturation of GFR in term-born neonates: an individual
participant data meta-analysis. J Am Soc Nephrol. 2022;33(7):1277-1292.
[doi:10.1681/ASN.2021101326](https://doi.org/10.1681/ASN.2021101326)

## Examples

``` r
egfr_neonatal(creatinine = 0.5, height = 50)
#> [1] 31
```
