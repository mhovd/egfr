# MDRD 4-variable eGFR (IDMS-standardised)

Estimates GFR from serum creatinine using the IDMS-traceable 4-variable
MDRD Study equation (Levey et al., 2006). Historical; superseded by
CKD-EPI for clinical use.

## Usage

``` r
egfr_mdrd(
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

Levey AS, Coresh J, Greene T, et al. Using standardized serum creatinine
values in the MDRD study equation. Ann Intern Med. 2006;145(4):247-254.
[doi:10.7326/0003-4819-145-4-200608150-00004](https://doi.org/10.7326/0003-4819-145-4-200608150-00004)

## Examples

``` r
egfr_mdrd(creatinine = 1.2, age = 60, sex = "male")
#> [1] 61.75871
```
