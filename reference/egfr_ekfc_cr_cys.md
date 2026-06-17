# EKFC combined creatinine + cystatin C eGFR (2023)

Arithmetic mean of the EKFC creatinine
([`egfr_ekfc_cr()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cr.md))
and EKFC cystatin C
([`egfr_ekfc_cys()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cys.md))
estimates.

## Usage

``` r
egfr_ekfc_cr_cys(
  creatinine,
  cystatin,
  age,
  sex,
  creatinine_units = "mg/dl",
  label_sex_male = "male",
  label_sex_female = "female"
)
```

## Arguments

- creatinine:

  Numeric vector of serum creatinine.

- cystatin:

  Numeric vector of serum cystatin C in mg/L.

- age:

  Numeric vector of age in years.

- sex:

  Vector of sex labels (see `label_sex_male`/`label_sex_female`).

- creatinine_units:

  Units of `creatinine`: `"mg/dl"` (default) or `"umol/l"`.

- label_sex_male, label_sex_female:

  Values in `sex` that denote male and female records. Defaults to
  `"male"`/`"female"`.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## References

Pottel H, Bjork J, Rule AD, et al. N Engl J Med. 2023;388(4):333-343.
[doi:10.1056/NEJMoa2203769](https://doi.org/10.1056/NEJMoa2203769)

## Examples

``` r
egfr_ekfc_cr_cys(creatinine = 1.0, cystatin = 0.9, age = 50, sex = "female")
#> [1] 76.67268
```
