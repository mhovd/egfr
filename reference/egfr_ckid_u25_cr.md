# CKiD U25 creatinine eGFR

Estimates GFR in children and young adults (ages 1-25) using the CKiD
U25 creatinine equation (Pierce et al., 2021). This is the first-choice
paediatric equation.

## Usage

``` r
egfr_ckid_u25_cr(
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

Pierce CB, Munoz A, Ng DK, Warady BA, Furth SL, Schwartz GJ. Age- and
sex-dependent clinical equations to estimate GFR in children and young
adults with CKD. Kidney Int. 2021;99(4):948-956.
[doi:10.1016/j.kint.2020.10.047](https://doi.org/10.1016/j.kint.2020.10.047)

## Examples

``` r
egfr_ckid_u25_cr(creatinine = 0.6, age = 10, sex = "male", height = 140)
#> [1] 89.56129
```
