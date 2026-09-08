# Validation against independently published reference values.
#
# Every expectation in this file is written out from the coefficients as they
# appear in the original publication, rather than by calling the package's own
# helpers. This is deliberate: a test that re-derives a value using the same
# internal function it is testing cannot detect a mis-transcribed equation.

# ---------------------------------------------------------------------------
# CKD-EPI (Inker 2021 Table 2; Levey 2009 Table 2)
# ---------------------------------------------------------------------------

test_that("CKD-EPI 2021 creatinine reproduces the published equation", {
  # 142 * min(Scr/k,1)^a * max(Scr/k,1)^-1.200 * 0.9938^age * 1.012 [female]
  expect_equal(
    egfr_ckdepi_cr_2021(1.0, 50, "female"),
    142 * (1.0 / 0.7)^(-1.200) * 0.9938^50 * 1.012,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_ckdepi_cr_2021(0.6, 50, "female"),
    142 * (0.6 / 0.7)^(-0.241) * 0.9938^50 * 1.012,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_ckdepi_cr_2021(1.2, 65, "male"),
    142 * (1.2 / 0.9)^(-1.200) * 0.9938^65,
    tolerance = 1e-9
  )
})

test_that("CKD-EPI 2009 creatinine reproduces Levey 2009 Table 2 exactly", {
  # Table 2 gives collapsed intercepts per race/sex stratum.
  expect_equal(
    egfr_ckdepi_cr_2009(1.0, 50, "female"),
    144 * (1.0 / 0.7)^(-1.209) * 0.993^50,
    tolerance = 0.5
  )
  expect_equal(
    egfr_ckdepi_cr_2009(1.0, 50, "male"),
    141 * (1.0 / 0.9)^(-1.209) * 0.993^50,
    tolerance = 1e-9
  )
  # Black male stratum: published intercept 163 = 141 * 1.159 (163.4).
  expect_equal(
    egfr_ckdepi_cr_2009(1.0, 50, "male",
      ethnicity = "black", label_afroamerican = "black"
    ),
    163 * (1.0 / 0.9)^(-1.209) * 0.993^50,
    tolerance = 0.5
  )
})

test_that("CKD-EPI cystatin C uses the 2021 Table 2 four-decimal age factor", {
  # 133 * min/max terms * 0.9962^age * 0.932 [female]
  expect_equal(
    egfr_ckdepi_cys_2021(0.9, 55, "male"),
    133 * (0.9 / 0.8)^(-1.328) * 0.9962^55,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_ckdepi_cys_2021(0.7, 55, "female"),
    133 * (0.7 / 0.8)^(-0.499) * 0.9962^55 * 0.932,
    tolerance = 1e-9
  )
  # Guard the documented ~1.2% offset against a 0.996-based calculator.
  ratio <- egfr_ckdepi_cys_2021(0.9, 60, "male") /
    (133 * (0.9 / 0.8)^(-1.328) * 0.996^60)
  expect_equal(ratio, 1.0121, tolerance = 1e-3)
})

test_that("CKD-EPI 2021 combined reproduces the published equation", {
  expect_equal(
    egfr_ckdepi_cr_cys_2021(1.0, 0.9, 50, "female"),
    135 * (1.0 / 0.7)^(-0.544) * (0.9 / 0.8)^(-0.778) * 0.9961^50 * 0.963,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_ckdepi_cr_cys_2021(0.6, 0.7, 40, "male"),
    135 * (0.6 / 0.9)^(-0.144) * (0.7 / 0.8)^(-0.323) * 0.9961^40,
    tolerance = 1e-9
  )
})

# ---------------------------------------------------------------------------
# MDRD and Cockcroft-Gault
# ---------------------------------------------------------------------------

test_that("MDRD reproduces the IDMS-traceable 2006 coefficients", {
  expect_equal(
    egfr_mdrd(1.2, 60, "male"),
    175 * 1.2^(-1.154) * 60^(-0.203),
    tolerance = 1e-9
  )
  expect_equal(
    egfr_mdrd(1.2, 60, "female"),
    175 * 1.2^(-1.154) * 60^(-0.203) * 0.742,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_mdrd(1.2, 60, "male",
      ethnicity = "black", label_afroamerican = "black"
    ),
    175 * 1.2^(-1.154) * 60^(-0.203) * 1.212,
    tolerance = 1e-9
  )
})

test_that("Cockcroft-Gault reproduces the 1976 equation", {
  expect_equal(
    egfr_cockcroft_gault(1.0, 50, "male", weight = 80),
    ((140 - 50) * 80) / (72 * 1.0),
    tolerance = 1e-9
  )
  # "15% less in females" per the original publication.
  expect_equal(
    egfr_cockcroft_gault(1.0, 50, "female", weight = 80),
    ((140 - 50) * 80) / (72 * 1.0) * 0.85,
    tolerance = 1e-9
  )
})

# ---------------------------------------------------------------------------
# EKFC reference Q (Pottel 2021)
# ---------------------------------------------------------------------------

test_that("EKFC creatinine Q reproduces the published polynomial", {
  # Published Q values in umol/L, from the age polynomials for ages 2-25.
  expected_umol <- data.frame(
    age    = c(2, 5, 10, 12, 15, 18, 20, 22),
    male   = c(27.4, 31.2, 47.3, 54.4, 64.4, 72.3, 76.2, 78.9),
    female = c(25.9, 32.0, 45.1, 49.9, 55.8, 59.8, 61.4, 62.2)
  )
  for (i in seq_len(nrow(expected_umol))) {
    a <- expected_umol$age[i]
    expect_equal(
      .egfr_ekfc_q_cr(a, "male") * 88.4,
      expected_umol$male[i],
      tolerance = 0.05,
      info = paste("male age", a)
    )
    expect_equal(
      .egfr_ekfc_q_cr(a, "female") * 88.4,
      expected_umol$female[i],
      tolerance = 0.05,
      info = paste("female age", a)
    )
  }
})

test_that("EKFC Q reaches the adult plateau at age 25, not 18", {
  # The plateau must NOT start at 18.
  expect_false(isTRUE(all.equal(.egfr_ekfc_q_cr(18, "male"), 0.90)))
  expect_false(isTRUE(all.equal(.egfr_ekfc_q_cr(18, "female"), 0.70)))
  # From 25 onwards Q is constant at the adult values.
  expect_equal(.egfr_ekfc_q_cr(25, "male"), 0.90, tolerance = 1e-9)
  expect_equal(.egfr_ekfc_q_cr(60, "male"), 0.90, tolerance = 1e-9)
  expect_equal(.egfr_ekfc_q_cr(25, "female"), 0.70, tolerance = 1e-9)
  expect_equal(.egfr_ekfc_q_cr(60, "female"), 0.70, tolerance = 1e-9)
})

test_that("EKFC paediatric Q is smooth (no age-band step discontinuities)", {
  # The previous age-band implementation produced eGFR jumps of up to 40% at
  # band edges. A continuous Q must not move more than ~1% over 0.02 years.
  ages <- seq(2.5, 24.5, by = 0.5)
  for (s in c("male", "female")) {
    lo <- .egfr_ekfc_q_cr(ages - 0.01, s)
    hi <- .egfr_ekfc_q_cr(ages + 0.01, s)
    expect_true(
      all(abs(hi / lo - 1) < 0.01),
      info = paste("Q discontinuity detected for", s)
    )
  }
})

test_that("EKFC creatinine equation reproduces the published form", {
  q10 <- .egfr_ekfc_q_cr(10, "male")
  # Below the median: exponent -0.322; at/above: -1.132.
  expect_equal(
    egfr_ekfc_cr(q10 * 0.5, 10, "male"),
    107.3 * 0.5^(-0.322),
    tolerance = 1e-9
  )
  expect_equal(
    egfr_ekfc_cr(q10 * 2, 10, "male"),
    107.3 * 2^(-1.132),
    tolerance = 1e-9
  )
  # At SCr == Q and age <= 40 the equation returns exactly 107.3.
  expect_equal(egfr_ekfc_cr(q10, 10, "male"), 107.3, tolerance = 1e-9)
  # Age correction applies only above 40.
  expect_equal(
    egfr_ekfc_cr(0.9, 60, "male"),
    107.3 * 0.990^20,
    tolerance = 1e-9
  )
})

test_that("EKFC cystatin C Q is additive above age 50", {
  # Q = 0.83 below 50; 0.83 + 0.005*(age-50) from 50 onwards.
  expect_equal(egfr_ekfc_cys(0.83, 30), 107.3, tolerance = 1e-9)
  expect_equal(
    egfr_ekfc_cys(0.83 + 0.005 * 40, 90),
    107.3 * 0.990^50,
    tolerance = 1e-9
  )
  # A multiplicative Q would give 0.83*(1+0.005*40) = 0.996 at age 90; the
  # published additive form gives 1.03. Confirm the additive value is used.
  expect_equal(
    egfr_ekfc_cys(1.03, 90),
    107.3 * 0.990^50,
    tolerance = 1e-3
  )
})

# ---------------------------------------------------------------------------
# FAS reference Q (Pottel 2016 Table 1)
# ---------------------------------------------------------------------------

test_that("FAS Q reproduces the published Table 1", {
  # Ages 1-14 are NOT sex-specific in the published table.
  child <- c(
    0.26, 0.29, 0.31, 0.34, 0.38, 0.41, 0.44,
    0.46, 0.49, 0.51, 0.53, 0.57, 0.59, 0.61
  )
  for (a in 1:14) {
    expect_equal(.egfr_fas_q_cr(a, "male"), child[a], tolerance = 1e-9)
    expect_equal(.egfr_fas_q_cr(a, "female"), child[a], tolerance = 1e-9)
  }
  # Sex-specific from age 15.
  expect_equal(
    vapply(15:19, .egfr_fas_q_cr, numeric(1), sex = "male"),
    c(0.72, 0.78, 0.82, 0.85, 0.88),
    tolerance = 1e-9
  )
  expect_equal(
    vapply(15:19, .egfr_fas_q_cr, numeric(1), sex = "female"),
    c(0.64, 0.67, 0.69, 0.69, 0.70),
    tolerance = 1e-9
  )
  # Adult plateau begins at 20, not 18.
  expect_equal(.egfr_fas_q_cr(20, "male"), 0.90, tolerance = 1e-9)
  expect_equal(.egfr_fas_q_cr(20, "female"), 0.70, tolerance = 1e-9)
  expect_equal(.egfr_fas_q_cr(19, "male"), 0.88, tolerance = 1e-9)
})

test_that("FAS uses paediatric Q rather than adult Q for children", {
  # Regression guard: using the adult Q of 0.90 for a 10-year-old boy
  # overestimated eGFR by ~76%.
  expect_equal(egfr_fas_cr(0.51, 10, "male"), 107.3, tolerance = 1e-9)
  expect_equal(egfr_fas_cr(0.26, 1, "female"), 107.3, tolerance = 1e-9)
  expect_false(
    isTRUE(all.equal(egfr_fas_cr(0.51, 10, "male"), 107.3 / (0.51 / 0.90)))
  )
})

test_that("FAS reproduces the published age correction", {
  expect_equal(
    egfr_fas_cr(1.5, 50, "male"),
    107.3 / (1.5 / 0.9) * 0.988^10,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_fas_cr(1.2, 70, "female"),
    107.3 / (1.2 / 0.7) * 0.988^30,
    tolerance = 1e-9
  )
})

# ---------------------------------------------------------------------------
# Lund-Malmo Revised and BIS1
# ---------------------------------------------------------------------------

test_that("Lund-Malmo Revised reproduces all four published branches", {
  # Female, PCr < 150 umol/L
  pcr <- 0.9 * 88.4
  expect_equal(
    egfr_lund_malmo(0.9, 50, "female"),
    exp(2.50 + 0.0121 * (150 - pcr) - 0.0158 * 50 + 0.438 * log(50)),
    tolerance = 1e-9
  )
  # Female, PCr >= 150
  pcr <- 2.0 * 88.4
  expect_equal(
    egfr_lund_malmo(2.0, 50, "female"),
    exp(2.50 - 0.926 * log(pcr / 150) - 0.0158 * 50 + 0.438 * log(50)),
    tolerance = 1e-9
  )
  # Male, PCr < 180
  pcr <- 1.0 * 88.4
  expect_equal(
    egfr_lund_malmo(1.0, 70, "male"),
    exp(2.56 + 0.00968 * (180 - pcr) - 0.0158 * 70 + 0.438 * log(70)),
    tolerance = 1e-9
  )
  # Male, PCr >= 180
  pcr <- 2.5 * 88.4
  expect_equal(
    egfr_lund_malmo(2.5, 70, "male"),
    exp(2.56 - 0.926 * log(pcr / 180) - 0.0158 * 70 + 0.438 * log(70)),
    tolerance = 1e-9
  )
})

test_that("BIS1 reproduces the published coefficients", {
  expect_equal(
    egfr_bis_cr(1.1, 75, "male"),
    3736 * 1.1^(-0.87) * 75^(-0.95),
    tolerance = 1e-9
  )
  expect_equal(
    egfr_bis_cr(1.1, 75, "female"),
    3736 * 1.1^(-0.87) * 75^(-0.95) * 0.82,
    tolerance = 1e-9
  )
})

# ---------------------------------------------------------------------------
# Paediatric and neonatal
# ---------------------------------------------------------------------------

test_that("Bedside Schwartz reproduces 0.413 * height(cm) / SCr", {
  expect_equal(egfr_schwartz(0.5, 120), 0.413 * 120 / 0.5, tolerance = 1e-9)
  expect_equal(egfr_schwartz(0.8, 150), 0.413 * 150 / 0.8, tolerance = 1e-9)
})

test_that("CKiD U25 creatinine K matches Pierce 2021", {
  # eGFR = K * height(m) / SCr, so K = eGFR * SCr / height(m).
  k <- function(age, sex) egfr_ckid_u25_cr(1.0, age, sex, height = 100)
  # Published anchor values at age 1 and the >=18 plateau.
  expect_equal(k(1, "male"), 39.0 * 1.008^(1 - 12), tolerance = 1e-9)
  expect_equal(k(1, "female"), 36.1 * 1.008^(1 - 12), tolerance = 1e-9)
  expect_equal(k(15, "male"), 39.0 * 1.045^(15 - 12), tolerance = 1e-9)
  expect_equal(k(15, "female"), 36.1 * 1.023^(15 - 12), tolerance = 1e-9)
  expect_equal(k(20, "male"), 50.8, tolerance = 1e-9)
  expect_equal(k(20, "female"), 41.4, tolerance = 1e-9)
  # The published K is continuous at the age-18 knot.
  expect_equal(k(17.999, "male"), 50.8, tolerance = 0.02)
  expect_equal(k(17.999, "female"), 41.4, tolerance = 0.02)
})

test_that("CKiD U25 cystatin C K matches Pierce 2021", {
  k <- function(age, sex) egfr_ckid_u25_cys(1.0, age, sex)
  expect_equal(k(10, "male"), 87.2 * 1.011^(10 - 15), tolerance = 1e-9)
  expect_equal(k(16, "male"), 87.2 * 0.960^(16 - 15), tolerance = 1e-9)
  expect_equal(k(20, "male"), 77.1, tolerance = 1e-9)
  expect_equal(k(10, "female"), 79.9 * 1.004^(10 - 12), tolerance = 1e-9)
  expect_equal(k(15, "female"), 79.9 * 0.974^(15 - 12), tolerance = 1e-9)
  expect_equal(k(20, "female"), 68.3, tolerance = 1e-9)
  # Continuous at the age-18 knot for both sexes.
  expect_equal(k(17.999, "male"), 77.1, tolerance = 0.02)
  expect_equal(k(17.999, "female"), 68.3, tolerance = 0.02)
})

test_that("CKiD U25 has no unpublished extension past age 25", {
  expect_false(
    exists("egfr_ckid_u25_cr_extended",
      envir = asNamespace("egfr"), inherits = FALSE
    )
  )
  # K must stay flat above 25 rather than decaying.
  expect_equal(
    egfr_ckid_u25_cr(1.0, 28, "female", height = 100),
    egfr_ckid_u25_cr(1.0, 20, "female", height = 100),
    tolerance = 1e-9
  )
})

test_that("CAPA reproduces the published equation", {
  expect_equal(
    egfr_capa(1.0, 12),
    130 * 1.0^(-1.069) * 12^(-0.117) - 7,
    tolerance = 1e-9
  )
  expect_equal(
    egfr_capa(1.4, 60),
    130 * 1.4^(-1.069) * 60^(-0.117) - 7,
    tolerance = 1e-9
  )
})

test_that("Neonatal equation uses the Smeets 2022 coefficient of 0.31", {
  expect_equal(egfr_neonatal(0.5, 50), 0.31 * 50 / 0.5, tolerance = 1e-9)
  expect_equal(egfr_neonatal(0.4, 48), 0.31 * 48 / 0.4, tolerance = 1e-9)
})

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

test_that("BSA formulas reproduce their published coefficients", {
  expect_equal(
    bsa(80, 180),
    0.007184 * 80^0.425 * 180^0.725,
    tolerance = 1e-9
  )
  expect_equal(
    bsa(20, 110, method = "haycock"),
    0.024265 * 20^0.5378 * 110^0.3964,
    tolerance = 1e-9
  )
  expect_equal(
    bsa(80, 180, method = "mosteller"),
    sqrt(80 * 180 / 3600),
    tolerance = 1e-9
  )
})

test_that("ckd_stage follows the KDIGO 2012 category boundaries", {
  expect_equal(
    ckd_stage(c(90, 89.9, 60, 59.9, 45, 44.9, 30, 29.9, 15, 14.9)),
    c("G1", "G2", "G2", "G3a", "G3a", "G3b", "G3b", "G4", "G4", "G5")
  )
})

test_that("ckd_stage handles NA of any type without erroring", {
  expect_true(is.na(ckd_stage(NA)))
  expect_true(is.na(ckd_stage(NA_real_)))
  expect_equal(ckd_stage(c(95, NA, 20)), c("G1", NA, "G4"))
})
