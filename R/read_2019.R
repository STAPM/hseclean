
#' Read HSE 2019
#'
#' Reads and does basic cleaning on the Health Survey for England 2019.
#'
#'
#' @param root Character - the root directory.
#' @param file Character - the file path and name.
#' @importFrom data.table :=
#' @return Returns a data table. Note that:
#' \itemize{
#' \item Missing data ("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "-99", "N/A") is replaced with NA.
#' \item All variable names are converted to lower case.
#' \item The cluster and probabilistic sampling unit have the year appended to them.
#' }
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data_2019 <- read_2019("X:/",
#' "ScHARR/PR_Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2019/hse_2019_eul_20211006.tab")
#'
#' }
#'
read_2019 <- function(
  root = c("X:/", "/Volumes/Shared/"),
  file = "ScHARR/PR_Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2019/hse_2019_eul_20211006.tab"
) {

  ##################################################################################
  # General population

  data <- data.table::fread(
    paste0(root[1], file),
    na.strings = c("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "-99", "N/A")
  )

  data.table::setnames(data, names(data), tolower(names(data)))

  alc_vars <- colnames(data[ , c(53:56, 67:70, 1081:1196, 1365:1438, 1479:1504)]) # done 2019
  smk_vars <- colnames(data[ , c(24, 25, 49, 64, 75, 76, 655:804, 1057:1096)]) # needs review from here
  health_vars <- paste0("complst", 1:15)

  other_vars <- Hmisc::Cs(
    qrtint, #addnum,
    psu_scr, cluster195, wt_int, #wt_sc,
    seriala,
    age16g5, age35g, sex,
    origin2,
    qimd, nssec3, nssec8,
    stwork,
    activb2,
    #Ag015g4, #Children, Infants,
    educend, topqual3,
    eqv5, #eqvinc,

    marstatd, # marital status inc cohabitees

    # how much they weigh
    htval, wtval)

  names <- c(other_vars, alc_vars, smk_vars, health_vars)

  names <- tolower(names)

  data <- data[ , names, with = F]

  data.table::setnames(data,
           c("cluster195", "psu_scr", "qrtint", "marstatd", "origin2", "activb2", "stwork","seriala", paste0("complst", 1:15)),
           c("cluster", "psu", "quarter", "marstat", "ethnicity_raw", "activb", "paidwk","hse_id", paste0("compm", 1:15)))

  data[ , psu := paste0("2019_", psu)]
  data[ , cluster := paste0("2019_", cluster)]

  data[ , year := 2019]
  data[ , country := "England"]

return(data[])
}


