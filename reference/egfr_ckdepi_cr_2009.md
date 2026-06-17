# CKD-EPI 2009 creatinine eGFR (with race coefficient)

Estimates GFR from serum creatinine using the original CKD-EPI 2009
creatinine equation (Levey et al., 2009), which includes a race
coefficient. Retained for historical comparison; the race-free
[`egfr_ckdepi_cr_2021()`](https://mhovd.github.io/egfr/reference/egfr_ckdepi_cr_2021.md)
is now recommended.

## Usage

``` r
egfr_ckdepi_cr_2009(
  creatinine,
  age,
  sex,
  ethnicity = NULL,
  creatinine_units = "mg/dl",
  label_sex_male = "male",
  label_sex_female = "female",
  label_afroamerican = c("black", "Black")
)
```

## Arguments

- creatinine:

  Numeric vector of serum creatinine.

- age:

  Numeric vector of age in years.

- sex:

  Vector of sex labels (see `label_sex_male`/`label_sex_female`).

- ethnicity:

  Optional vector of ethnicity labels. Records matching
  `label_afroamerican` receive the Black race coefficient (1.159); all
  others receive 1.0. If `NULL` (default) no race coefficient is
  applied.

- creatinine_units:

  Units of `creatinine`: `"mg/dl"` (default) or `"umol/l"`.

- label_sex_male, label_sex_female:

  Values in `sex` that denote male and female records. Defaults to
  `"male"`/`"female"`.

- label_afroamerican:

  Values in `ethnicity` denoting Black/African American race. Defaults
  to `c("black", "Black")`.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## References

Levey AS, Stevens LA, Schmid CH, et al. A new equation to estimate
glomerular filtration rate. Ann Intern Med. 2009;150(9):604-612.
[doi:10.7326/0003-4819-150-9-200905050-00006](https://doi.org/10.7326/0003-4819-150-9-200905050-00006)

## Examples

``` r
egfr_ckdepi_cr_2009(creatinine = 1.0, age = 50, sex = "female")
#> [1] 65.63762
egfr_ckdepi_cr_2009(1.0, 50, "female",
  ethnicity = "black", label_afroamerican = "black"
)
#> [1] 76.07401
```
