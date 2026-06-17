# Body surface area (BSA)

Computes body surface area, used to convert between absolute (mL/min)
and BSA-normalised (mL/min/1.73m^2) GFR.

## Usage

``` r
bsa(weight, height, method = c("dubois", "haycock", "mosteller"))
```

## Arguments

- weight:

  Numeric vector of body weight in kilograms.

- height:

  Numeric vector of height in centimetres.

- method:

  One of `"dubois"` (Du Bois & Du Bois, default), `"haycock"`, or
  `"mosteller"`.

## Value

Numeric vector of body surface area in m^2.

## References

Du Bois D, Du Bois EF. Arch Intern Med. 1916;17:863-871. Haycock GB, et
al. J Pediatr. 1978;93(1):62-66. Mosteller RD. N Engl J Med.
1987;317(17):1098.

## Examples

``` r
bsa(weight = 80, height = 180)
#> [1] 1.996421
bsa(weight = 20, height = 110, method = "haycock")
#> [1] 0.7832173
```
