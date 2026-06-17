# EKFC creatinine eGFR (2021)

Estimates GFR from serum creatinine using the European Kidney Function
Consortium (EKFC) creatinine equation (Pottel et al., 2021). Valid
across the full age spectrum (2-120 years).

## Usage

``` r
egfr_ekfc_cr(
  creatinine,
  age,
  sex,
  creatinine_units = "mg/dl",
  label_sex_male = "male",
  label_sex_female = "female",
  q = NULL
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

- q:

  Optional numeric vector of the reference creatinine Q value (median
  creatinine for the age/sex, in mg/dL). When `NULL` (the default) the
  built-in EKFC reference Q is used; supply a value to use a
  population-, assay-, or individual-specific Q. Recycled to the length
  of the other inputs.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## References

Pottel H, Bjork J, Courbebaisse M, et al. Development and validation of
a modified full age spectrum creatinine-based equation to estimate
glomerular filtration rate. Ann Intern Med. 2021;174(2):183-191.
[doi:10.7326/M20-4366](https://doi.org/10.7326/M20-4366)

## Examples

``` r
egfr_ekfc_cr(creatinine = 1.0, age = 50, sex = "female")
#> [1] 64.80412
egfr_ekfc_cr(0.5, 8, "male")
#> [1] 76.30799
egfr_ekfc_cr(1.0, 50, "female", q = 0.72)
#> [1] 66.904
```
