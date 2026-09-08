test_that("Schwartz bedside matches a known value", {
  # 41.3 * (120/100) / 0.5 = 99.12
  expect_equal(egfr_schwartz(0.5, 120), 99.12, tolerance = 1e-6)
})

test_that("Schwartz accepts height in metres", {
  expect_equal(
    egfr_schwartz(0.5, 1.2, height_units = "m"),
    egfr_schwartz(0.5, 120, height_units = "cm")
  )
})

test_that("CKiD U25 combined equals the mean of its components", {
  cr <- egfr_ckid_u25_cr(0.6, 10, "male", height = 140)
  cys <- egfr_ckid_u25_cys(0.8, 10, "male")
  expect_equal(
    egfr_ckid_u25_cr_cys(0.6, 0.8, 10, "male", height = 140),
    (cr + cys) / 2
  )
})

test_that("CKiD U25 adult-plateau kappa is used for ages 18-25", {
  # female plateau kappa = 41.4: eGFR = 41.4 * (height_m / SCr)
  expect_equal(
    egfr_ckid_u25_cr(1.0, 20, "female", height = 170),
    41.4 * (1.70 / 1.0),
    tolerance = 1e-6
  )
})

test_that("CAPA matches a known value", {
  # 130 * 1^-1.069 * 12^-0.117 - 7 ~= 90.2
  expect_equal(egfr_capa(1.0, 12), 90.2, tolerance = 0.1)
})

test_that("Neonatal eGFR matches a known value", {
  # 0.31 * 50 / 0.5 = 31
  expect_equal(egfr_neonatal(0.5, 50), 31, tolerance = 1e-6)
})
