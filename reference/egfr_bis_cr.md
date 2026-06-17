# Berlin Initiative Study (BIS1) creatinine eGFR (2012)

Estimates GFR from serum creatinine using the BIS1 equation (Schaeffner
et al., 2012), developed in an elderly (\>= 70 years) German cohort.

## Usage

``` r
egfr_bis_cr(
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

Schaeffner ES, Ebert N, Delanaye P, et al. Two novel equations to
estimate kidney function in persons aged 70 years or older. Ann Intern
Med. 2012;157(7):471-481.
[doi:10.7326/0003-4819-157-7-201210020-00003](https://doi.org/10.7326/0003-4819-157-7-201210020-00003)

## Examples

``` r
egfr_bis_cr(creatinine = 1.1, age = 75, sex = "female")
#> [1] 46.65529
```
