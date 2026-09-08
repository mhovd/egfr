# Cockcroft-Gault creatinine clearance

Estimates creatinine clearance (not BSA-normalised eGFR) using the
Cockcroft-Gault equation (Cockcroft & Gault, 1976). Commonly used for
drug dosing.

## Usage

``` r
egfr_cockcroft_gault(
  creatinine,
  age,
  sex,
  weight,
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

- weight:

  Numeric vector of body weight in kilograms.

- creatinine_units:

  Units of `creatinine`: `"mg/dl"` (default) or `"umol/l"`.

- label_sex_male, label_sex_female:

  Values in `sex` that denote male and female records. Defaults to
  `"male"`/`"female"`.

## Value

Numeric vector of creatinine clearance in mL/min.

## Interpretation

This equation returns creatinine clearance in mL/min, which is **not**
normalised to 1.73 m^2 and is not directly comparable with the other
`egfr_*()` functions. Creatinine clearance overestimates true GFR
because creatinine is secreted by the renal tubules. The equation was
derived in 249 hospitalised adults aged 18-92, all male, using
non-standardised (Jaffe) creatinine; it is therefore not IDMS-traceable
and differs systematically from modern eGFR equations. The 15% downward
adjustment for women (the 0.85 factor) is stated in the original 1976
publication, though it was asserted rather than derived, as the
derivation cohort was male.

## References

Cockcroft DW, Gault MH. Prediction of creatinine clearance from serum
creatinine. Nephron. 1976;16(1):31-41.
[doi:10.1159/000180580](https://doi.org/10.1159/000180580)

## Examples

``` r
egfr_cockcroft_gault(creatinine = 1.0, age = 50, sex = "male", weight = 80)
#> [1] 100
```
