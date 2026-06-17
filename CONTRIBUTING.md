# Contributing to egfr

Thanks for taking the time to contribute! The following is a short set
of guidelines for contributing to **egfr**.

## Reporting bugs

- Search the [existing issues](https://github.com/mhovd/egfr/issues)
  first to avoid duplicates.
- Open a new issue with a minimal [reprex](https://reprex.tidyverse.org)
  (a small, self-contained, reproducible example). For an eGFR equation,
  please include the inputs, the value you got, and the value you
  expected (with a reference where possible).

## Pull requests

1.  Fork the repository and create a branch off `main`.
2.  Make your change. Keep the scope focused.
3.  Add or update tests in `tests/testthat/` and run `devtools::test()`.
4.  Run `devtools::document()` if you changed any roxygen comments.
5.  Ensure `R CMD check` passes cleanly (`devtools::check()`).
6.  Open a pull request describing the change and linking any related
    issue.

## Code style

- Follow the [tidyverse style guide](https://style.tidyverse.org).
- Code is linted with [lintr](https://lintr.r-lib.org); see `.lintr` for
  the configuration used in CI.

## Scientific accuracy

Because this package implements published clinical equations, any new
equation or change to an existing one **must** cite a peer-reviewed
source and include tests that reproduce published reference values.

Please note that this project is released with a [Contributor Code of
Conduct](https://mhovd.github.io/egfr/CODE_OF_CONDUCT.md). By
participating you agree to abide by its terms.
