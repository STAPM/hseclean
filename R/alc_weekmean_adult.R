
#' Alcohol average weekly consumption (adults)
#'
#' We estimate the number of
#' UK standard units of alcohol drunk on average in a week from the questions on drinking in the last 12 months.
#'
#' The calculation has the following steps:
#' \itemize{
#' \item Convert the categorical variables to numeric variables for the frequency with which each beverage is typically consumed (normal beer, strong beer, spirits, sherry, wine, alcopops).
#' \item Convert the reported volumes usually consumed (e.g. small glass, large glass) into volumes in ml, using the beverage size assumptions above. In doing so, variations in recording among years and between the interview and self-complete questionnaire are accounted for.
#' \item Combine the volumes (ml) usually consumed with the frequency of consumption to give the average volume of each beverage type drunk each week (assuming constant consumption across the year).
#' \item Convert the expected volumes of each beverage consumed each week to UK standard units of alcohol consumed, using the alcohol content assumptions above.
#' \item Collapse normal and strong beer into a single "beer" variable by summing their units. Collapse wine and sherry into a single "wine" variable by summing their units.
#' \item Calculate total weekly units but summing across beverage categories.
#' \item Calculate the beverage "preference vector" - the percentage of total consumption contributed by the consumption of each of four beverage types (beer, wine, spirits, alcopops).
#' \item Cap the total units consumed in a week at 300 units, assuming that above this already very high level of consumption estimates of variation in consumption are less reliable.
#' \item Categorise average weekly consumption into "abstainer", "lower_risk" (less than 14 units/week), "increasing_risk" (greater than or equal to 14 units/week and less than 35 units/week for women, and less than 50 units/week for men), "higher_risk".
#' \item Categorise beverage preferences - for each of the four beverages, "does_not_drink", "drinks_some" (less than or equal to 50\% of consumption), "mostly_drinks".
#' }
#' In 2007 new questions were added asking which glass size was used when wine was consumed.
#' Therefore the post HSE 2007 unit calculations are not directly comparable to previous years' data.
#'
#' @param data Data table - the health survey dataset
#' @param abv_data Data table - our assumptions on the alcohol content of different beverages in (percent units / ml)
#' @param volume_data Data table - our assumptions on the volume of different drinks (ml).
#'
#' @importFrom data.table := setnames
#'
#' @return
#' \itemize{
#' \item beer_units - average weekly units of beer
#' \item wine_units - average weekly units of wine
#' \item spirit_units - average weekly units of spirits
#' \item rtd_units - average weekly units of alcopops
#' \item weekmean - total average weekly units
#' \item perc_spirit_units - percentage of consumption that is spirits
#' \item perc_wine_units - percentage of consumption that is wine
#' \item perc_rtd_units - percentage of consumption that is alcopops
#' \item perc_beer_units - percentage of consumption that is beer
#' \item drinker_cat - categories of average weekly consumption
#' \item spirits_pref_cat - whether doesn't drink, drinks some or mostly drinks spirits
#' \item wine_pref_cat - whether doesn't drink, drinks some or mostly drinks wine
#' \item rtd_pref_cat - whether doesn't drink, drinks some or mostly drinks alcopops
#' \item beer_pref_cat - whether doesn't drink, drinks some or mostly drinks beer
#' }
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data <- read_2016()
#' data <- clean_age(data)
#' data <- clean_demographic(data)
#' data <- alc_drink_now(data)
#' data <- alc_sevenday(data)
#' data <- alc_weekmean(data)
#'
#' }
#'
alc_weekmean_adult <- function(
    data,
    abv_data = hseclean::abv_data,
    volume_data = hseclean::alc_volume_data
) {

  # Check that drinks_now variable is in the data
  if(sum(colnames(data) == "drinks_now") == 0) {
    message("missing drinks_now variable - run alc_drink_now_allages() first.")
  }

  year <- as.integer(unique(data[ , year][1]))
  country <- unique(data[ , country][1])

  year_set1 <- 2001:2002
  year_set2 <- 2011:2018
  year_set3 <- 2016:2019 ## for Welsh data

  #################################################################
  # Frequency of drinking in days per week

  if(year > 2019 & country == "Wales"){

    data[cvdnoftbr == 1 & dnoftbrfreqwk == 1, nbeer := 1]
    data[cvdnoftbr == 1 & dnoftbrfreqwk == 2, nbeer := 2]
    data[cvdnoftbr == 1 & dnoftbrfreqwk == 3, nbeer := 3]
    data[cvdnoftbr == 1 & dnoftbrfreqwk == 4, nbeer := 4]
    data[cvdnoftbr == 2 , nbeer := 5]
    data[cvdnoftbr == 3 , nbeer := 6]
    data[cvdnoftbr == 4 , nbeer := 7]

    data[ , `:=`(cvdnoftbr = NULL,  dnoftbrfreqwk = NULL)]

    data[cvdnoftwine == 1 & dnoftwinefreqwk == 1, wine := 1]
    data[cvdnoftwine == 1 & dnoftwinefreqwk == 2, wine := 2]
    data[cvdnoftwine == 1 & dnoftwinefreqwk == 3, wine := 3]
    data[cvdnoftwine == 1 & dnoftwinefreqwk == 4, wine := 4]
    data[cvdnoftwine == 2 , wine := 5]
    data[cvdnoftwine == 3 , wine := 6]
    data[cvdnoftwine == 4 , wine := 7]

    data[ , `:=`(cvdnoftwine = NULL,  dnoftwinefreqwk = NULL)]

    data[cvdnoftspir == 1 & dnoftspirfreqwk == 1, spirits := 1]
    data[cvdnoftspir == 1 & dnoftspirfreqwk == 2, spirits := 2]
    data[cvdnoftspir == 1 & dnoftspirfreqwk == 3, spirits := 3]
    data[cvdnoftspir == 1 & dnoftspirfreqwk == 4, spirits := 4]
    data[cvdnoftspir == 2 , spirits := 5]
    data[cvdnoftspir == 3 , spirits := 6]
    data[cvdnoftspir == 4 , spirits := 7]

    data[ , `:=`(cvdnoftspir = NULL,  dnoftspirfreqwk = NULL)]


    ## strong beer, sherry, and alcopops not in post 2019-20 NSW data
    data[, sbeer := NA]
    data[, sherry := NA]
    data[, pops := NA]

  }

  # interview questions
  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    #Pos. = 1,341	Variable = NBeer	Variable label = How often drunk normal strength beer in past year (CAPI)
    #Value = 1.0	Label = Almost every day
    #Value = 2.0	Label = Five or six days a week
    #Value = 3.0	Label = Three or four days a week
    #Value = 4.0	Label = Once or twice a week
    #Value = 5.0	Label = Once or twice a month
    #Value = 6.0	Label = Once every couple of months
    #Value = 7.0	Label = Once or twice a year
    #Value = 8.0	Label = Not at all in the last 12 months
    #Value = -2.0	Label = Schedule not applicable
    #Value = -9.0	Label = Refused
    #Value = -8.0	Label = Don't know
    #Value = -6.0	Label = Schedule not obtained
    #Value = -1.0	Label = Not applicable

    data[ , nbeer := hseclean::alc_drink_freq(nbeer)] # normal beer
    data[ , sbeer := hseclean::alc_drink_freq(sbeer)] # strong beer
    data[ , spirits := hseclean::alc_drink_freq(spirits)] # spirits
    data[ , sherry := hseclean::alc_drink_freq(sherry)] # sherry
    data[ , wine := hseclean::alc_drink_freq(wine)] # wine
    data[ , pops := hseclean::alc_drink_freq(pops)] # alcopops

  }

  # Self completion questions (younger adults)
  if((year %in% year_set2 & country == "England") | country == "Scotland") {

    setnames(data, "scspirit", "scspirits")

    #Pos. = 1,992	Variable = DSpirits	Variable label = Frequency drank spirits in last 12 months (SC)
    #Value = 1.0	Label = Almost every day
    #Value = 2.0	Label = 5 or 6 days a week
    #Value = 3.0	Label = 3 or 4 days a week
    #Value = 4.0	Label = Once/twice a week
    #Value = 5.0	Label = Once/twice a month
    #Value = 6.0	Label = Once every couple of months
    #Value = 7.0	Label = Once/twice in last 12 months
    #Value = 8.0	Label = Never in last 12 months
    #Value = -2.0	Label = Schedule not applicable
    #Value = -9.0	Label = Refused
    #Value = -8.0	Label = Don't know
    #Value = -6.0	Label = Schedule not obtained
    #Value = -1.0	Label = Not applicable

    data[ , scnbeer := hseclean::alc_drink_freq(scnbeer)] # normal beer
    data[ , scsbeer := hseclean::alc_drink_freq(scsbeer)] # strong beer
    data[ , scspirits := hseclean::alc_drink_freq(scspirits)] # spirits
    data[ , scsherry := hseclean::alc_drink_freq(scsherry)] # sherry
    data[ , scwine := hseclean::alc_drink_freq(scwine)] # wine
    data[ , scpops := hseclean::alc_drink_freq(scpops)] # alcopops

  }


  #################################################################
  # Amount usually drunk

  # Convert volumes to natural volumes

  #################################
  # Normal beer

  # vol_nbeer - volume in ml

  # nbeerm1 - Quantity of normal beer drunk in past year: Half pints (CAPI)
  # nbeerq1 - Amount of normal beer drunk on one day (half pints) (CAPI)

  # nbeerm2 - Quantity of normal beer drunk in past year: Small cans (CAPI)
  # nbeerq2 - Amount of normal beer drunk on one day (small cans) (CAPI)

  # nbeerm3 - Quantity of normal beer drunk in past year: Large cans (CAPI)
  # nbeerq3 - Amount of normal beer drunk on one day (large cans) (CAPI)

  # nbeerm4 - Quantity of normal beer drunk in past year: Bottles (CAPI)
  # nbeerq4 - Amount of normal beer drunk on one day (bottles) (CAPI)

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    # if nbeerm1 == 1 then normal beer was mentioned as a beverage that was consumed

    # if no data, then assume consumption of that beverage is zero
    data[ , vol_nbeer := 0]

    # if data, then multiply the quantity consumed by the assumed volume in ml associated with serving size mentioned

    # half pints
    ## NSW recorded in pints rather than half-pints after 2019-20
    if(country == "Wales" & year > 2019){
    data[nbeerm1 == 1 & !is.na(nbeerq1) & nbeerq1 > 0, vol_nbeer := nbeerq1 * 2 * volume_data[beverage == "nbeerhalfvol", volume]]
    } else {
    data[nbeerm1 == 1 & !is.na(nbeerq1) & nbeerq1 > 0, vol_nbeer := nbeerq1 * volume_data[beverage == "nbeerhalfvol", volume]]
    }
    # small cans
    data[nbeerm2 == 1 & !is.na(nbeerq2) & nbeerq2 > 0, vol_nbeer := vol_nbeer + nbeerq2 * volume_data[beverage == "nbeerscanvol", volume]]

    # large cans
    data[nbeerm3 == 1 & !is.na(nbeerq3) & nbeerq3 > 0, vol_nbeer := vol_nbeer + nbeerq3 * volume_data[beverage == "nbeerlcanvol", volume]]

    # bottles
    data[nbeerm4 == 1 & !is.na(nbeerq4) & nbeerq4 > 0, vol_nbeer := vol_nbeer + nbeerq4 * volume_data[beverage == "nbeerbtlvol", volume]]

    # if the respondent specifically answered "dont't know" to the question on amount drunk,
    # then class this as missing data that might subsequently be imputed
    data[nbeerm1 == 1 & nbeerq1 == -8, vol_nbeer := NA]
    data[nbeerm2 == 1 & nbeerq2 == -8, vol_nbeer := NA]
    data[nbeerm3 == 1 & nbeerq3 == -8, vol_nbeer := NA]
    data[nbeerm4 == 1 & nbeerq4 == -8, vol_nbeer := NA]

    data[ , `:=` (nbeerm1 = NULL, nbeerm2 = NULL, nbeerm3 = NULL, nbeerm4 = NULL, nbeerq1 = NULL, nbeerq2 = NULL, nbeerq3 = NULL, nbeerq4 = NULL)]

  }


  # for England in some early years, a different quantity measure is used

  if(year %in% year_set1 & country == "England") {

    data[!is.na(nbeerq5) & nbeerq5 > 0, vol_nbeer := vol_nbeer + nbeerq5 * 2 * volume_data[beverage == "nbeerhalfvol", volume]]

    data[ , nbeerq5 := NULL]

  }

  #################################
  # Strong beer

  # follows same scheme as normal beer

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    data[ , vol_sbeer := 0]

    ## NSW doesn't have strong beer after 2019-20
    if(!(country == "Wales" & year > 2019)){
    data[sbeerm1 == 1 & !is.na(sbeerq1) & sbeerq1 > 0, vol_sbeer := sbeerq1 * volume_data[beverage == "sbeerhalfvol", volume]]
    data[sbeerm2 == 1 & !is.na(sbeerq2) & sbeerq2 > 0, vol_sbeer := vol_sbeer + sbeerq2 * volume_data[beverage == "sbeerscanvol", volume]]
    data[sbeerm3 == 1 & !is.na(sbeerq3) & sbeerq3 > 0, vol_sbeer := vol_sbeer + sbeerq3 * volume_data[beverage == "sbeerlcanvol", volume]]
    data[sbeerm4 == 1 & !is.na(sbeerq4) & sbeerq4 > 0, vol_sbeer := vol_sbeer + sbeerq4 * volume_data[beverage == "sbeerbtlvol", volume]]

    data[sbeerm1 == 1 & sbeerq1 == -8, vol_sbeer := NA]
    data[sbeerm2 == 1 & sbeerq2 == -8, vol_sbeer := NA]
    data[sbeerm3 == 1 & sbeerq3 == -8, vol_sbeer := NA]
    data[sbeerm4 == 1 & sbeerq4 == -8, vol_sbeer := NA]

    data[ , `:=` (sbeerm1 = NULL, sbeerm2 = NULL, sbeerm3 = NULL, sbeerm4 = NULL, sbeerq1 = NULL, sbeerq2 = NULL, sbeerq3 = NULL, sbeerq4 = NULL)]
    }

  }

  # for England in some early years, a different quantity measure is used

  if(year %in% year_set1 & country == "England") {

    data[!is.na(sbeerq5) & sbeerq5 > 0, vol_sbeer := vol_sbeer + sbeerq5 * 2 * volume_data[beverage == "sbeerhalfvol", volume]]

    data[ , sbeerq5 := NULL]

  }

  # Wine

  # If variables are not present, create them with NA so code works

  # For years 2001-2006, assume wine measured in number of 125ml glasses
  if(year %in% year_set1 & country == "England") {

    data[ , vol_wine := 0]

    data[!is.na(wineqgs) & wineqgs > 0, vol_wine := wineqgs * alc_volume_data[beverage == "winesglassvol", volume]]

    data[ , wineqgs := NULL]

  }

  if(year %in% year_set2 & country == "England" | country == "Wales") {

    data[ , vol_wine := 0]
    data[bwineq2 == 1 & !is.na(wineq) & wineq > 0, vol_wine := wineq * volume_data[beverage == "winesglassvol", volume]]
    data[bwineq2 == 2 & !is.na(wineq) & wineq > 0, vol_wine := vol_wine + wineq * volume_data[beverage == "wineglassvol", volume]]
    data[bwineq2 == 3 & !is.na(wineq) & wineq > 0, vol_wine := vol_wine + wineq * volume_data[beverage == "winelglassvol", volume]]
    data[bwineq2 == 4 & !is.na(wineq) & wineq > 0, vol_wine := vol_wine + wineq * volume_data[beverage == "winebtlvol", volume]]

    data[ , `:=` (bwineq2 = NULL, wineq = NULL)]
  }


  if(country == "Scotland") {

    # wqglz1 - Whether usually drank wine from 250 ml glasses (CAPI)
    # wqglz2 - Whether usually drank wine from 175 ml glasses (CAPI)
    # wqglz3 - Whether usually drank wine from 125 ml glasses (CAPI)

    # q250glz - Number of large glasses (250ml) of wine usually drunk (CAPI)
    # q175glz - Number of standard glasses (175ml) of wine usually drunk (CAPI)
    # q125glz - Number of small glasses (125ml) of wine usually drunk (CAPI)

    data[ , vol_wine := 0]
    data[wqglz1 == 1 & !is.na(q250glz) & q250glz > 0, vol_wine := q250glz * volume_data[beverage == "winelglassvol", volume]]
    data[wqglz2 == 1 & !is.na(q175glz) & q175glz > 0, vol_wine := vol_wine + q175glz * volume_data[beverage == "wineglassvol", volume]]
    data[wqglz3 == 1 & !is.na(q125glz) & q125glz > 0, vol_wine := vol_wine + q125glz * volume_data[beverage == "winesglassvol", volume]]
    # if measure used is both bottles and glasses or just bottle
    data[wineq %in% c(1, 3) & !is.na(wqbt) & wqbt > 0, vol_wine := vol_wine + wqbt * volume_data[beverage == "winesglassvol", volume]]


    data[ , `:=` (wqglz1 = NULL, wqglz2 = NULL, wqglz3 = NULL, q250glz = NULL, q175glz = NULL, q125glz = NULL)]
  }

  # Fortified wine (Sherry)

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    data[ , vol_sherry := 0]

    ## NSW doesn't have sherry after 2019-20
    if(!(country == "Wales" & year > 2019)){
    data[!is.na(sherryq) & sherryq > 0, vol_sherry := sherryq * volume_data[beverage == "sherryvol", volume]]

    data[ , sherryq := NULL]
    }

  }

  # Spirits

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    data[ , vol_spirits := 0]

    data[!is.na(spiritsq) & spiritsq > 0, vol_spirits := spiritsq * volume_data[beverage == "spiritsvol", volume]]

    data[ , spiritsq := NULL]

  }

  # RTDs

  if(year %in% year_set1 & country == "England") {

    data[ , vol_pops := 0]

    data[!is.na(popsqsm) & popsqsm > 0, vol_pops := popsqsm * alc_volume_data[beverage == "popsscvol", volume]]

    data[ , popsqsm := NULL]

  }

  if(year %in% year_set2 | country %in% c("Scotland","Wales")) {

    data[ , vol_pops := 0]

    ## NSW doesn't have strong beer after 2019-20
    if(!(country == "Wales" & year > 2019)){
    data[popsly11 == 1 & !is.na(popsq111) & popsq111 > 0, vol_pops := popsq111 * volume_data[beverage == "popsscvol", volume]]
    data[popsly12 == 1 & !is.na(popsq112) & popsq112 > 0, vol_pops := vol_pops + popsq112 * volume_data[beverage == "popssbvol", volume]]
    data[popsly13 == 1 & !is.na(popsq113) & popsq113 > 0, vol_pops := vol_pops + popsq113 * volume_data[beverage == "popslbvol", volume]]

    data[popsly11 == 1 & popsq111 == -8, vol_pops := NA]
    data[popsly12 == 1 & popsq112 == -8, vol_pops := NA]
    data[popsly13 == 1 & popsq113 == -8, vol_pops := NA]

    data[ , `:=` (popsly11 = NULL, popsly12 = NULL, popsly13 = NULL, popsq111 = NULL, popsq112 = NULL, popsq113 = NULL)]
    }
  }

  ##
  # Repeat with self-complete questions

  if((year %in% year_set2 & country == "England") | country == "Scotland") {

    # Normal beer
    data[ , vol_scnbeer := 0]
    data[!is.na(scnbeeq1) & scnbeeq1 > 0, vol_scnbeer := scnbeeq1 * volume_data[beverage == "nbeerhalfvol", volume] * 2]
    data[!is.na(scnbeeq2) & scnbeeq2 > 0, vol_scnbeer := vol_scnbeer + scnbeeq2 * volume_data[beverage == "nbeerscanvol", volume]]
    data[!is.na(scnbeeq3) & scnbeeq3 > 0, vol_scnbeer := vol_scnbeer + scnbeeq3 * volume_data[beverage == "nbeerlcanvol", volume]]

    data[scnbeeq1 == -8, vol_scnbeer := NA]
    data[scnbeeq2 == -8, vol_scnbeer := NA]
    data[scnbeeq3 == -8, vol_scnbeer := NA]

    data[ , `:=` (scnbeeq1 = NULL, scnbeeq2 = NULL, scnbeeq3 = NULL)]


    # Strong beer
    data[ , vol_scsbeer := 0]
    data[!is.na(scsbeeq1) & scsbeeq1 > 0, vol_scsbeer := scsbeeq1 * volume_data[beverage == "sbeerhalfvol", volume] * 2]
    data[!is.na(scsbeeq2) & scsbeeq2 > 0, vol_scsbeer := vol_scsbeer + scsbeeq2 * volume_data[beverage == "sbeerscanvol", volume]]
    data[!is.na(scsbeeq3) & scsbeeq3 > 0, vol_scsbeer := vol_scsbeer + scsbeeq3 * volume_data[beverage == "sbeerlcanvol", volume]]

    data[scsbeeq1 == -8, vol_scsbeer := NA]
    data[scsbeeq2 == -8, vol_scsbeer := NA]
    data[scsbeeq3 == -8, vol_scsbeer := NA]

    data[ , `:=` (scsbeeq1 = NULL, scsbeeq2 = NULL, scsbeeq3 = NULL)]


    # Wine
    data[ , vol_scwine := 0]
    data[!is.na(scwineq1) & scwineq1 > 0, vol_scwine := scwineq1 * volume_data[beverage == "winesglassvol", volume]]
    data[!is.na(scwineq2) & scwineq2 > 0, vol_scwine := vol_scwine + scwineq2 * volume_data[beverage == "wineglassvol", volume]]
    data[!is.na(scwineq3) & scwineq3 > 0, vol_scwine := vol_scwine + scwineq3 * volume_data[beverage == "winelglassvol", volume]]
    data[!is.na(scwineq4) & scwineq4 > 0, vol_scwine := vol_scwine + scwineq4 * volume_data[beverage == "winebtlvol", volume]]

    data[scwineq1 == -8, vol_scwine := NA]
    data[scwineq2 == -8, vol_scwine := NA]
    data[scwineq3 == -8, vol_scwine := NA]
    data[scwineq4 == -8, vol_scwine := NA]

    #data[ , `:=` (scwineq1 = NULL, scwineq2 = NULL, scwineq3 = NULL, scwineq4 = NULL)]


    # Fortified wine (Sherry)
    data[ , vol_scsherry := 0]
    data[!is.na(scsherrq) & scsherrq > 0, vol_scsherry := scsherrq * volume_data[beverage == "sherryvol", volume]]

    data[scsherrq == -8, vol_scsherry := NA]

    #data[ , scsherrq := NULL]


    # Spirits
    data[ , vol_scspirits := 0]
    data[!is.na(scspirq) & scspirq > 0, vol_scspirits := scspirq * volume_data[beverage == "spiritsvol", volume]]

    data[scspirq == -8, vol_scspirits := NA]

    data[ , scspirq := NULL]


    # RTDs
    data[ , vol_scpops := 0]
    data[!is.na(scpopsq1) & scpopsq1 > 0, vol_scpops := scpopsq1 * volume_data[beverage == "popslbvol", volume]]
    data[!is.na(scpopsq2) & scpopsq2 > 0, vol_scpops := vol_scpops + scpopsq2 * volume_data[beverage == "popssbvol", volume]]
    data[!is.na(scpopsq3) & scpopsq3 > 0, vol_scpops := vol_scpops + scpopsq3 * volume_data[beverage == "popsscvol", volume]]

    data[scpopsq1 == -8, vol_scpops := NA]
    data[scpopsq2 == -8, vol_scpops := NA]
    data[scpopsq3 == -8, vol_scpops := NA]

    data[ , `:=`(scpopsq1 = NULL, scpopsq2 = NULL, scpopsq3 = NULL)]

  }

  #################################################################
  # Combine amount usually drunk with frequencies to get natural volumes per week

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    data[ , vol_nbeer := vol_nbeer * nbeer]
    data[ , vol_sbeer := vol_sbeer * sbeer]
    data[ , vol_spirits := vol_spirits * spirits]
    data[ , vol_sherry := vol_sherry * sherry]
    data[ , vol_wine := vol_wine * wine]
    data[ , vol_pops := vol_pops * pops]

    #data[ , `:=`(nbeer = NULL, sbeer = NULL, spirits = NULL, sherry = NULL, wine = NULL, pops = NULL)]

  }

  if((year %in% c(year_set2) & country == "England") | country == "Scotland") {

    data[ , vol_scnbeer := vol_scnbeer * scnbeer]
    data[ , vol_scsbeer := vol_scsbeer * scsbeer]
    data[ , vol_scspirits := vol_scspirits * scspirits]
    data[ , vol_scsherry := vol_scsherry * scsherry]
    data[ , vol_scwine := vol_scwine * scwine]
    data[ , vol_scpops := vol_scpops * scpops]


    #data[ , `:=`(scnbeer = NULL, scsbeer = NULL, scspirits = NULL, scsherry = NULL, scwine = NULL, scpops = NULL)]


    #################################################################
    # Merge interview data with self complete data

    data[is.na(vol_nbeer) | vol_nbeer == 0, vol_nbeer := vol_scnbeer]
    data[is.na(vol_sbeer) | vol_sbeer == 0, vol_sbeer := vol_scsbeer]
    data[is.na(vol_spirits) | vol_spirits == 0, vol_spirits := vol_scspirits]
    data[is.na(vol_sherry) | vol_sherry == 0, vol_sherry := vol_scsherry]
    data[is.na(vol_wine) | vol_wine == 0, vol_wine := vol_scwine]
    data[is.na(vol_pops) | vol_pops == 0, vol_pops := vol_scpops]

    #data[ , `:=`(vol_scnbeer = NULL, vol_scsbeer = NULL, vol_scspirits = NULL, vol_scsherry = NULL, vol_scwine = NULL, vol_scpops = NULL)]

  }

  #################################################################
  # Convert natural volumes (ml of beverage) into units

  if(year %in% c(year_set1, year_set2) | country %in% c("Scotland","Wales")) {

    # divide by 1000 because
    # first divide by 100 to convert % abv into a proportion
    # then divide by 10 because 1 UK standard unit of alcohol is defined as 10ml of pure ethanol

    data[ , nbeer_units := vol_nbeer * abv_data[beverage == "nbeerabv", abv] / 1000]
    data[ , sbeer_units := vol_sbeer * abv_data[beverage == "sbeerabv", abv] / 1000]
    data[ , spirits_units := vol_spirits * abv_data[beverage == "spiritsabv", abv] / 1000]
    data[ , sherry_units := vol_sherry * abv_data[beverage == "sherryabv", abv] / 1000]
    data[ , wine_units := vol_wine * abv_data[beverage == "wineabv", abv] / 1000]
    data[ , pops_units := vol_pops * abv_data[beverage == "popsabv", abv] / 1000]

    #data[ , `:=`(vol_nbeer = NULL, vol_sbeer = NULL, vol_spirits = NULL, vol_sherry = NULL, vol_wine = NULL, vol_pops = NULL)]


    #################################################################
    # Condense into 4 beverage categories

    data[ , beer_units := nbeer_units + sbeer_units]
    data[ , wine_units := wine_units + sherry_units]

    #data[ , `:=`(nbeer_units = NULL, sbeer_units = NULL, sherry_units = NULL)]

    setnames(data, c("spirits_units", "pops_units"), c("spirit_units", "rtd_units"))


    #################################################################
    # Generate weekly total units

    if(year > 2019 & country == "Wales"){

    data[ , weekmean := dv_wk_units]

    } else {

    data[ , weekmean := spirit_units + wine_units + rtd_units + beer_units]

    }
    # update variable on whether someone drinks or not to match the
    # weekmean variable
    # this means that the data on participation in alcohol consumption is
    # adjusted to match the observed data on actual consumption

    # if someone is recorded as drinking more than zero alcohol on average per week
    # then make sure they are classed as a drinker
    data[weekmean > 0, drinks_now := "drinker"]

    # and alternatively, if someone is still classed as a non-drinker
    # make sure their weekly mean consumption is zero
    data[drinks_now == "non_drinker", weekmean := 0]

    # generate preference vector
    data[ , perc_spirit_units := 100 * spirit_units / weekmean]
    data[ , perc_wine_units := 100 * wine_units / weekmean]
    data[ , perc_rtd_units := 100 * rtd_units / weekmean]
    data[ , perc_beer_units := 100 * beer_units / weekmean]

    data[is.na(perc_spirit_units), perc_spirit_units := 0]
    data[is.na(perc_wine_units), perc_wine_units := 0]
    data[is.na(perc_rtd_units), perc_rtd_units := 0]
    data[is.na(perc_beer_units), perc_beer_units := 0]

    # Cap consumption at 300 units
    #data[weekmean > 300, weekmean := 300]


    #################################################################
    # Categorise total units per week

    data[ , drinker_cat := NA_character_]
    data[drinks_now == "non_drinker", drinker_cat := "abstainer"]
    data[drinks_now == "drinker" & weekmean < 14, drinker_cat := "lower_risk"]
    data[drinks_now == "drinker" & weekmean >= 14 & weekmean < 35 & sex == "Female", drinker_cat := "increasing_risk"]
    data[drinks_now == "drinker" & weekmean >= 14 & weekmean < 50 & sex == "Male", drinker_cat := "increasing_risk"]
    data[drinks_now == "drinker" & weekmean >= 35 & sex == "Female", drinker_cat := "higher_risk"]
    data[drinks_now == "drinker" & weekmean >= 50 & sex == "Male", drinker_cat := "higher_risk"]


    #################################################################
    # Categorise beverage preferences

    data[perc_spirit_units == 0, spirits_pref_cat := "does_not_drink_spirits"]
    data[perc_spirit_units > 0 & perc_spirit_units <= 0.5, spirits_pref_cat := "drinks_some_spirits"]
    data[perc_spirit_units > 0.5, spirits_pref_cat := "mostly_drinks_spirits"]

    data[perc_wine_units == 0, wine_pref_cat := "does_not_drink_wine"]
    data[perc_wine_units > 0 & perc_wine_units <= 0.5, wine_pref_cat := "drinks_some_wine"]
    data[perc_wine_units > 0.5, wine_pref_cat := "mostly_drinks_wine"]

    data[perc_rtd_units == 0, rtd_pref_cat := "does_not_drink_rtds"]
    data[perc_rtd_units > 0 & perc_rtd_units <= 0.5, rtd_pref_cat := "drinks_some_rtds"]
    data[perc_rtd_units > 0.5, rtd_pref_cat := "mostly_drinks_rtds"]

    data[perc_beer_units == 0, beer_pref_cat := "does_not_drink_beer"]
    data[perc_beer_units > 0 & perc_beer_units <= 0.5, beer_pref_cat := "drinks_some_beer"]
    data[perc_beer_units > 0.5, beer_pref_cat := "mostly_drinks_beer"]

  }

  return(data[])
}

