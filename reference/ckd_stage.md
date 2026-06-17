# KDIGO CKD stage from eGFR

Classifies eGFR values into KDIGO GFR categories (G1-G5).

## Usage

``` r
ckd_stage(egfr)
```

## Arguments

- egfr:

  Numeric vector of eGFR in mL/min/1.73m^2.

## Value

Character vector of GFR categories: `"G1"`, `"G2"`, `"G3a"`, `"G3b"`,
`"G4"`, or `"G5"`.

## References

Kidney Disease: Improving Global Outcomes (KDIGO) CKD Work Group. KDIGO
2012 Clinical Practice Guideline. Kidney Int Suppl. 2013.

## Examples

``` r
ckd_stage(c(95, 72, 50, 35, 20, 8))
#> [1] "G1"  "G2"  "G3a" "G3b" "G4"  "G5" 
```
