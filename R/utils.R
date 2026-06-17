#' egfr: Estimated Glomerular Filtration Rate Calculators
#'
#' A vectorised toolkit implementing 20 validated equations for estimating
#' glomerular filtration rate (eGFR) and creatinine clearance from serum
#' creatinine, cystatin C, or both, plus helpers for body surface area,
#' KDIGO CKD staging, and unit conversion.
#'
#' All `egfr_*()` functions are fully vectorised: every numeric argument may be
#' a scalar or a vector. Scalars are recycled against the longest vector.
#' Results are returned unrounded (full precision) in mL/min/1.73m^2, except
#' [egfr_cockcroft_gault()] which returns creatinine clearance in mL/min.
#'
#' @keywords internal
"_PACKAGE"

# ---------------------------------------------------------------------------
# Internal helpers (not exported)
# ---------------------------------------------------------------------------

#' Normalise a sex vector to "male"/"female"
#' @noRd
.egfr_normalize_sex <- function(sex, label_male, label_female) {
  if (is.factor(sex)) sex <- as.character(sex)
  out <- rep(NA_character_, length(sex))
  out[sex %in% label_male] <- "male"
  out[sex %in% label_female] <- "female"
  if (anyNA(out) && !all(is.na(sex))) {
    unmatched <- unique(sex[is.na(out) & !is.na(sex)])
    if (length(unmatched) > 0) {
      warning(
        "Unrecognised sex value(s): ",
        paste(shQuote(unmatched), collapse = ", "),
        ". Returning NA for those records. Adjust 'label_sex_male'/",
        "'label_sex_female' if needed.",
        call. = FALSE
      )
    }
  }
  out
}

#' Convert creatinine to mg/dL
#' @noRd
.egfr_creatinine_to_mgdl <- function(creatinine, units = "mg/dl") {
  units <- tolower(trimws(units))
  if (units %in% c("mg/dl", "mgdl", "mg/dL")) {
    creatinine
  } else if (units %in% c("umol/l", "\u00b5mol/l", "micromol/l", "mcmol/l",
                          "umoll", "umol")) {
    creatinine / 88.4
  } else {
    stop("Unsupported 'creatinine_units': ", shQuote(units),
         ". Use 'mg/dl' or 'umol/l'.", call. = FALSE)
  }
}

#' Convert height to centimetres
#' @noRd
.egfr_height_to_cm <- function(height, units = "cm") {
  units <- tolower(trimws(units))
  if (units == "cm") {
    height
  } else if (units == "m") {
    height * 100
  } else {
    stop("Unsupported 'height_units': ", shQuote(units),
         ". Use 'cm' or 'm'.", call. = FALSE)
  }
}

#' Recycle a set of vectors to a common length
#' @noRd
.egfr_recycle <- function(...) {
  args <- list(...)
  lens <- lengths(args)
  n <- max(lens)
  bad <- lens != 1L & lens != n
  if (any(bad)) {
    stop("All arguments must have length 1 or a common length; got lengths ",
         paste(lens, collapse = ", "), ".", call. = FALSE)
  }
  lapply(args, function(x) if (length(x) == 1L) rep(x, n) else x)
}
