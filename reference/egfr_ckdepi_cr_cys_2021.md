# CKD-EPI 2021 combined creatinine + cystatin C eGFR (race-free)

Estimates GFR using both serum creatinine and cystatin C with the
race-free CKD-EPI 2021 combined equation (Inker et al., 2021). This is
the most accurate of the CKD-EPI equations when both biomarkers are
available.

## Usage

``` r
egfr_ckdepi_cr_cys_2021(
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

Inker LA, Eneanya ND, Coresh J, et al. N Engl J Med.
2021;385(19):1737-1749.
[doi:10.1056/NEJMoa2102953](https://doi.org/10.1056/NEJMoa2102953)

## Examples

``` r
egfr_ckdepi_cr_cys_2021(creatinine = 1.0, cystatin = 0.9,
                        age = 50, sex = "female")
#> [1] 80.3607
```
