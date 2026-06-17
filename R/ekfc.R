#' EKFC creatinine Q value (median reference creatinine, mg/dL)
#' @noRd
.egfr_ekfc_q_cr <- function(age, sex) {
  # Paediatric age bands replicate the published EKFC/FAS Q reference values.
  q_male <- function(a) {
    ifelse(a < 2, 0.20,
    ifelse(a < 5, 0.27,
    ifelse(a < 7, 0.32,
    ifelse(a < 9, 0.37,
    ifelse(a < 11, 0.43,
    ifelse(a < 13, 0.52,
    ifelse(a < 15, 0.65,
    ifelse(a < 17, 0.78, 0.85))))))))
  }
  q_female <- function(a) {
    ifelse(a < 2, 0.20,
    ifelse(a < 5, 0.27,
    ifelse(a < 7, 0.32,
    ifelse(a < 9, 0.36,
    ifelse(a < 11, 0.41,
    ifelse(a < 13, 0.47,
    ifelse(a < 15, 0.55,
    ifelse(a < 17, 0.62, 0.67))))))))
  }
  adult_q <- ifelse(sex == "female", 0.70, 0.90)
  ped_q   <- ifelse(sex == "female", q_female(age), q_male(age))
  ifelse(age < 18, ped_q, adult_q)
}

#' EKFC creatinine eGFR (2021)
#'
#' Estimates GFR from serum creatinine using the European Kidney Function
#' Consortium (EKFC) creatinine equation (Pottel et al., 2021). Valid across
#' the full age spectrum (2-120 years).
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pottel H, Bjork J, Courbebaisse M, et al. Development and
#'   validation of a modified full age spectrum creatinine-based equation to
#'   estimate glomerular filtration rate. Ann Intern Med. 2021;174(2):183-191.
#'   \doi{10.7326/M20-4366}
#' @examples
#' egfr_ekfc_cr(creatinine = 1.0, age = 50, sex = "female")
#' egfr_ekfc_cr(0.5, 8, "male")
#' @export
egfr_ekfc_cr <- function(creatinine, age, sex,
                         creatinine_units = "mg/dl",
                         label_sex_male = "male",
                         label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  Q <- .egfr_ekfc_q_cr(age, sex)
  ratio <- scr / Q
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
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pottel H, Bjork J, Rule AD, et al. Cystatin C-based equation to
#'   estimate GFR without the inclusion of race and sex. N Engl J Med.
#'   2023;388(4):333-343. \doi{10.1056/NEJMoa2203769}
#' @examples
#' egfr_ekfc_cys(cystatin = 0.9, age = 50)
#' @export
egfr_ekfc_cys <- function(cystatin, age) {
  parts <- .egfr_recycle(cystatin, age)
  cystatin <- parts[[1]]; age <- parts[[2]]

  Q <- ifelse(age <= 50, 0.83, 0.83 + 0.005 * (age - 50))
  ratio <- cystatin / Q
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
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pottel H, Bjork J, Rule AD, et al. N Engl J Med.
#'   2023;388(4):333-343. \doi{10.1056/NEJMoa2203769}
#' @examples
#' egfr_ekfc_cr_cys(creatinine = 1.0, cystatin = 0.9, age = 50, sex = "female")
#' @export
egfr_ekfc_cr_cys <- function(creatinine, cystatin, age, sex,
                             creatinine_units = "mg/dl",
                             label_sex_male = "male",
                             label_sex_female = "female") {
  cr <- egfr_ekfc_cr(creatinine, age, sex,
                     creatinine_units = creatinine_units,
                     label_sex_male = label_sex_male,
                     label_sex_female = label_sex_female)
  cys <- egfr_ekfc_cys(cystatin, age)
  (cr + cys) / 2
}

#' Full Age Spectrum (FAS) creatinine eGFR
#'
#' Estimates GFR from serum creatinine using the Full Age Spectrum equation
#' (Pottel et al., 2016). Uses adult reference Q values (male 0.90, female
#' 0.70 mg/dL) across all ages.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pottel H, Hoste L, Dubourg L, et al. An estimated glomerular
#'   filtration rate equation for the full age spectrum. Nephrol Dial
#'   Transplant. 2016;31(5):798-806. \doi{10.1093/ndt/gfv454}
#' @examples
#' egfr_fas_cr(creatinine = 1.0, age = 50, sex = "female")
#' @export
egfr_fas_cr <- function(creatinine, age, sex,
                        creatinine_units = "mg/dl",
                        label_sex_male = "male",
                        label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  Q <- ifelse(sex == "female", 0.7, 0.9)
  ratio <- scr / Q
  egfr <- ifelse(age <= 40,
                 107.3 / ratio,
                 107.3 * ratio^(-0.88) * 0.988^(age - 40))
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
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  pcr <- scr * 88.4  # convert mg/dL to umol/L
  X_female <- ifelse(pcr < 150,
                     2.50 + 0.0121 * (150 - pcr),
                     2.50 - 0.926 * log(pcr / 150))
  X_male <- ifelse(pcr < 180,
                   2.56 + 0.00968 * (180 - pcr),
                   2.56 - 0.926 * log(pcr / 180))
  X <- ifelse(sex == "female", X_female, X_male)
  egfr <- exp(X - 0.0158 * age + 0.438 * log(age))
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
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  sexFactor <- ifelse(sex == "female", 0.82, 1.00)
  egfr <- 3736 * scr^(-0.87) * age^(-0.95) * sexFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}
