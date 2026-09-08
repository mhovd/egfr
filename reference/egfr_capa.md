# CAPA paediatric cystatin C eGFR (2014)

Estimates GFR from serum cystatin C using the Caucasian, Asian,
paediatric, and adult (CAPA) equation (Grubb et al., 2014).

## Usage

``` r
egfr_capa(cystatin, age)
```

## Arguments

- cystatin:

  Numeric vector of serum cystatin C in mg/L.

- age:

  Numeric vector of age in years.

## Value

Numeric vector of eGFR in mL/min/1.73m^2.

## Validity

Derived in 4690 subjects spanning children and Caucasian and Asian
adults, and intended for use across all ages. Note that CAPA is known to
return implausibly high estimates in children under 10 years.

## References

Grubb A, Horio M, Hansson LO, et al. Generation of a new cystatin
C-based estimating equation for GFR by use of 7 assays standardized to
the international calibrator. Clin Chem. 2014;60(7):974-986.
[doi:10.1373/clinchem.2013.220707](https://doi.org/10.1373/clinchem.2013.220707)

## Examples

``` r
egfr_capa(cystatin = 1.0, age = 12)
#> [1] 90.20288
```
