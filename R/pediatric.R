#' Schwartz bedside paediatric eGFR (2009)
#'
#' Estimates GFR in children using the bedside Schwartz equation (Schwartz et
#' al., 2009). Requires IDMS-standardised creatinine.
#'
#' @param creatinine Numeric vector of serum creatinine.
#' @param height Numeric vector of height.
#' @param creatinine_units Units of `creatinine`: `"mg/dl"` (default) or
#'   `"umol/l"`.
#' @param height_units Units of `height`: `"cm"` (default) or `"m"`.
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Schwartz GJ, Munoz A, Schneider MF, et al. New equations to
#'   estimate GFR in children with CKD. J Am Soc Nephrol. 2009;20(3):629-637.
#'   \doi{10.1681/ASN.2008030287}
#' @examples
#' egfr_schwartz(creatinine = 0.5, height = 120)
#' @export
egfr_schwartz <- function(creatinine, height,
                          creatinine_units = "mg/dl",
                          height_units = "cm") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  height_cm <- .egfr_height_to_cm(height, height_units)
  parts <- .egfr_recycle(scr, height_cm)
  scr <- parts[[1]]; height_cm <- parts[[2]]
  height_m <- height_cm / 100
  41.3 * height_m / scr
}

#' CKiD U25 age- and sex-dependent kappa for creatinine equations
#' @noRd
.egfr_ckid_kappa_cr <- function(age, sex, extended = FALSE) {
  female <- ifelse(
    age < 12, 36.1 * 1.008^(age - 12),
    ifelse(age < 18, 36.1 * 1.023^(age - 12),
    ifelse(age <= 25, 41.4,
           if (extended) 41.4 * 0.995^(age - 25) else 41.4)))
  male <- ifelse(
    age < 12, 39.0 * 1.008^(age - 12),
    ifelse(age < 18, 39.0 * 1.045^(age - 12),
    ifelse(age <= 25, 50.8,
           if (extended) 50.8 * 0.995^(age - 25) else 50.8)))
  ifelse(sex == "female", female, male)
}

#' CKiD U25 creatinine eGFR
#'
#' Estimates GFR in children and young adults (ages 1-25) using the CKiD U25
#' creatinine equation (Pierce et al., 2021). This is the first-choice
#' paediatric equation.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @param height Numeric vector of height.
#' @param height_units Units of `height`: `"cm"` (default) or `"m"`.
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pierce CB, Munoz A, Ng DK, Warady BA, Furth SL, Schwartz GJ.
#'   Age- and sex-dependent clinical equations to estimate GFR in children and
#'   young adults with CKD. Kidney Int. 2021;99(4):948-956.
#'   \doi{10.1016/j.kint.2020.10.047}
#' @examples
#' egfr_ckid_u25_cr(creatinine = 0.6, age = 10, sex = "male", height = 140)
#' @export
egfr_ckid_u25_cr <- function(creatinine, age, sex, height,
                             creatinine_units = "mg/dl",
                             height_units = "cm",
                             label_sex_male = "male",
                             label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  height_cm <- .egfr_height_to_cm(height, height_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex, height_cm)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]; height_cm <- parts[[4]]

  kappa <- .egfr_ckid_kappa_cr(age, sex, extended = FALSE)
  egfr <- kappa * ((height_cm / 100) / scr)
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKiD U25 extended creatinine eGFR (to age 30)
#'
#' Research extension of [egfr_ckid_u25_cr()] with kappa values that continue
#' to age 30.
#'
#' @inheritParams egfr_ckid_u25_cr
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pierce CB, et al. Kidney Int. 2021;99(4):948-956.
#'   \doi{10.1016/j.kint.2020.10.047}
#' @examples
#' egfr_ckid_u25_cr_extended(creatinine = 1.0, age = 28, sex = "female",
#'                           height = 165)
#' @export
egfr_ckid_u25_cr_extended <- function(creatinine, age, sex, height,
                                      creatinine_units = "mg/dl",
                                      height_units = "cm",
                                      label_sex_male = "male",
                                      label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  height_cm <- .egfr_height_to_cm(height, height_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex, height_cm)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]; height_cm <- parts[[4]]

  kappa <- .egfr_ckid_kappa_cr(age, sex, extended = TRUE)
  egfr <- kappa * ((height_cm / 100) / scr)
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKiD U25 age- and sex-dependent kappa for the cystatin C equation
#' @noRd
.egfr_ckid_kappa_cys <- function(age, sex) {
  female <- ifelse(
    age < 12, 79.9 * 1.004^(age - 12),
    ifelse(age < 18, 79.9 * 0.974^(age - 12), 68.3))
  male <- ifelse(
    age < 15, 87.2 * 1.011^(age - 15),
    ifelse(age < 18, 87.2 * 0.960^(age - 15), 77.1))
  ifelse(sex == "female", female, male)
}

#' CKiD U25 cystatin C eGFR
#'
#' Estimates GFR in children and young adults (ages 1-25) using the CKiD U25
#' cystatin C equation (Pierce et al., 2021).
#'
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @inheritParams egfr_ckdepi_cr_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pierce CB, et al. Kidney Int. 2021;99(4):948-956.
#'   \doi{10.1016/j.kint.2020.10.047}
#' @examples
#' egfr_ckid_u25_cys(cystatin = 0.8, age = 10, sex = "male")
#' @export
egfr_ckid_u25_cys <- function(cystatin, age, sex,
                              label_sex_male = "male",
                              label_sex_female = "female") {
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(cystatin, age, sex)
  cystatin <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  kappa <- .egfr_ckid_kappa_cys(age, sex)
  egfr <- kappa * (1 / cystatin)
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKiD U25 combined creatinine + cystatin C eGFR
#'
#' Arithmetic mean of the CKiD U25 creatinine ([egfr_ckid_u25_cr()]) and
#' cystatin C ([egfr_ckid_u25_cys()]) estimates.
#'
#' @inheritParams egfr_ckid_u25_cr
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Pierce CB, et al. Kidney Int. 2021;99(4):948-956.
#'   \doi{10.1016/j.kint.2020.10.047}
#' @examples
#' egfr_ckid_u25_cr_cys(creatinine = 0.6, cystatin = 0.8, age = 10,
#'                      sex = "male", height = 140)
#' @export
egfr_ckid_u25_cr_cys <- function(creatinine, cystatin, age, sex, height,
                                 creatinine_units = "mg/dl",
                                 height_units = "cm",
                                 label_sex_male = "male",
                                 label_sex_female = "female") {
  cr <- egfr_ckid_u25_cr(creatinine, age, sex, height,
                         creatinine_units = creatinine_units,
                         height_units = height_units,
                         label_sex_male = label_sex_male,
                         label_sex_female = label_sex_female)
  cys <- egfr_ckid_u25_cys(cystatin, age, sex,
                           label_sex_male = label_sex_male,
                           label_sex_female = label_sex_female)
  (cr + cys) / 2
}

#' CAPA paediatric cystatin C eGFR (2014)
#'
#' Estimates GFR from serum cystatin C using the Caucasian, Asian, paediatric,
#' and adult (CAPA) equation (Grubb et al., 2014).
#'
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @param age Numeric vector of age in years.
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Grubb A, Horio M, Hansson LO, et al. Generation of a new
#'   cystatin C-based estimating equation for GFR by use of 7 assays
#'   standardized to the international calibrator. Clin Chem.
#'   2014;60(7):974-986. \doi{10.1373/clinchem.2013.220707}
#' @examples
#' egfr_capa(cystatin = 1.0, age = 12)
#' @export
egfr_capa <- function(cystatin, age) {
  parts <- .egfr_recycle(cystatin, age)
  cystatin <- parts[[1]]; age <- parts[[2]]
  130 * cystatin^(-1.069) * age^(-0.117) - 7
}

#' Neonatal creatinine eGFR (2022)
#'
#' Estimates GFR in term-born neonates using the equation of Smeets et al.
#' (2022). Requires IDMS-standardised creatinine.
#'
#' @inheritParams egfr_schwartz
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Smeets NJL, IntHout J, van der Burgh MJP, et al. SCr- and
#'   cystatin C-based equations to estimate GFR in term-born neonates.
#'   J Am Soc Nephrol. 2022;33(7):1277-1292. \doi{10.1681/ASN.2021111453}
#' @examples
#' egfr_neonatal(creatinine = 0.5, height = 50)
#' @export
egfr_neonatal <- function(creatinine, height,
                          creatinine_units = "mg/dl",
                          height_units = "cm") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  height_cm <- .egfr_height_to_cm(height, height_units)
  parts <- .egfr_recycle(scr, height_cm)
  scr <- parts[[1]]; height_cm <- parts[[2]]
  0.31 * height_cm / scr
}
