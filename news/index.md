# Changelog

## egfr 2.0.0

This release corrects two equations that returned clinically wrong
values for paediatric patients, and removes one function that
implemented an experimental equation.

### Breaking changes

- [`egfr_ekfc_cr()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cr.md)
  now uses the correct reference Q specification published in Pottel et
  al. (2021).
- [`egfr_fas_cr()`](https://mhovd.github.io/egfr/reference/egfr_fas_cr.md)
  now applies the published age- and sex-specific Q values from Table 1
  of Pottel et al. (2016). Previous versions used the adult Q (0.90 /
  0.70 mg/dL) at every age, which overestimated eGFR by up to ~246% in
  infants and ~76% in a 10-year-old. Q is shared between boys and girls
  for ages 1-14, becomes sex-specific for ages 15-19, and reaches the
  adult values from age 20. Adult results (age \>= 20) are unchanged.
- `egfr_ckid_u25_cr_extended()` has been **removed**. Its kappa
  extension to age 30 (`0.995^(age - 25)`) was an experimental feature.
  Use
  [`egfr_ckid_u25_cr()`](https://mhovd.github.io/egfr/reference/egfr_ckid_u25_cr.md)
  within its validated range.

### Bug fixes

- [`ckd_stage()`](https://mhovd.github.io/egfr/reference/ckd_stage.md)
  no longer errors on a logical `NA` (e.g. `ckd_stage(NA)`) and returns
  `NA` as expected.

### Documentation

- Corrected the citation for
  [`egfr_neonatal()`](https://mhovd.github.io/egfr/reference/egfr_neonatal.md).
- [`egfr_ckdepi_cys_2021()`](https://mhovd.github.io/egfr/reference/egfr_ckdepi_cys_2021.md)
  now documents its use of the four-decimal age factor `0.9962` from
  Table 2 of Inker et al. (2021), and the resulting ~1.2-1.6% difference
  at ages 60-80 relative to calculators that use the rounded `0.996`
  printed in the 2012 paper and by the National Kidney Foundation.
- Added published validity ranges to the documentation of
  [`egfr_ekfc_cr()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cr.md)
  (ages 2-90; the previous claim of 2-120 was incorrect),
  [`egfr_ekfc_cys()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cys.md),
  [`egfr_fas_cr()`](https://mhovd.github.io/egfr/reference/egfr_fas_cr.md),
  [`egfr_bis_cr()`](https://mhovd.github.io/egfr/reference/egfr_bis_cr.md)
  (age \>= 70),
  [`egfr_lund_malmo()`](https://mhovd.github.io/egfr/reference/egfr_lund_malmo.md)
  (adults),
  [`egfr_schwartz()`](https://mhovd.github.io/egfr/reference/egfr_schwartz.md)
  (ages 1-16),
  [`egfr_ckid_u25_cr()`](https://mhovd.github.io/egfr/reference/egfr_ckid_u25_cr.md)
  (ages 1-25),
  [`egfr_capa()`](https://mhovd.github.io/egfr/reference/egfr_capa.md),
  and
  [`egfr_neonatal()`](https://mhovd.github.io/egfr/reference/egfr_neonatal.md)
  (term-born, postnatal days 0-28).
- [`egfr_cockcroft_gault()`](https://mhovd.github.io/egfr/reference/egfr_cockcroft_gault.md)
  now documents that it returns creatinine clearance (which
  overestimates GFR through tubular secretion) and was derived using
  non-standardised Jaffe creatinine.

### Testing

- Added `test-reference-values.R`, which validates every equation
  against coefficients written out directly from the original
  publications, including the EKFC and FAS reference Q tables and
  continuity checks at age knots. The previous suite largely re-derived
  values using the package’s own internals and could not detect a
  mis-transcribed equation.

## egfr 1.1.2

- The `CITATION` file now reports the installed package version
  dynamically instead of a hardcoded value.
- Added the maintainer’s ORCID and Zenodo archive metadata
  (`.zenodo.json`) so the package can be cited via a DOI.

## egfr 1.1.0

- Fixed the Full Age Spectrum (FAS) creatinine equation
  ([`egfr_fas_cr()`](https://mhovd.github.io/egfr/reference/egfr_fas_cr.md))
  for ages over 40: the creatinine-ratio exponent is now correctly -1 (a
  plain reciprocal) as published in Pottel et al. (2016), rather than
  -0.88. This changes returned eGFR values for patients older than 40.
- [`egfr_ekfc_cr()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cr.md),
  [`egfr_ekfc_cys()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cys.md),
  and
  [`egfr_ekfc_cr_cys()`](https://mhovd.github.io/egfr/reference/egfr_ekfc_cr_cys.md)
  gain an optional `q` argument (`q_cr` / `q_cys` for the combined
  equation) to supply a population-, assay-, or individual-specific
  reference Q value. The default (`NULL`) continues to use the built-in
  EKFC reference Q, so existing code is unaffected.

## egfr 1.0.0

## egfr 0.1.0

- Initial release.
- 20 eGFR / creatinine-clearance equations: CKD-EPI 2021 (creatinine,
  cystatin C, combined), CKD-EPI 2009, CKD-EPI 2012 cystatin C, MDRD,
  Cockcroft-Gault, EKFC (creatinine, cystatin C, combined), FAS,
  Lund-Malmoe, Berlin Initiative Study, Schwartz bedside, CKiD U25
  (creatinine, cystatin C, combined, extended), CAPA, and neonatal eGFR.
- Helpers: [`bsa()`](https://mhovd.github.io/egfr/reference/bsa.md),
  [`ckd_stage()`](https://mhovd.github.io/egfr/reference/ckd_stage.md),
  and creatinine unit conversion.
