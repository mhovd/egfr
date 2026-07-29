# Changelog

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
