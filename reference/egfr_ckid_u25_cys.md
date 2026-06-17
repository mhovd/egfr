# CKiD U25 cystatin C eGFR

Estimates GFR in children and young adults (ages 1-25) using the CKiD
U25 cystatin C equation (Pierce et al., 2021).

## Usage

``` r
egfr_ckid_u25_cys(
  cystatin,
  age,
  sex,
  label_sex_male = "male",
  label_sex_female = "female"
)
```

## Arguments

- cystatin:

  Numeric vector of serum cystatin C in mg/L.

- age:

  Numeric vector of age in years.

- sex:

  Vector of sex labels (see `label_sex_male`/`label_sex_female`).

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
egfr_ckid_u25_cys(cystatin = 0.8, age = 10, sex = "male")
#> [1] 103.1979
```
