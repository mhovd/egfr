# Internal helpers in R/utils.R plus the error branch of convert_creatinine().

test_that(".egfr_normalize_sex accepts factor input", {
  sex <- factor(c("female", "male"), levels = c("female", "male"))
  expect_equal(
    .egfr_normalize_sex(sex, label_male = "male", label_female = "female"),
    c("female", "male")
  )
})

test_that(".egfr_normalize_sex handles factors with unused levels", {
  sex <- factor("male", levels = c("male", "female", "other"))
  expect_equal(
    .egfr_normalize_sex(sex, label_male = "male", label_female = "female"),
    "male"
  )
})

test_that(".egfr_normalize_sex maps mixed vectors and recycles labels", {
  expect_equal(
    .egfr_normalize_sex(
      c("F", "M", "F"),
      label_male = "M", label_female = "F"
    ),
    c("female", "male", "female")
  )
})

test_that(".egfr_normalize_sex returns all NA without warning when input is all NA", {
  expect_silent(out <- .egfr_normalize_sex(
    c(NA_character_, NA_character_),
    label_male = "male", label_female = "female"
  ))
  expect_equal(out, c(NA_character_, NA_character_))
})

test_that(".egfr_normalize_sex warns once and lists every unrecognised value", {
  expect_warning(
    out <- .egfr_normalize_sex(
      c("male", "unknown", "Female"),
      label_male = "male", label_female = "female"
    ),
    "Unrecognised sex value"
  )
  expect_equal(out, c("male", NA_character_, NA_character_))
  # The warning quotes each distinct offending value exactly once.
  quoted <- paste(shQuote(c("x", "y")), collapse = ", ")
  expect_warning(
    .egfr_normalize_sex(
      c("x", "x", "y"),
      label_male = "male", label_female = "female"
    ),
    quoted,
    fixed = TRUE
  )
})

test_that(".egfr_creatinine_to_mgdl converts every accepted unit spelling", {
  expect_equal(.egfr_creatinine_to_mgdl(1.0, "mg/dl"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(1.0, "mgdl"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "umol/l"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "\u00b5mol/l"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "micromol/l"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "mcmol/l"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "umoll"), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, "umol"), 1.0)
})

test_that(".egfr_creatinine_to_mgdl ignores case and surrounding whitespace", {
  expect_equal(.egfr_creatinine_to_mgdl(1.0, " MG/DL "), 1.0)
  expect_equal(.egfr_creatinine_to_mgdl(88.4, " uMol/L "), 1.0)
})

test_that(".egfr_creatinine_to_mgdl errors on unsupported units", {
  expect_error(
    .egfr_creatinine_to_mgdl(1.0, "mmol/l"),
    paste0("Unsupported 'creatinine_units': ", shQuote("mmol/l")),
    fixed = TRUE
  )
  expect_error(.egfr_creatinine_to_mgdl(1.0, ""), "Use 'mg/dl' or 'umol/l'")
})

test_that(".egfr_creatinine_to_mgdl is vectorised", {
  expect_equal(.egfr_creatinine_to_mgdl(c(88.4, 176.8), "umol/l"), c(1.0, 2.0))
})

test_that(".egfr_height_to_cm converts centimetres and metres", {
  expect_equal(.egfr_height_to_cm(120, "cm"), 120)
  expect_equal(.egfr_height_to_cm(1.2, "m"), 120)
})

test_that(".egfr_height_to_cm ignores case and surrounding whitespace", {
  expect_equal(.egfr_height_to_cm(120, " CM "), 120)
  expect_equal(.egfr_height_to_cm(1.2, "M"), 120)
})

test_that(".egfr_height_to_cm errors on unsupported units", {
  expect_error(
    .egfr_height_to_cm(120, "mm"),
    paste0("Unsupported 'height_units': ", shQuote("mm")),
    fixed = TRUE
  )
  expect_error(.egfr_height_to_cm(120, "in"), "Use 'cm' or 'm'")
})

test_that(".egfr_check_q rejects non-numeric input", {
  expect_error(.egfr_check_q("0.9"), "'q' must be numeric")
  expect_error(.egfr_check_q(TRUE), "'q' must be numeric")
})

test_that(".egfr_check_q rejects non-positive input", {
  expect_error(.egfr_check_q(0), "'q' must be positive")
  expect_error(.egfr_check_q(c(0.9, -0.1)), "'q' must be positive")
})

test_that(".egfr_check_q accepts positive values and returns them invisibly", {
  res <- withVisible(.egfr_check_q(c(0.7, 0.9)))
  expect_false(res$visible)
  expect_equal(res$value, c(0.7, 0.9))
})

test_that(".egfr_check_q ignores NA when testing positivity", {
  expect_silent(.egfr_check_q(c(0.9, NA)))
})

test_that(".egfr_recycle returns inputs unchanged when lengths match", {
  parts <- .egfr_recycle(c(1, 2, 3), c(4, 5, 6))
  expect_equal(parts[[1]], c(1, 2, 3))
  expect_equal(parts[[2]], c(4, 5, 6))
})

test_that(".egfr_recycle expands scalars to the longest input", {
  parts <- .egfr_recycle(c(1, 2, 3), 10)
  expect_length(parts[[1]], 3)
  expect_equal(parts[[2]], c(10, 10, 10))
})

test_that(".egfr_recycle keeps a single argument as is", {
  parts <- .egfr_recycle(c(1, 2, 3))
  expect_equal(parts[[1]], c(1, 2, 3))
})

test_that(".egfr_recycle preserves non-numeric types", {
  parts <- .egfr_recycle(c("a", "b"), "c")
  expect_equal(parts[[1]], c("a", "b"))
  expect_equal(parts[[2]], c("c", "c"))
})

test_that(".egfr_recycle errors on incompatible lengths", {
  expect_error(
    .egfr_recycle(c(1, 2, 3), c(1, 2)),
    "All arguments must have length 1 or a common length; got lengths 3, 2"
  )
})

test_that("convert_creatinine supports alternative unit spellings", {
  expect_equal(convert_creatinine(1.0, "mgdl", "mg/dl"), 1.0)
  expect_equal(convert_creatinine(1.0, "mg/dl", "\u00b5mol/l"), 88.4)
  expect_equal(convert_creatinine(1.0, "mg/dl", "micromol/l"), 88.4)
  expect_equal(convert_creatinine(1.0, "mg/dl", "mcmol/l"), 88.4)
  expect_equal(convert_creatinine(1.0, " MG/DL ", " UMOL/L "), 88.4)
})

test_that("convert_creatinine errors on unsupported target units", {
  expect_error(
    convert_creatinine(1.0, "mg/dl", "mmol/l"),
    paste0("Unsupported 'to' units: ", shQuote("mmol/l")),
    fixed = TRUE
  )
  expect_error(convert_creatinine(1.0, "mg/dl", "g/l"), "Use 'mg/dl' or 'umol/l'")
})
