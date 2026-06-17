test_that("EKFC combined equals the mean of its components", {
  cr <- egfr_ekfc_cr(1.0, 50, "female")
  cys <- egfr_ekfc_cys(0.9, 50)
  expect_equal(
    egfr_ekfc_cr_cys(1.0, 0.9, 50, "female"),
    (cr + cys) / 2
  )
})

test_that("EKFC creatinine applies the over-40 age correction", {
  # At the median ratio (SCr == Q) the base eGFR is exactly 107.3 before
  # the age correction.
  young <- egfr_ekfc_cr(0.7, 40, "female") # no correction at age 40
  expect_equal(young, 107.3, tolerance = 1e-6)
  older <- egfr_ekfc_cr(0.7, 50, "female")
  expect_equal(older, 107.3 * 0.990^10, tolerance = 1e-6)
})

test_that("EKFC cystatin C needs no sex argument and is vectorised", {
  expect_length(egfr_ekfc_cys(c(0.8, 1.2), c(30, 60)), 2)
})

test_that("EKFC creatinine accepts a user-supplied Q value", {
  # Default Q for an adult female is 0.70 mg/dL.
  expect_equal(
    egfr_ekfc_cr(1.0, 50, "female", q = 0.70),
    egfr_ekfc_cr(1.0, 50, "female"),
    tolerance = 1e-6
  )
  # A custom Q reproduces the published EKFC form with that Q.
  ratio <- 1.0 / 0.72
  alpha <- if (ratio < 1) -0.322 else -1.132
  expect_equal(
    egfr_ekfc_cr(1.0, 50, "female", q = 0.72),
    107.3 * ratio^alpha * 0.990^(50 - 40),
    tolerance = 1e-6
  )
})

test_that("EKFC custom Q is recycled and validated", {
  expect_length(egfr_ekfc_cr(c(0.8, 1.2), c(40, 60), "male", q = 0.9), 2)
  expect_length(egfr_ekfc_cr(c(0.8, 1.2), 50, "male", q = c(0.85, 0.95)), 2)
  expect_error(egfr_ekfc_cr(1.0, 50, "female", q = 0), "positive")
  expect_error(egfr_ekfc_cr(1.0, 50, "female", q = -0.5), "positive")
})

test_that("EKFC cystatin C accepts a user-supplied Q value", {
  expect_equal(
    egfr_ekfc_cys(0.9, 50, q = 0.83),
    egfr_ekfc_cys(0.9, 50),
    tolerance = 1e-6
  )
  ratio <- 0.9 / 0.85
  alpha <- if (ratio < 1) -0.322 else -1.132
  expect_equal(
    egfr_ekfc_cys(0.9, 50, q = 0.85),
    107.3 * ratio^alpha * 0.990^(50 - 40),
    tolerance = 1e-6
  )
})

test_that("EKFC combined accepts separate creatinine and cystatin Q values", {
  cr <- egfr_ekfc_cr(1.0, 50, "female", q = 0.72)
  cys <- egfr_ekfc_cys(0.9, 50, q = 0.85)
  expect_equal(
    egfr_ekfc_cr_cys(1.0, 0.9, 50, "female", q_cr = 0.72, q_cys = 0.85),
    (cr + cys) / 2,
    tolerance = 1e-6
  )
})

test_that("FAS at SCr == Q and age <= 40 returns 107.3", {
  expect_equal(egfr_fas_cr(0.7, 30, "female"), 107.3, tolerance = 1e-6)
  expect_equal(egfr_fas_cr(0.9, 30, "male"), 107.3, tolerance = 1e-6)
})

test_that("FAS for age > 40 applies the 0.988^(age-40) decay to 107.3/(SCr/Q)", {
  # Published Pottel 2016 form: 107.3 / (SCr/Q) * 0.988^(age - 40)
  expect_equal(
    egfr_fas_cr(1.5, 50, "male"),
    107.3 / (1.5 / 0.9) * 0.988^(50 - 40),
    tolerance = 1e-6
  )
  expect_equal(
    egfr_fas_cr(1.2, 70, "female"),
    107.3 / (1.2 / 0.7) * 0.988^(70 - 40),
    tolerance = 1e-6
  )
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
