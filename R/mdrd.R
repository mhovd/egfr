#' MDRD 4-variable eGFR (IDMS-standardised)
#'
#' Estimates GFR from serum creatinine using the IDMS-traceable 4-variable
#' MDRD Study equation (Levey et al., 2006). Historical; superseded by
#' CKD-EPI for clinical use.
#'
#' @inheritParams egfr_ckdepi_cr_2009
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Levey AS, Coresh J, Greene T, et al. Using standardized serum
#'   creatinine values in the MDRD study equation. Ann Intern Med.
#'   2006;145(4):247-254. \doi{10.7326/0003-4819-145-4-200608150-00004}
#' @examples
#' egfr_mdrd(creatinine = 1.2, age = 60, sex = "male")
#' @export
egfr_mdrd <- function(creatinine, age, sex,
                      ethnicity = NULL,
                      creatinine_units = "mg/dl",
                      label_sex_male = "male",
                      label_sex_female = "female",
                      label_afroamerican = c("black", "Black")) {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)

  if (is.null(ethnicity)) {
    parts <- .egfr_recycle(scr, age, sex)
    scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]
    raceFactor <- rep(1, length(scr))
  } else {
    parts <- .egfr_recycle(scr, age, sex, ethnicity)
    scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]; ethnicity <- parts[[4]]
    raceFactor <- ifelse(ethnicity %in% label_afroamerican, 1.212, 1.000)
  }

  sexFactor <- ifelse(sex == "female", 0.742, 1.000)
  egfr <- 175 * scr^(-1.154) * age^(-0.203) * sexFactor * raceFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' Cockcroft-Gault creatinine clearance
#'
#' Estimates creatinine clearance (not BSA-normalised eGFR) using the
#' Cockcroft-Gault equation (Cockcroft & Gault, 1976). Commonly used for
#' drug dosing.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @param weight Numeric vector of body weight in kilograms.
#'
#' @return Numeric vector of creatinine clearance in mL/min.
#' @references Cockcroft DW, Gault MH. Prediction of creatinine clearance from
#'   serum creatinine. Nephron. 1976;16(1):31-41. \doi{10.1159/000180580}
#' @examples
#' egfr_cockcroft_gault(creatinine = 1.0, age = 50, sex = "male", weight = 80)
#' @export
egfr_cockcroft_gault <- function(creatinine, age, sex, weight,
                                 creatinine_units = "mg/dl",
                                 label_sex_male = "male",
                                 label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex, weight)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]; weight <- parts[[4]]

  sexFactor <- ifelse(sex == "female", 0.85, 1.00)
  crcl <- ((140 - age) * weight) / (72 * scr) * sexFactor
  crcl[is.na(sex)] <- NA_real_
  crcl
}
