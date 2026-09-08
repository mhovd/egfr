# Lund-Malmoe Revised creatinine eGFR (2011)

Estimates GFR from serum creatinine using the revised Lund-Malmoe
equation (Bjork et al., 2011). Piecewise-linear in plasma creatinine
(umol/L) with sex-specific knots.

## Usage

``` r
egfr_lund_malmo(
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

## Validity

Derived in 850 Swedish adults aged 18-95 years. Not validated in
children; a separate paediatric adaptation (LMR18) was published in
2020.

## References

Bjork J, Grubb A, Sterner G, Nyman U. Revised equations for estimating
glomerular filtration rate based on the Lund-Malmo Study cohort. Scand J
Clin Lab Invest. 2011;71(3):232-239.
[doi:10.3109/00365513.2011.557086](https://doi.org/10.3109/00365513.2011.557086)

## Examples

``` r
egfr_lund_malmo(creatinine = 1.0, age = 50, sex = "female")
#> [1] 64.63953
```
