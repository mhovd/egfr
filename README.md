# egfrcalc

<!-- badges: start -->
<!-- badges: end -->

**egfrcalc** is a vectorised R toolkit for estimating glomerular filtration
rate (eGFR) and creatinine clearance from serum creatinine, cystatin C, or
both. It implements 20 validated adult, paediatric, and neonatal equations,
plus helpers for body surface area, KDIGO CKD staging, and unit conversion.

The package is inspired by the
[`kidney.epi`](https://cran.r-project.org/package=kidney.epi) package and was
ported from the equation set used by [eGFR.app](https://github.com/mhovd/egfr-app).

> These equations are screening tools and are **not** a substitute for measured
> GFR or clinical judgement.

## Installation

```r
# install.packages("remotes")
remotes::install_github("mhovd/egfrcalc")
```

## Quick start

```r
library(egfrcalc)

# CKD-EPI 2021 creatinine (race-free) — recommended for adults
egfr_ckdepi_cr_2021(creatinine = 1.0, age = 50, sex = "female")
#> 68.6

# Fully vectorised: pass vectors for any argument
egfr_ckdepi_cr_2021(
  creatinine = c(0.8, 1.2, 1.5),
  age        = c(40, 65, 72),
  sex        = c("female", "male", "female")
)

# Units: supply creatinine in umol/L instead of mg/dL
egfr_ckdepi_cr_2021(88.4, 50, "female", creatinine_units = "umol/l")

# Classify the result into a KDIGO stage
ckd_stage(egfr_ckdepi_cr_2021(1.0, 50, "female"))
#> "G2"
```

## Available equations

### Adult

| Function | Equation | Biomarker |
|---|---|---|
| `egfr_ckdepi_cr_2021()`     | CKD-EPI 2021 (race-free)     | creatinine |
| `egfr_ckdepi_cys_2021()`    | CKD-EPI 2021 (race-free)     | cystatin C |
| `egfr_ckdepi_cr_cys_2021()` | CKD-EPI 2021 (race-free)     | both |
| `egfr_ckdepi_cr_2009()`     | CKD-EPI 2009 (with race)     | creatinine |
| `egfr_ckdepi_cys_2012()`    | CKD-EPI 2012                 | cystatin C |
| `egfr_mdrd()`               | MDRD 4-variable (IDMS)       | creatinine |
| `egfr_cockcroft_gault()`    | Cockcroft-Gault (CrCl)       | creatinine |
| `egfr_ekfc_cr()`            | EKFC 2021                    | creatinine |
| `egfr_ekfc_cys()`           | EKFC 2023                    | cystatin C |
| `egfr_ekfc_cr_cys()`        | EKFC 2023                    | both |
| `egfr_fas_cr()`             | Full Age Spectrum 2016       | creatinine |
| `egfr_lund_malmo()`         | Lund-Malmoe Revised 2011     | creatinine |
| `egfr_bis_cr()`             | Berlin Initiative Study 2012 | creatinine |

### Paediatric & neonatal

| Function | Equation | Biomarker |
|---|---|---|
| `egfr_schwartz()`             | Schwartz bedside 2009    | creatinine |
| `egfr_ckid_u25_cr()`          | CKiD U25 2021            | creatinine |
| `egfr_ckid_u25_cys()`         | CKiD U25 2021            | cystatin C |
| `egfr_ckid_u25_cr_cys()`      | CKiD U25 2021            | both |
| `egfr_ckid_u25_cr_extended()` | CKiD U25 extended (to 30)| creatinine |
| `egfr_capa()`                 | CAPA 2014                | cystatin C |
| `egfr_neonatal()`             | Neonatal 2022            | creatinine |

### Helpers

| Function | Purpose |
|---|---|
| `bsa()`               | Body surface area (Du Bois, Haycock, Mosteller) |
| `gfr_bsa_adjust()`    | Convert between absolute and BSA-normalised GFR |
| `ckd_stage()`         | KDIGO GFR category (G1-G5) |
| `convert_creatinine()`| mg/dL <-> umol/L |

## Conventions

* All `egfr_*()` functions return **unrounded** values in mL/min/1.73m^2,
  except `egfr_cockcroft_gault()`, which returns creatinine clearance in mL/min.
* Creatinine defaults to **mg/dL**; pass `creatinine_units = "umol/l"` to use
  SI units. Height defaults to **cm**.
* Sex labels default to `"male"`/`"female"` and can be customised via
  `label_sex_male` / `label_sex_female`.

## License

MIT (c) 2026 Markus Hovd.
