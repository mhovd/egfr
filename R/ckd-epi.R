#' CKD-EPI 2021 creatinine eGFR (race-free)
#'
#' Estimates GFR from serum creatinine using the race-free CKD-EPI 2021
#' creatinine equation (Inker et al., 2021). This is the equation recommended
#' for adults (>= 18 years) by current US guidelines.
#'
#' @param creatinine Numeric vector of serum creatinine.
#' @param age Numeric vector of age in years.
#' @param sex Vector of sex labels (see `label_sex_male`/`label_sex_female`).
#' @param creatinine_units Units of `creatinine`: `"mg/dl"` (default) or
#'   `"umol/l"`.
#' @param label_sex_male,label_sex_female Values in `sex` that denote male and
#'   female records. Defaults to `"male"`/`"female"`.
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Inker LA, Eneanya ND, Coresh J, et al. New creatinine- and
#'   cystatin C-based equations to estimate GFR without race.
#'   N Engl J Med. 2021;385(19):1737-1749. \doi{10.1056/NEJMoa2102953}
#' @examples
#' egfr_ckdepi_cr_2021(creatinine = 1.0, age = 50, sex = "female")
#' egfr_ckdepi_cr_2021(c(0.8, 1.2), c(40, 65), c("female", "male"))
#' @export
egfr_ckdepi_cr_2021 <- function(creatinine, age, sex,
                                creatinine_units = "mg/dl",
                                label_sex_male = "male",
                                label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, age, sex)
  scr <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  kappa     <- ifelse(sex == "female", 0.7, 0.9)
  alpha     <- ifelse(sex == "female", -0.241, -0.302)
  sexFactor <- ifelse(sex == "female", 1.012, 1.000)

  ratio <- scr / kappa
  egfr <- 142 *
    pmin(ratio, 1)^alpha *
    pmax(ratio, 1)^(-1.200) *
    0.9938^age *
    sexFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKD-EPI 2021 cystatin C eGFR (race-free)
#'
#' Estimates GFR from serum cystatin C using the race-free CKD-EPI 2021
#' cystatin C equation (Inker et al., 2021). The identical formula was first
#' published in 2012; see [egfr_ckdepi_cys_2012()].
#'
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#' @inheritParams egfr_ckdepi_cr_2021
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Inker LA, Eneanya ND, Coresh J, et al. N Engl J Med.
#'   2021;385(19):1737-1749. \doi{10.1056/NEJMoa2102953}
#' @examples
#' egfr_ckdepi_cys_2021(cystatin = 0.9, age = 55, sex = "male")
#' @export
egfr_ckdepi_cys_2021 <- function(cystatin, age, sex,
                                 label_sex_male = "male",
                                 label_sex_female = "female") {
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(cystatin, age, sex)
  cystatin <- parts[[1]]; age <- parts[[2]]; sex <- parts[[3]]

  sexFactor <- ifelse(sex == "female", 0.932, 1.000)
  ratio <- cystatin / 0.8
  egfr <- 133 *
    pmin(ratio, 1)^(-0.499) *
    pmax(ratio, 1)^(-1.328) *
    0.9962^age *
    sexFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKD-EPI 2012 cystatin C eGFR
#'
#' Estimates GFR from serum cystatin C using the CKD-EPI 2012 cystatin C
#' equation (Inker et al., 2012). The formula is identical to the race-free
#' 2021 cystatin C equation and is retained for backward compatibility.
#'
#' @inheritParams egfr_ckdepi_cys_2021
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Inker LA, Schmid CH, Tighiouart H, et al. Estimating GFR from
#'   serum creatinine and cystatin C. N Engl J Med. 2012;367(1):20-29.
#'   \doi{10.1056/NEJMoa1114248}
#' @examples
#' egfr_ckdepi_cys_2012(cystatin = 0.9, age = 55, sex = "male")
#' @export
egfr_ckdepi_cys_2012 <- function(cystatin, age, sex,
                                 label_sex_male = "male",
                                 label_sex_female = "female") {
  egfr_ckdepi_cys_2021(cystatin, age, sex,
                       label_sex_male = label_sex_male,
                       label_sex_female = label_sex_female)
}

#' CKD-EPI 2021 combined creatinine + cystatin C eGFR (race-free)
#'
#' Estimates GFR using both serum creatinine and cystatin C with the race-free
#' CKD-EPI 2021 combined equation (Inker et al., 2021). This is the most
#' accurate of the CKD-EPI equations when both biomarkers are available.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @param cystatin Numeric vector of serum cystatin C in mg/L.
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Inker LA, Eneanya ND, Coresh J, et al. N Engl J Med.
#'   2021;385(19):1737-1749. \doi{10.1056/NEJMoa2102953}
#' @examples
#' egfr_ckdepi_cr_cys_2021(creatinine = 1.0, cystatin = 0.9,
#'                         age = 50, sex = "female")
#' @export
egfr_ckdepi_cr_cys_2021 <- function(creatinine, cystatin, age, sex,
                                    creatinine_units = "mg/dl",
                                    label_sex_male = "male",
                                    label_sex_female = "female") {
  scr <- .egfr_creatinine_to_mgdl(creatinine, creatinine_units)
  sex <- .egfr_normalize_sex(sex, label_sex_male, label_sex_female)
  parts <- .egfr_recycle(scr, cystatin, age, sex)
  scr <- parts[[1]]; cystatin <- parts[[2]]; age <- parts[[3]]; sex <- parts[[4]]

  kappa     <- ifelse(sex == "female", 0.7, 0.9)
  alpha     <- ifelse(sex == "female", -0.219, -0.144)
  sexFactor <- ifelse(sex == "female", 0.963, 1.000)

  crRatio  <- scr / kappa
  cysRatio <- cystatin / 0.8
  egfr <- 135 *
    pmin(crRatio, 1)^alpha *
    pmax(crRatio, 1)^(-0.544) *
    pmin(cysRatio, 1)^(-0.323) *
    pmax(cysRatio, 1)^(-0.778) *
    0.9961^age *
    sexFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}

#' CKD-EPI 2009 creatinine eGFR (with race coefficient)
#'
#' Estimates GFR from serum creatinine using the original CKD-EPI 2009
#' creatinine equation (Levey et al., 2009), which includes a race
#' coefficient. Retained for historical comparison; the race-free
#' [egfr_ckdepi_cr_2021()] is now recommended.
#'
#' @inheritParams egfr_ckdepi_cr_2021
#' @param ethnicity Optional vector of ethnicity labels. Records matching
#'   `label_afroamerican` receive the Black race coefficient (1.159); all
#'   others receive 1.0. If `NULL` (default) no race coefficient is applied.
#' @param label_afroamerican Values in `ethnicity` denoting Black/African
#'   American race. Defaults to `c("black", "Black")`.
#'
#' @return Numeric vector of eGFR in mL/min/1.73m^2.
#' @references Levey AS, Stevens LA, Schmid CH, et al. A new equation to
#'   estimate glomerular filtration rate. Ann Intern Med.
#'   2009;150(9):604-612. \doi{10.7326/0003-4819-150-9-200905050-00006}
#' @examples
#' egfr_ckdepi_cr_2009(creatinine = 1.0, age = 50, sex = "female")
#' egfr_ckdepi_cr_2009(1.0, 50, "female",
#'                     ethnicity = "black", label_afroamerican = "black")
#' @export
egfr_ckdepi_cr_2009 <- function(creatinine, age, sex,
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
    raceFactor <- ifelse(ethnicity %in% label_afroamerican, 1.159, 1.000)
  }

  kappa     <- ifelse(sex == "female", 0.7, 0.9)
  alpha     <- ifelse(sex == "female", -0.329, -0.411)
  sexFactor <- ifelse(sex == "female", 1.018, 1.000)

  ratio <- scr / kappa
  egfr <- 141 *
    pmin(ratio, 1)^alpha *
    pmax(ratio, 1)^(-1.209) *
    0.993^age *
    sexFactor *
    raceFactor
  egfr[is.na(sex)] <- NA_real_
  egfr
}
