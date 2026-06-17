test_that("EKFC combined equals the mean of its components", {
  cr  <- egfr_ekfc_cr(1.0, 50, "female")
  cys <- egfr_ekfc_cys(0.9, 50)
  expect_equal(
    egfr_ekfc_cr_cys(1.0, 0.9, 50, "female"),
    (cr + cys) / 2
  )
})

test_that("EKFC creatinine applies the over-40 age correction", {
  # At the median ratio (SCr == Q) the base eGFR is exactly 107.3 before
  # the age correction.
  young <- egfr_ekfc_cr(0.7, 40, "female")   # no correction at age 40
  expect_equal(young, 107.3, tolerance = 1e-6)
  older <- egfr_ekfc_cr(0.7, 50, "female")
  expect_equal(older, 107.3 * 0.990^10, tolerance = 1e-6)
})

test_that("EKFC cystatin C needs no sex argument and is vectorised", {
  expect_length(egfr_ekfc_cys(c(0.8, 1.2), c(30, 60)), 2)
})

test_that("FAS at SCr == Q and age <= 40 returns 107.3", {
  expect_equal(egfr_fas_cr(0.7, 30, "female"), 107.3, tolerance = 1e-6)
  expect_equal(egfr_fas_cr(0.9, 30, "male"), 107.3, tolerance = 1e-6)
})

test_that("Lund-Malmo returns finite positive values", {
  out <- egfr_lund_malmo(c(0.9, 1.5), c(50, 70), c("female", "male"))
  expect_true(all(out > 0 & is.finite(out)))
})

test_that("BIS elderly female factor is 0.82 relative to male", {
  m <- egfr_bis_cr(1.1, 75, "male")
  f <- egfr_bis_cr(1.1, 75, "female")
  expect_equal(f / m, 0.82, tolerance = 1e-6)
})
