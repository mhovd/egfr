# CKiD U25 extended creatinine eGFR (to age 30)

Research extension of
[`egfr_ckid_u25_cr()`](https://mhovd.github.io/egfr/reference/egfr_ckid_u25_cr.md)
with kappa values that continue to age 30.

## Usage

``` r
egfr_ckid_u25_cr_extended(
  creatinine,
  age,
  sex,
  height,
  creatinine_units = "mg/dl",
  height_units = "cm",
  label_sex_male = "male",
  label_sex_female = "female"
)
```

## Arguments

- creatinine:

  Numeric vector of serum creatinine.

- age:

  Numeric vector of age in years.

- sex:

  Vector of sex labels (see `label_sex_male`/`label_sex_female`).

- height:

  Numeric vector of height.

- creatinine_units:

  Units of `creatinine`: `"mg/dl"` (default) or `"umol/l"`.

- height_units:

  Units of `height`: `"cm"` (default) or `"m"`.

- label_sex_male, label_sex_female:

  Values in `sex` that denote male and female records. Defaults to
  `"male"`/`"female"`.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## References

Pierce CB, et al. Kidney Int. 2021;99(4):948-956.
[doi:10.1016/j.kint.2020.10.047](https://doi.org/10.1016/j.kint.2020.10.047)

## Examples

``` r
egfr_ckid_u25_cr_extended(creatinine = 1.0, age = 28, sex = "female",
                          height = 165)
#> [1] 67.29046
```
