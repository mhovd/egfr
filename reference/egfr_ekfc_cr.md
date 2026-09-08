# EKFC creatinine eGFR (2021)

Estimates GFR from serum creatinine using the European Kidney Function
Consortium (EKFC) creatinine equation (Pottel et al., 2021).

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

## Reference Q

The default Q follows the published EKFC specification. For ages 2-25
years inclusive Q is a sex-specific polynomial in age (given by the
authors on the micromol/L scale and converted here to mg/dL):

\$\$\ln(Q\_{male}) = 3.200 + 0.259 a - 0.543 \ln(a) - 0.00763 a^2 +
0.0000790 a^3\$\$ \$\$\ln(Q\_{female}) = 3.080 + 0.177 a - 0.223
\ln(a) - 0.00596 a^2 + 0.0000686 a^3\$\$

Above age 25 Q is constant at the adult values of 0.90 mg/dL (80
micromol/L) for males and 0.70 mg/dL (62 micromol/L) for females. The
polynomial and the adult plateau differ by roughly 1% at the age-25
knot; this step is part of the published specification and is preserved
deliberately.

Population-specific adult Q values (e.g. 1.02 / 0.74 mg/dL for Black
Europeans) may be supplied via `q`.

## Validity

Developed and validated across ages 2-90 years and serum creatinine
40-490 micromol/L (0.45-5.54 mg/dL). Values outside this range are
extrapolations.

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
#> [1] 96.498
egfr_ekfc_cr(1.0, 50, "female", q = 0.72)
#> [1] 66.904
```
