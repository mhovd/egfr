#' Body surface area (BSA)
#'
#' Computes body surface area, used to convert between absolute (mL/min) and
#' BSA-normalised (mL/min/1.73m^2) GFR.
#'
#' @param weight Numeric vector of body weight in kilograms.
#' @param height Numeric vector of height in centimetres.
#' @param method One of `"dubois"` (Du Bois & Du Bois, default), `"haycock"`,
#'   or `"mosteller"`.
#'
#' @return Numeric vector of body surface area in m^2.
#' @references
#' Du Bois D, Du Bois EF. Arch Intern Med. 1916;17:863-871.
#' Haycock GB, et al. J Pediatr. 1978;93(1):62-66.
#' Mosteller RD. N Engl J Med. 1987;317(17):1098.
#' @examples
#' bsa(weight = 80, height = 180)
#' bsa(weight = 20, height = 110, method = "haycock")
#' @export
bsa <- function(weight, height, method = c("dubois", "haycock", "mosteller")) {
  method <- match.arg(method)
  parts <- .egfr_recycle(weight, height)
  weight <- parts[[1]]; height <- parts[[2]]
  switch(method,
    dubois    = 0.007184 * weight^0.425 * height^0.725,
    haycock   = 0.024265 * weight^0.5378 * height^0.3964,
    mosteller = sqrt(weight * height / 3600))
}

#' Normalise or de-normalise GFR using body surface area
#'
#' Converts between absolute creatinine clearance (mL/min) and BSA-normalised
#' GFR (mL/min/1.73m^2).
#'
#' @param gfr Numeric vector of GFR values.
#' @param bsa Numeric vector of body surface area in m^2 (e.g. from [bsa()]).
#' @param to Either `"normalized"` (absolute -> per 1.73m^2, the default) or
#'   `"absolute"` (per 1.73m^2 -> absolute).
#'
#' @return Numeric vector of converted GFR.
#' @examples
#' gfr_bsa_adjust(100, bsa = 2.0, to = "normalized")
#' gfr_bsa_adjust(90, bsa = 2.0, to = "absolute")
#' @export
gfr_bsa_adjust <- function(gfr, bsa, to = c("normalized", "absolute")) {
  to <- match.arg(to)
  parts <- .egfr_recycle(gfr, bsa)
  gfr <- parts[[1]]; bsa <- parts[[2]]
  if (to == "normalized") gfr * (1.73 / bsa) else gfr * (bsa / 1.73)
}

#' KDIGO CKD stage from eGFR
#'
#' Classifies eGFR values into KDIGO GFR categories (G1-G5).
#'
#' @param egfr Numeric vector of eGFR in mL/min/1.73m^2.
#'
#' @return Character vector of GFR categories: `"G1"`, `"G2"`, `"G3a"`,
#'   `"G3b"`, `"G4"`, or `"G5"`.
#' @references Kidney Disease: Improving Global Outcomes (KDIGO) CKD Work
#'   Group. KDIGO 2012 Clinical Practice Guideline. Kidney Int Suppl. 2013.
#' @examples
#' ckd_stage(c(95, 72, 50, 35, 20, 8))
#' @export
ckd_stage <- function(egfr) {
  as.character(cut(
    egfr,
    breaks = c(-Inf, 15, 30, 45, 60, 90, Inf),
    labels = c("G5", "G4", "G3b", "G3a", "G2", "G1"),
    right = FALSE
  ))
}

#' Convert serum creatinine between mg/dL and umol/L
#'
#' @param creatinine Numeric vector of serum creatinine.
#' @param from,to Units, either `"mg/dl"` or `"umol/l"`.
#'
#' @return Numeric vector of converted creatinine.
#' @examples
#' convert_creatinine(88.4, from = "umol/l", to = "mg/dl")
#' convert_creatinine(1.0, from = "mg/dl", to = "umol/l")
#' @export
convert_creatinine <- function(creatinine, from = "mg/dl", to = "umol/l") {
  mgdl <- .egfr_creatinine_to_mgdl(creatinine, from)
  to <- tolower(trimws(to))
  if (to %in% c("mg/dl", "mgdl")) {
    mgdl
  } else if (to %in% c("umol/l", "\u00b5mol/l", "micromol/l", "mcmol/l")) {
    mgdl * 88.4
  } else {
    stop("Unsupported 'to' units: ", shQuote(to),
         ". Use 'mg/dl' or 'umol/l'.", call. = FALSE)
  }
}
