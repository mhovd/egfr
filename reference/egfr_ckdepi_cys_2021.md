# CKD-EPI 2021 cystatin C eGFR (race-free)

Estimates GFR from serum cystatin C using the race-free CKD-EPI 2021
cystatin C equation (Inker et al., 2021). The identical formula was
first published in 2012; see
[`egfr_ckdepi_cys_2012()`](https://mhovd.github.io/egfr/reference/egfr_ckdepi_cys_2012.md).

## Usage

``` r
egfr_ckdepi_cys_2021(
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

Inker LA, Eneanya ND, Coresh J, et al. N Engl J Med.
2021;385(19):1737-1749.
[doi:10.1056/NEJMoa2102953](https://doi.org/10.1056/NEJMoa2102953)

## Examples

``` r
egfr_ckdepi_cys_2021(cystatin = 0.9, age = 55, sex = "male")
#> [1] 92.25303
```
