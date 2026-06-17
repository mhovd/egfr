# CKD-EPI 2021 creatinine eGFR (race-free)

Estimates GFR from serum creatinine using the race-free CKD-EPI 2021
creatinine equation (Inker et al., 2021). This is the equation
recommended for adults (\>= 18 years) by current US guidelines.

## Usage

``` r
egfr_ckdepi_cr_2021(
  creatinine,
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

Inker LA, Eneanya ND, Coresh J, et al. New creatinine- and cystatin
C-based equations to estimate GFR without race. N Engl J Med.
2021;385(19):1737-1749.
[doi:10.1056/NEJMoa2102953](https://doi.org/10.1056/NEJMoa2102953)

## Examples

``` r
egfr_ckdepi_cr_2021(creatinine = 1.0, age = 50, sex = "female")
#> [1] 68.6335
egfr_ckdepi_cr_2021(c(0.8, 1.2), c(40, 65), c("female", "male"))
#> [1] 95.46369 67.11141
```
