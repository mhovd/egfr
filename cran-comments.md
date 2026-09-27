## Submission

This is an update (2.0.0) of an existing CRAN package. It corrects two
equations (`egfr_ekfc_cr()`, `egfr_fas_cr()`) that returned clinically wrong
values for paediatric patients, and removes one function that implemented an
experimental, unpublished equation. See NEWS.md for details.

## R CMD check results

0 errors | 0 warnings | 0 notes

A NOTE about an outdated HTML Tidy binary appears on local macOS checks only.
It reflects the local toolchain rather than the package, and does not occur on
the CRAN build machines.

## Test environments

- local macOS, R 4.6.1
- GitHub Actions (ubuntu-latest): R-devel, R-release, R-oldrel-1
- GitHub Actions (macOS-latest, windows-latest): R-release

## Downstream dependencies

There are currently no downstream dependencies for this package.
