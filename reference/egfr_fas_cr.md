# Full Age Spectrum (FAS) creatinine eGFR

Estimates GFR from serum creatinine using the Full Age Spectrum equation
(Pottel et al., 2016). Uses adult reference Q values (male 0.90, female
0.70 mg/dL) across all ages.

## Usage

``` r
egfr_fas_cr(
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

Pottel H, Hoste L, Dubourg L, et al. An estimated glomerular filtration
rate equation for the full age spectrum. Nephrol Dial Transplant.
2016;31(5):798-806.
[doi:10.1093/ndt/gfv454](https://doi.org/10.1093/ndt/gfv454)

## Examples

``` r
egfr_fas_cr(creatinine = 1.0, age = 50, sex = "female")
#> [1] 66.56826
```
