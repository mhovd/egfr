test_that("CKD-EPI 2021 creatinine matches a known reference value", {
  # 50-year-old female, SCr 1.0 mg/dL -> ~68.6 mL/min/1.73m^2
  expect_equal(
    egfr_ckdepi_cr_2021(1.0, 50, "female"),
    68.6,
    tolerance = 0.1
  )
})

test_that("creatinine unit choice does not change the result", {
  mgdl <- egfr_ckdepi_cr_2021(1.0, 50, "female", creatinine_units = "mg/dl")
  umoll <- egfr_ckdepi_cr_2021(88.4, 50, "female", creatinine_units = "umol/l")
  expect_equal(mgdl, umoll)
})

test_that("functions are vectorised and recycle scalars", {
  res <- egfr_ckdepi_cr_2021(c(0.8, 1.2), c(40, 65), c("female", "male"))
  expect_length(res, 2)
  res2 <- egfr_ckdepi_cr_2021(c(0.8, 1.2), 50, "female")
  expect_length(res2, 2)
})

test_that("unrecognised sex yields NA with a warning", {
  expect_warning(
    out <- egfr_ckdepi_cr_2021(1.0, 50, "unknown"),
    "Unrecognised sex"
  )
  expect_true(is.na(out))
})

test_that("custom sex labels work", {
  out <- egfr_ckdepi_cr_2021(1.0, 50, "F",
    label_sex_female = "F", label_sex_male = "M"
  )
  expect_equal(out, 68.6, tolerance = 0.1)
})

test_that("CKD-EPI 2009 race coefficient is applied only when requested", {
  base <- egfr_ckdepi_cr_2009(1.0, 50, "female")
  black <- egfr_ckdepi_cr_2009(1.0, 50, "female",
    ethnicity = "black",
    label_afroamerican = "black"
  )
  expect_equal(black / base, 1.159, tolerance = 1e-6)
})

test_that("CKD-EPI 2012 and 2021 cystatin C equations are identical", {
  expect_equal(
    egfr_ckdepi_cys_2012(0.9, 55, "male"),
    egfr_ckdepi_cys_2021(0.9, 55, "male")
  )
})

test_that("MDRD matches a known reference value", {
  expect_equal(egfr_mdrd(1.2, 60, "male"), 61.8, tolerance = 0.2)
})

test_that("Cockcroft-Gault returns creatinine clearance in mL/min", {
  expect_equal(egfr_cockcroft_gault(1.0, 50, "male", weight = 80), 100)
  # female correction factor 0.85
  expect_equal(
    egfr_cockcroft_gault(1.0, 50, "female", weight = 80),
    85
  )
})
