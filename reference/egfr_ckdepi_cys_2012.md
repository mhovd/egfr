# CKD-EPI 2012 cystatin C eGFR

Estimates GFR from serum cystatin C using the CKD-EPI 2012 cystatin C
equation (Inker et al., 2012). The formula is identical to the race-free
2021 cystatin C equation and is retained for backward compatibility.

## Usage

``` r
egfr_ckdepi_cys_2012(
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

Inker LA, Schmid CH, Tighiouart H, et al. Estimating GFR from serum
creatinine and cystatin C. N Engl J Med. 2012;367(1):20-29.
[doi:10.1056/NEJMoa1114248](https://doi.org/10.1056/NEJMoa1114248)

## Examples

``` r
egfr_ckdepi_cys_2012(cystatin = 0.9, age = 55, sex = "male")
#> [1] 92.25303
```
