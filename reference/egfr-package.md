# egfr: Estimated Glomerular Filtration Rate Calculators

A vectorised toolkit implementing 19 validated equations for estimating
glomerular filtration rate (eGFR) and creatinine clearance from serum
creatinine, cystatin C, or both, plus helpers for body surface area,
KDIGO CKD staging, and unit conversion.

## Details

All `egfr_*()` functions are fully vectorised: every numeric argument
may be a scalar or a vector. Scalars are recycled against the longest
vector. Results are returned unrounded (full precision) in
mL/min/1.73m^2, except
[`egfr_cockcroft_gault()`](https://mhovd.github.io/egfr/reference/egfr_cockcroft_gault.md)
which returns creatinine clearance in mL/min.

## See also

Useful links:

- <https://github.com/mhovd/egfr>

- <https://mhovd.github.io/egfr/>

- Report bugs at <https://github.com/mhovd/egfr/issues>

## Author

**Maintainer**: Markus Hovd <markus@hovd.io>
([ORCID](https://orcid.org/0000-0002-6077-0934)) \[copyright holder\]

Authors:

- Markus Hovd <markus@hovd.io>
  ([ORCID](https://orcid.org/0000-0002-6077-0934)) \[copyright holder\]
