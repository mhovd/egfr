#' EKFC creatinine Q value (median reference creatinine, mg/dL)
#'
#' Implements the reference Q specification of Pottel et al. (2021). For ages
#' 2-25 years inclusive Q follows a sex-specific polynomial in age, published
#' on the micromol/L scale; above age 25 Q is constant at the adult values
#' (0.90 mg/dL male, 0.70 mg/dL female). The polynomial and the adult plateau
#' differ by about 1% at the age-25 knot; this small step is part of the
#' published specification and is deliberately preserved.
#' @noRd
.egfr_ekfc_q_cr <- function(age, sex) {
  # Polynomials give Q in umol/L; divide by 88.4 to obtain mg/dL.
  q_male_umol <- function(a) {
    exp(
      3.200 + 0.259 * a - 0.543 * log(a) -
        0.00763 * a^2 + 0.0000790 * a^3
    )
  }
  q_female_umol <- function(a) {
    exp(
      3.080 + 0.177 * a - 0.223 * log(a) -
        0.00596 * a^2 + 0.0000686 * a^3
    )
  }

  # Guard log(a) against non-positive ages; those records are NA below anyway.
  a <- ifelse(is.na(age) | age <= 0, NA_real_, age)
  ped_q <- ifelse(sex == "female", q_female_umol(a), q_male_umol(a)) / 88.4
  adult_q <- ifelse(sex == "female", 0.70, 0.90)
  ifelse(age <= 25, ped_q, adult_q)
}

#' EKFC creatinine eGFR (2021)
#'
#' Estimates GFR from serum creatinine using the European Kidney Function
#' Consortium (EKFC) creatinine equation (Pottel et al., 2021).
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @param q Optional numeric vector of the reference creatinine Q value
#'   (median creatinine for the age/sex, in mg/dL). When `NULL` (the default)
#'   the built-in EKFC reference Q is used; supply a value to use a
#'   population-, assay-, or individual-specific Q. Recycled to the length of
#'   the other inputs.
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @section Reference Q:
#' The default Q follows the published EKFC specification. For ages 2-25 years
#' inclusive Q is a sex-specific polynomial in age (given by the authors on the
#' micromol/L scale and converted here to mg/dL):
#'
#' \deqn{\ln(Q_{male}) = 3.200 + 0.259 a - 0.543 \ln(a) - 0.00763 a^2 +
#'   0.0000790 a^3}
#' \deqn{\ln(Q_{female}) = 3.080 + 0.177 a - 0.223 \ln(a) - 0.00596 a^2 +
#'   0.0000686 a^3}
#'
#' Above age 25 Q is constant at the adult values of 0.90 mg/dL
#' (80 micromol/L) for males and 0.70 mg/dL (62 micromol/L) for females. The
#' polynomial and the adult plateau differ by roughly 1% at the age-25 knot;
#' this step is part of the published specification and is preserved
#' deliberately.
#'
#' Population-specific adult Q values (e.g. 1.02 / 0.74 mg/dL for Black
#' Europeans) may be supplied via `q`.
#' @section Validity:
#' Developed and validated across ages 2-90 years and serum creatinine
#' 40-490 micromol/L (0.45-5.54 mg/dL). Values outside this range are
#' extrapolations.
#' @references Pottel H, Bjork J, Courbebaisse M, et al. Development and
#'   validation of a modified full age spectrum creatinine-based equation to
#'   estimate glomerular filtration rate. Ann Intern Med. 2021;174(2):183-191.
#'   \doi{10.7326/M20-4366}
#' @examples
#' egfr_ekfc_cr(creatinine = 1.0, age = 50, sex = "female")
#' egfr_ekfc_cr(0.5, 8, "male")
#' egfr_ekfc_cr(1.0, 50, "female", q = 0.72)
#' @export
egfr_ekfc_cr <- function(creatinine, age, sex,
                         creatinine_units = "mg/dl",
                         label_sex_male = "male",
                         label_sex_female = "female",
                         q = NULL) {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)

  if (is.null(q)) {
    parts <- .egfr_recycle(scr, age, sex)
    scr <- parts[[1]]
    age <- parts[[2]]
    sex <- parts[[3]]
    q <- .egfr_ekfc_q_cr(age, sex)
  } else {
    .egfr_check_q(q)
    parts <- .egfr_recycle(scr, age, sex, q)
    scr <- parts[[1]]
    age <- parts[[2]]
    sex <- parts[[3]]
    q <- parts[[4]]
  }

  ratio <- scr / q
  alpha <- ifelse(ratio < 1, -0.322, -1.132)
  egfr <- 107.3 * ratio^alpha
  egfr <- ifelse(age > 40, egfr * 0.990^(age - 40), egfr)
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' EKFC cystatin C eGFR (2023)
#'
#' Estimates GFR from serum cystatin C using the sex- and race-free EKFC
#' cystatin C equation (Pottel et al., 2023).
#'
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @param age Numeric vector of age in years.
#' @param q Optional numeric vector of the reference cystatin C Q value
#'   (median cystatin C, in mg/L). When `NULL` (the default) the built-in
#'   age-based EKFC reference Q is used; supply a value to use a population- or
#'   individual-specific Q. Recycled to the length of the other inputs.
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @section Reference Q:
#' The default Q is the sex- and race-free value published with the equation:
#' 0.83 mg/L below age 50, and 0.83 + 0.005 * (age - 50) from age 50 onwards.
#' The same value of 0.83 mg/L is endorsed for children (Pottel et al.,
#' Pediatr Nephrol. 2024), so no separate paediatric Q is applied.
#' @section Validity:
#' Applicable from age 2 years upwards.
#' @references Pottel H, Bjork J, Rule AD, et al. Cystatin C-based equation to
#'   estimate GFR without the inclusion of race and sex. N Engl J Med.
#'   2023;388(4):333-343. \doi{10.1056/NEJMoa2203769}
#' @examples
#' egfr_ekfc_cys(cystatin = 0.9, age = 50)
#' egfr_ekfc_cys(0.9, 50, q = 0.85)
#' @export
egfr_ekfc_cys <- function(cystatin, age, q = NULL) {
  if (is.null(q)) {
    parts <- .egfr_recycle(cystatin, age)
    cystatin <- parts[[1]]
    age <- parts[[2]]
    q <- ifelse(age <= 50, 0.83, 0.83 + 0.005 * (age - 50))
  } else {
    .egfr_check_q(q)
    parts <- .egfr_recycle(cystatin, age, q)
    cystatin <- parts[[1]]
    age <- parts[[2]]
    q <- parts[[3]]
  }

  ratio <- cystatin / q
  alpha <- ifelse(ratio < 1, -0.322, -1.132)
  egfr <- 107.3 * ratio^alpha
  ifelse(age > 40, egfr * 0.990^(age - 40), egfr)
}

#' EKFC combined creatinine + cystatin C eGFR (2023)
#'
#' Arithmetic mean of the EKFC creatinine ([egfr_ekfc_cr()]) and EKFC
#' cystatin C ([egfr_ekfc_cys()]) estimates.
#'
#' @inheritParams egfr_ekfc_cr
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @param q_cr Optional numeric vector of the reference creatinine Q value
#'   (median creatinine, in mg/dL) passed to [egfr_ekfc_cr()]. `NULL` (default)
#'   uses the built-in EKFC reference Q.
#' @param q_cys Optional numeric vector of the reference cystatin C Q value
#'   (median cystatin C, in mg/L) passed to [egfr_ekfc_cys()]. `NULL` (default)
#'   uses the built-in EKFC reference Q.
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pottel H, Bjork J, Rule AD, et al. N Engl J Med.
#'   2023;388(4):333-343. \doi{10.1056/NEJMoa2203769}
#' @examples
#' egfr_ekfc_cr_cys(creatinine = 1.0, cystatin = 0.9, age = 50, sex = "female")
#' @export
egfr_ekfc_cr_cys <- function(creatinine, cystatin, age, sex,
                             creatinine_units = "mg/dl",
                             label_sex_male = "male",
                             label_sex_female = "female",
                             q_cr = NULL, q_cys = NULL) {
  cr <- egfr_ekfc_cr(creatinine, age, sex,
    creatinine_units = creatinine_units,
    label_sex_male = label_sex_male,
    label_sex_female = label_sex_female,
    q = q_cr
  )
  cys <- egfr_ekfc_cys(cystatin, age, q = q_cys)
  (cr + cys) / 2
}

#' FAS creatinine Q value (median reference creatinine, mg/dL)
#'
#' Implements Table 1 of Pottel et al. (2016). Q is not sex-specific below age
#' 15; it becomes sex-specific for ages 15-19 and reaches the adult values from
#' age 20 onwards.
#' @noRd
.egfr_fas_q_cr <- function(age, sex) {
  # Ages 1-14: single reference series for boys and girls.
  q_child <- c(
    0.26, 0.29, 0.31, 0.34, 0.38, 0.41, 0.44,
    0.46, 0.49, 0.51, 0.53, 0.57, 0.59, 0.61
  )
  q_male_adolescent <- c(0.72, 0.78, 0.82, 0.85, 0.88) # ages 15-19
  q_female_adolescent <- c(0.64, 0.67, 0.69, 0.69, 0.70) # ages 15-19

  yr <- floor(age)
  child <- q_child[pmin(pmax(yr, 1L), 14L)]
  adolescent <- ifelse(
    sex == "female",
    q_female_adolescent[pmin(pmax(yr - 14L, 1L), 5L)],
    q_male_adolescent[pmin(pmax(yr - 14L, 1L), 5L)]
  )
  adult <- ifelse(sex == "female", 0.70, 0.90)

  ifelse(yr < 15, child, ifelse(yr < 20, adolescent, adult))
}

#' Full Age Spectrum (FAS) creatinine eGFR
#'
#' Estimates GFR from serum creatinine using the Full Age Spectrum equation
#' (Pottel et al., 2016), applying the published age- and sex-specific
#' reference Q values across the whole age range.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @section Reference Q:
#' Q values are taken from Table 1 of Pottel et al. (2016). They are shared
#' between boys and girls for ages 1-14 (0.26 mg/dL at age 1 rising to
#' 0.61 mg/dL at age 14), become sex-specific for ages 15-19, and reach the
#' adult values of 0.90 mg/dL (male) and 0.70 mg/dL (female) from age 20
#' onwards. Note that the adult plateau begins at age 20, not 18.
#' @section Validity:
#' The published equation is defined from age 2 years upwards.
#' @references Pottel H, Hoste L, Dubourg L, et al. An estimated glomerular
#'   filtration rate equation for the full age spectrum. Nephrol Dial
#'   Transplant. 2016;31(5):798-806. \doi{10.1093/ndt/gfv454}
#' @examples
#' egfr_fas_cr(creatinine = 1.0, age = 50, sex = "female")
#' egfr_fas_cr(0.5, 10, "male")
#' @export
egfr_fas_cr <- function(creatinine, age, sex,
                        creatinine_units = "mg/dl",
                        label_sex_male = "male",
                        label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]
  age <- parts[[2]]
  sex <- parts[[3]]

  q <- .egfr_fas_q_cr(age, sex)
  ratio <- scr / q
  egfr <- ifelse(age <= 40,
    107.3 / ratio,
    107.3 / ratio * 0.988^(age - 40)
  )
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' Lund-Malmoe Revised creatinine eGFR (2011)
#'
#' Estimates GFR from serum creatinine using the revised Lund-Malmoe equation
#' (Bjork et al., 2011). Piecewise-linear in plasma creatinine (umol/L) with
#' sex-specific knots.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @section Validity:
#' Derived in 850 Swedish adults aged 18-95 years. Not validated in children;
#' a separate paediatric adaptation (LMR18) was published in 2020.
#' @references Bjork J, Grubb A, Sterner G, Nyman U. Revised equations for
#'   estimating glomerular filtration rate based on the Lund-Malmo Study
#'   cohort. Scand J Clin Lab Invest. 2011;71(3):232-239.
#'   \doi{10.3109/00365513.2011.557086}
#' @examples
#' egfr_lund_malmo(creatinine = 1.0, age = 50, sex = "female")
#' @export
egfr_lund_malmo <- function(creatinine, age, sex,
                            creatinine_units = "mg/dl",
                            label_sex_male = "male",
                            label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]
  age <- parts[[2]]
  sex <- parts[[3]]

  pcr <- scr * 88.4 # convert mg/dL to umol/L
  x_female <- ifelse(pcr < 150,
    2.50 + 0.0121 * (150 - pcr),
    2.50 - 0.926 * log(pcr / 150)
  )
  x_male <- ifelse(pcr < 180,
    2.56 + 0.00968 * (180 - pcr),
    2.56 - 0.926 * log(pcr / 180)
  )
  x <- ifelse(sex == "female", x_female, x_male)
  egfr <- exp(x - 0.0158 * age + 0.438 * log(age))
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' Berlin Initiative Study (BIS1) creatinine eGFR (2012)
#'
#' Estimates GFR from serum creatinine using the BIS1 equation (Schaeffner et
#' al., 2012), developed in an elderly (>= 70 years) German cohort.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @section Validity:
#' Derived in 610 community-dwelling Germans aged 70 years or older (mean age
#' 78.5). It should not be applied below age 70, and the authors note that no
#' external validation dataset was used.
#' @references Schaeffner ES, Ebert N, Delanaye P, et al. Two novel equations
#'   to estimate kidney function in persons aged 70 years or older. Ann Intern
#'   Med. 2012;157(7):471-481. \doi{10.7326/0003-4819-157-7-201210020-00003}
#' @examples
#' egfr_bis_cr(creatinine = 1.1, age = 75, sex = "female")
#' @export
egfr_bis_cr <- function(creatinine, age, sex,
                        creatinine_units = "mg/dl",
                        label_sex_male = "male",
                        label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]
  age <- parts[[2]]
  sex <- parts[[3]]

  sex_factor <- ifelse(sex == "female", 0.82, 1.00)
  egfr <- 3736 * scr^(-0.87) * age^(-0.95) * sex_factor
  egfr[is.na(sex)] <- NA_real_
  egfr
}
