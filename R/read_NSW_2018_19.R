#' Read the National Survey for Wales 2018-19 \lifecycle{maturing}
#'
#' Reads and does basic cleaning on the National Survey for Wales 2018-19.
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
#'
#' }
read_NSW_2018_19 <- function(
    root = c("X:/", "/Volumes/Shared/")[1],
    file = "HAR_PR/PR/Consumption_TA/HSE/National Survey for Wales (NSW)/NSW 2018/UKDA-8591-tab/tab/national_survey_for_wales_2018-19_respondent_file_ukds.tab"
    ) {

    data <- data.table::fread(
      paste0(root, file),
      na.strings = c("NA", "", "-1", "-2", "-6", "-7", "-8", "-9", "-90", "-90.0", "-99", "N/A"))

    data.table::setnames(data, names(data), tolower(names(data)))

    alc_vars <- Hmisc::Cs(
      #### alc_drink_now_allages
      dnfreq, dnnow, dnocc, dnev,
      #### alc_sevenday_adult (heaviest day)

      #### alc_weekmean_adult
      # normal strength beer
      dnoftbr,                                         # how often in last 12 months
      dnubrmeas1, dnubrmeas2, dnubrmeas3, dnubrmeas4,  # measure drank
      dnubrhalf, dnubrsmc, dnubrlgc, dnubrbot,         # amount of measure drank
      # strong beer
      dnoftstbr,
      dnustbrmeas1, dnustbrmeas2, dnustbrmeas3, dnustbrmeas4,
      dnustbrhalf, dnustbrsmc, dnustbrlgc, dnustbrbot,
      # spirits
      dnoftspir,                                       # how often in last 12 months
      dnuspir,                                         # how many units
      # sherry/fortified wine
      dnoftsher,
      dnusher,
      # wine
      dnoftwine,                                 # how often in last 12 months
      dnuwinemeas,                               # measure drank (main size of wine glass)
      dnuwine,                                   # amount of measure drank
      # RTDs
      dnoftapop,                                  # how often in last 12 months
      dnuapopmeas1, dnuapopmeas2, dnuapopmeas3,   # measure drank
      dnuapopsmc, dnuapopstbot, dnuapoplgbot,     # amount of measure drank

      #### alc_sevenday_adult (for binge)
      dn7dn, dnsame, dn7dmost,
      dntype1, dntype2, dntype3, dntype4, dntype5, dntype6,

      # normal strength beer
      dnbrhalf, dnbrsmc, dnbrlgc, dnbrbot,
      # strong beer
      dnstbrhalf, dnstbrsmc, dnstbrlgc, dnstbrbot,
      # wine
      dnwinebot, dnwinelgg, dnwinestg, dnwinesmg,
      # sherry
      dnsher,
      # spirits
      dnspir,
      # RTDs
      dnaplgbot, dnapstbot, dnapsmc,

      # derived weekly units variable
      dvunitswk0
    )

    smk_vars <- tolower(Hmisc::Cs(Smoke, SmAge, Dvsmokec, Dvsmokstat, SmQuitTm))

    health_vars <- Hmisc::Cs(dvillchap1, dvillchap2, dvillchap3, dvillchap4, dvillchap5,
                             dvillchap6, dvillchap7, dvillchap8, dvillchap9, dvillchap10,
                             dvillchap11, dvillchap12, dvillchap13, dvillchap14, dvillchap15,
                             dvhtcm, dvwtkg, dvbmi2)

    other_vars <- Hmisc::Cs(
      dvla, dvregions,

      tenure,

      #psu,
      #strata, # stratification unit
      samplepophlthweight,

      #
      incresp,

      # Education
      #educend,
      educat, # Highest educational qualification - revised 2008

      # Occupation
      #nssec3, nssec8,
      econstat,

      # Family
      marstat,

      # demographic
      age,
      ethnicity,
      dvwimdovr5, dvwimdinc5,
      gender, numchild

    )

    names <- c(other_vars, health_vars, alc_vars, smk_vars)

    names <- tolower(names)

    data <- data[ , names, with = F]


    data.table::setnames(data,

                         c("dvregions", "dvwimdovr5","ethnicity","gender",

                           ##### alcohol weekly consumption vars
                           "dnfreq","dnev","dnocc",

                           # frequency of drink type over 12 months
                           "dnoftbr","dnoftstbr","dnoftspir","dnoftsher","dnoftwine","dnoftapop",
                           # normal strength beer
                           "dnubrmeas1", "dnubrmeas2", "dnubrmeas3", "dnubrmeas4",
                           "dnubrhalf", "dnubrsmc", "dnubrlgc", "dnubrbot",
                           # strong beer
                           "dnustbrmeas1", "dnustbrmeas2", "dnustbrmeas3", "dnustbrmeas4",
                           "dnustbrhalf", "dnustbrsmc", "dnustbrlgc", "dnustbrbot",
                           # wine
                           "dnuwinemeas", "dnuwine",
                           # sherry
                           "dnusher",
                           # spirits
                           "dnuspir",
                           # RTDs
                           "dnuapopmeas1", "dnuapopmeas2", "dnuapopmeas3",
                           "dnuapopsmc", "dnuapopstbot", "dnuapoplgbot",

                           ##### alcohol binge vars
                           "dn7dn", "dnsame", "dn7dmost",
                           "dntype1", "dntype2", "dntype3", "dntype4", "dntype5", "dntype6",

                           # normal strength beer
                           "dnbrhalf", "dnbrsmc", "dnbrlgc", "dnbrbot",
                           # strong beer
                           "dnstbrhalf", "dnstbrsmc", "dnstbrlgc", "dnstbrbot",
                           # wine
                           "dnwinebot", "dnwinelgg", "dnwinestg", "dnwinesmg",
                           # sherry
                           "dnsher",
                           # spirits
                           "dnspir",
                           # RTDs
                           "dnaplgbot", "dnapstbot", "dnapsmc",

                           #### derived variable for weekly units
                           "dvunitswk0",

                           ## health vars
                           "dvillchap1", "dvillchap2", "dvillchap3", "dvillchap4", "dvillchap5",
                           "dvillchap6", "dvillchap7", "dvillchap8", "dvillchap9", "dvillchap10",
                           "dvillchap11", "dvillchap12", "dvillchap13", "dvillchap14", "dvillchap15"),

                         c("region", "wimd","ethnicity_raw","sex",

                           ##### alcohol weekly consumption vars
                           "dnoft","dnevr","dnany",

                           # frequency of drink type over 12 months
                           "nbeer","sbeer","spirits","sherry","wine","pops",
                           # normal strength beer
                           "nbeerm1", "nbeerm2", "nbeerm3", "nbeerm4",
                           "nbeerq1", "nbeerq2", "nbeerq3", "nbeerq4",
                           # strong beer
                           "sbeerm1", "sbeerm2", "sbeerm3", "sbeerm4",
                           "sbeerq1", "sbeerq2", "sbeerq3", "sbeerq4",
                           # wine
                           "bwineq2", "wineq",
                           # sherry
                           "sherryq",
                           # spirits
                           "spiritsq",
                           # RTDs
                           "popsly11", "popsly12", "popsly13",
                           "popsq111", "popsq112", "popsq113",

                           ##### alcohol binge vars
                           "d7many", "drnksame", "whichday",
                           "d7typ1", "d7typ2", "d7typ3", "d7typ4", "d7typ5", "d7typ6",

                           # normal strength beer
                           "nberqhp7", "nberqsm7", "nberqlg7", "nberqbt7",
                           # strong beer
                           "sberqhp7", "sberqsm7", "sberqlg7", "sberqbt7",
                           # wine
                           "wbtlgz", "wgls250ml", "wgls175ml", "wgls125ml",
                           # sherry
                           "sherqgs7",
                           # spirits
                           "spirqme7",
                           # RTDs
                           "popsqlg7", "popsqstb7", "popsqsm7",

                           #### derived variable for weekly units
                           "dv_wk_units",

                           ## health vars
                           "compm1", "compm2", "compm3", "compm4", "compm5",
                           "compm6", "compm7", "compm8", "compm9", "compm10",
                           "compm11", "compm12", "compm13", "compm14", "compm15")
    )


    # Tidy survey weights and only keep the sub-sample that answered smoking
    # and drinking related questions
    data[ , wt_int := samplepophlthweight]
    data <- data[!is.na(samplepophlthweight), ]
    #data[age < 16, wt_int := NA]

    # Set PSU and cluster
    data[ , cluster := paste0("2018_", dvla)]

    data[ , year := 2018]
    data[ , country := "Wales"]

    return(data[])
  }
