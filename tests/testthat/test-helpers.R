test_that("bsa methods return expected Du Bois value", {
  expect_equal(bsa(80, 180), 2.0, tolerance = 0.02)
  expect_true(bsa(20, 110, method = "haycock") > 0)
  expect_true(bsa(80, 180, method = "mosteller") > 0)
})

test_that("gfr_bsa_adjust round-trips", {
  absolute   <- gfr_bsa_adjust(68.6, bsa = 2.0, to = "absolute")
  normalized <- gfr_bsa_adjust(absolute, bsa = 2.0, to = "normalized")
  expect_equal(normalized, 68.6, tolerance = 1e-9)
})

test_that("ckd_stage classifies boundaries correctly", {
  expect_equal(
    ckd_stage(c(95, 90, 89, 60, 59, 45, 44, 30, 29, 15, 14)),
    c("G1", "G1", "G2", "G2", "G3a", "G3a", "G3b", "G3b", "G4", "G4", "G5")
  )
})

test_that("convert_creatinine round-trips", {
  expect_equal(convert_creatinine(1.0, "mg/dl", "umol/l"), 88.4)
  expect_equal(convert_creatinine(88.4, "umol/l", "mg/dl"), 1.0)
})
