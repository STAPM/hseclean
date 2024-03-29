
#' Read the Health Survey for England 2010
#'
#' Reads and does basic cleaning on the Health Survey for England 2010.
#'
#' @section Survey details:
#' The HSE 2010 included a general population sample of adults and children, representative of the whole population at both national and regional level, and a boost sample of children aged
#' 2-15. For the general population sample, 8,736 addresses were randomly selected in 672 postcode sectors, issued over twelve months from January to December 2010. Where an address was found to have multiple dwelling units, one dwelling unit was selected at random
#' and where there were multiple households at a dwelling unit, one household was selected at random.
#'
#' In each selected household, all individuals were eligible for inclusion in the survey. Where there were three or more children aged 0-15 in a household, two of the children were selected at random. A nurse visit was arranged for all participants who consented.
#' In addition to the core general population sample, a boost sample of children aged 2-15 was selected using 17,136 addresses, some in the same postcode sectors as the core sample and some in an additional 168 postcode sectors to supplement the sample obtained in the core sectors. As for the core sample, where there were three or more children in a household, two of the children were selected at random to limit the respondent burden for parents. There was no nurse follow up for this child boost sample.
#'
#' A total of 8,420 adults and 5,692 children were interviewed, with 2,074 children from the core sample and 3,618 from the boost. A household response rate of 66% was achieved for the core sample, and 70% for the boost sample. Among the general population sample,
#' 5,587 adults and 1,327 children had a nurse visit.
#'
#' @section Weighting:
#'
#' Individual weight
#'
#' For analyses at the individual level, the weighting variable to use is (wt_int). These weights are generated separately for adults and children:
#' \itemize{
#' \item for adults (aged 16 or more), the interview weights are a combination of the householdweight and a component which adjusts the sample to reduce bias from individual non-response within households;
#' \item for children (aged 0 to 15), the weights are generated from the household weights and the child selection weights – the selection weights correct for only including a maximum of two children in a household. The combined household and child selection weight were adjusted to ensure that the weighted age/sex distribution matched that of all children in co-operating households.
#' }
#' For analysis of children aged 0-15 in both the Core and the Boost sample, taking into account child selection only and not adjusting for non-response, the (wt_child) variable can be used. For analysis of children aged 2-15 in the only Boost sample the (wt_childb) variable can
#'
#' @section Missing values:
#'
#' \itemize{
#' \item -1 Not applicable: Used to signify that a particular variable did not apply to a given respondent
#' usually because of internal routing. For example, men in women only questions.
#' \item -2 Schedule not applicable: Used mainly for variables on the self-completions when the
#' respondent was not of the given age range, also used for children without legal guardians in the
#' home who could not participate in the nurse schedule.
#' \item -8 Don't know, Can't say.
#' \item -9 No answer/ Refused
#' }
#'
#' @template read-data-description
#'
#' @template read-data-args
#'
#' @importFrom data.table :=
#'
#' @return Returns a data table.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data_2010 <- read_2010("X:/", "ScHARR/PR_Consumption_TA/HSE/HSE 2010/UKDA-6986-tab/tab/hse10ai.tab")
#'
#' }
#'
read_2010 <- function(
    root = c("X:/", "/Volumes/Shared/")[1],
    file = "HAR_PR/PR/Consumption_TA/HSE/Health Survey for England (HSE)/HSE 2010/UKDA-6986-tab/tab/hse10ai.tab",
    select_cols = c("tobalc", "all")[1]
) {

  ##################################################################################
  # General population

  data <- data.table::fread(
    paste0(root, file),
    na.strings = c("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "N/A"))

  data.table::setnames(data, names(data), tolower(names(data)))

  if(select_cols == "tobalc") {

    alc_vars <- colnames(data[ , 520:610])
    smk_vars <- colnames(data[ , c(1376:1489, 1501:1523)])
    health_vars <- paste0("compm", 1:15)

    other_vars <- Hmisc::Cs(
      mintb, addnum,
      psu, cluster, wt_int,
      hserial,pserial,
      age, sex,
      origin,
      imd2007, econact, nssec3, nssec8,
      #econact2,
      paidwk,
      activb, #HHInc,
      children, infants,
      educend, topqual3,
      eqv5, #eqvinc,

      marstatc, # marital status inc cohabitees

      # how much they weigh
      htval, wtval)

    names <- c(other_vars, alc_vars, smk_vars, health_vars)

    names <- tolower(names)

    data <- data[ , names, with = F]

  }

  data.table::setnames(data, c("imd2007", "marstatc", "origin", "pserial"), c("qimd", "marstat", "ethnicity_raw", "hse_id"))

  data[ , psu := paste0("2010_", psu)]
  data[ , cluster := paste0("2010_", cluster)]

  data[ , year := 2010]
  data[ , country := "England"]

  data[ , quarter := c(1:4)[findInterval(mintb, c(1, 4, 7, 10))]]
  data[ , mintb := NULL]

  return(data[])
}








