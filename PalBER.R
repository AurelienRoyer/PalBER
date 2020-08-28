Func_BIOCLIM2 <- function(M, ...){
  UseMethod("Func_BIOCLIM2", M)
}

Func_BIOCLIM2.list <- function(List, EUL = TRUE, quantiv = TRUE, interval =
                               "prediction", verif = FALSE, BioZoneFile =
                               "data_species_biozone.csv", taxcol = "Taxon",
                               ordercol = "Ordre", rodentiaName = "RODENTIA",
                               eulipotyphlaName = "EULIPOTYPHLA",
                               BioClimFile =
                               "bioclimatic spectra and climate.csv",
                               stationcol = "Site", biomecol = "Biome",
                               climcol = c("MAT", "Tp",	"Tmax",	"Tmin", "Mta",
                               "It", "Itc", "P", "D"), rodcol =
                               paste0("Rod_", c("I", "II",	"II/III",	"III",
                               "IV", "V", "VI", "VII",	"VIII",	"IX")),
                               eulrodcol = paste0("EulRod_", c("I", "II",
                               "II/III", "III", "IV", "V", "VI", "VII",
                               "VIII", "IX")), keepCol = rep(TRUE, 10)){

  lres <- lapply(List, Func_BIOCLIM2, EUL = EUL, quantiv = quantiv, interval =
                 interval, verif = verif, BioZoneFile = BioZoneFile, taxcol =
                 taxcol, ordercol = ordercol, rodentiaName = rodentiaName,
                 eulipotyphlaName = eulipotyphlaName, BioClimFile = BioClimFile,
                 stationcol = stationcol, biomecol = biomecol, climcol = climcol,
                 rodcol = rodcol, eulrodcol = eulrodcol, keepCol = keepCol)

  return(lres)
}


# Main function
Func_BIOCLIM2.character <- function(Data, EUL = TRUE, quantiv = TRUE, interval =
                                    "prediction", verif = FALSE, BioZoneFile =
                                    "data_species_biozone.csv", taxcol = "Taxon",
                                    ordercol = "Ordre", rodentiaName = "RODENTIA",
                                    eulipotyphlaName = "EULIPOTYPHLA",
                                    BioClimFile =
                                    "bioclimatic spectra and climate.csv",
                                    stationcol = "Site", biomecol = "Biome",
                                    climcol = c("MAT", "Tp",	"Tmax",	"Tmin",
                                    "Mta", "It", "Itc", "P", "D"), rodcol =
                                    paste0("Rod_", c("I", "II",	"II/III",	"III",
                                    "IV", "V", "VI", "VII",	"VIII",	"IX")),
                                    eulrodcol = paste0("EulRod_", c("I", "II",
                                    "II/III", "III", "IV", "V", "VI", "VII",
                                    "VIII", "IX")), keepCol = rep(TRUE, 10)) {

  # computing biozone composition for the given list of species
  BCI <- Func_BCI_Calcul(Data, BioZoneFile = BioZoneFile, taxcol = taxcol,
                         ordercol = ordercol, rodentiaName = rodentiaName,
                         eulipotyphlaName = eulipotyphlaName, EUL = EUL,
                         verif = verif)

  # LDA
  table_resultat <- func_LDA(BCI, quantiv = quantiv, interval = interval,
                             EUL = EUL, BioClimFile = BioClimFile,
                             stationcol = stationcol, biomecol =biomecol,
                             climcol = climcol, rodcol = rodcol,
                             eulrodcol = eulrodcol, keepCol = keepCol)

  # printing results
  print(table_resultat)

  return(table_resultat)
}


Func_BCI_Calcul <- function(M, ...){
  UseMethod("Func_BCI_Calcul", M)
}

Func_BCI_Calcul.list <- function(List, BioZoneFile = "data_species_biozone.csv",
                                 taxcol = "Taxon", ordercol = "Ordre",
                                 rodentiaName = "RODENTIA", eulipotyphlaName =
                                 "EULIPOTYPHLA", EUL = TRUE, verif = FALSE){

  lres <- lapply(List, Func_BCI_Calcul, BioZoneFile = BioZoneFile,
                 taxcol = taxcol, ordercol = ordercol, rodentiaName =
                 rodentiaName, eulipotyphlaName = eulipotyphlaName, EUL = EUL,
                 verif = verif)

  return(lres)
}

# function computing biozone composition
Func_BCI_Calcul.character <- function(Data, BioZoneFile = "data_species_biozone.csv",
                                      taxcol = "Taxon", ordercol = "Ordre",
                                      rodentiaName = "RODENTIA",
                                      eulipotyphlaName = "EULIPOTYPHLA",
                                      EUL = TRUE, verif = FALSE) {

  # reading csv file containing species biozones
  data_allspecies <- read.table(BioZoneFile, header = T , sep = ";",
                                check.names = FALSE)

  # finding species from Data contained into data_allspecies
  taxNamesTot <- as.character(unlist(data_allspecies[taxcol]))
  id_used <- which(is.element(taxNamesTot, Data))

  # finding possible species from Data not contained into data_allspecies
  id_noused <- which(!is.element(Data, taxNamesTot))
  names_noused <- Data[id_noused]

  if (length(id_used) < 1){
    # at least one species is needed...
    stop("Provided Taxa names are not available in the current biozone File.")
  }

  # extracting biozone data from data_allspecies for given species in Data
  tab_faunal <- data_allspecies[id_used,]

  # identifying Rodentia & Eulipotyphla
  id_rodentia <- tab_faunal[ordercol] == rodentiaName
  id_euli <- tab_faunal[ordercol] == eulipotyphlaName
  nb_rodentia <- sum(id_rodentia)
  nb_euli <- sum(id_euli)

  # printing info about the data to extract
  if (verif){
    cat("\n", paste("The dataset is constituted by", nb_rodentia,
    "rodents and", nb_euli, "eulipotyphles."))
    if (length(id_noused)>1){
      cat("\n", paste(names_noused, "was not included.", colapse="\n"))
    }
    cat("\n")
  }

  # selecting only Rodentia if needed
  if(EUL) {
    mammals_nom <- "Rodentia and Eulipotyphla:"
  } else {
    tab_faunal <- tab_faunal[id_rodentia,]
    mammals_nom <- "Rodentia:"
  }

  # deleting columns correponding to orders and taxons
  idx_col <- setdiff(setdiff(colnames(tab_faunal), ordercol), taxcol)
  valueCR <- tab_faunal[, idx_col]
  nb <- nrow(valueCR)

  # computing biozone composition for the given list of species
  if (nb > 1) {
    # restoring true percentages values due to rounding errors in data_allspecies
    valueCR <- valueCR / rowSums(valueCR)

    # computing biozone composition
    BCI <- 100 * colSums(valueCR) / nb
    BCI <- c(BCI, nb = nb)
  } else {
    cat("\n", "Impossible calculation", "\n")
    return(NULL)
  }

  # giving attribute EUL to the results for compatibility with the func_LDA function
  attr(BCI, "EUL") <- EUL

  # printing results
  cat("\n", paste("BCI calculated with", mammals_nom), "\n")
  print(BCI)

  return(BCI)
}


func_LDA <- function(M, ...){
  UseMethod("func_LDA", M)
}

func_LDA.list <- function(List, quantiv = TRUE, interval = "prediction",
                          EUL = lapply(List, attr, "EUL"),  BioClimFile =
                          "bioclimatic spectra and climate.csv",
                            stationcol = "Site", biomecol = "Biome",
                            climcol = c("MAT", "Tp",	"Tmax",	"Tmin", "Mta",
                            "It", "Itc", "P", "D"),
                            rodcol = paste0("Rod_", c("I", "II",	"II/III",
                            "III",	"IV", "V", "VI", "VII",	"VIII",	"IX")),
                            eulrodcol = paste0("EulRod_", c("I", "II",
                            "II/III", "III", "IV", "V", "VI", "VII", "VIII",
                            "IX")), keepCol = rep(TRUE, 10)) {

  lres <- mapply(func_LDA, List, EUL = EUL, MoreArgs = list(quantiv = quantiv,
                 interval = interval, BioClimFile = BioClimFile, stationcol =
                 stationcol, biomecol = biomecol, climcol = climcol, rodcol =
                 rodcol, eulrodcol = eulrodcol, keepCol = keepCol), SIMPLIFY =
                 FALSE)

  return(lres)
}

# LDA function
func_LDA.numeric <- function(Names, EUL = attr(Names, "EUL"), quantiv = TRUE,
                             interval = "prediction", BioClimFile =
                             "bioclimatic spectra and climate.csv",
                             stationcol = "Site", biomecol = "Biome",
                             climcol = c("MAT", "Tp",	"Tmax",	"Tmin", "Mta",
                             "It", "Itc", "P", "D"),
                             rodcol = paste0("Rod_", c("I", "II",	"II/III",
                             "III",	"IV", "V", "VI", "VII",	"VIII",	"IX")),
                             eulrodcol = paste0("EulRod_", c("I", "II",
                             "II/III", "III", "IV", "V", "VI", "VII", "VIII",
                             "IX")), keepCol = rep(TRUE, 10)) {

  library(MASS)

  # reading file with bioclimatic spectra and climate data
  data_bci <- read.table(BioClimFile, header = T, sep = ";", check.names = FALSE)

  # extracting station, biome, and climatic varible names
  nom_data_clim_station <- data_bci[stationcol]
  station_zoneclim <- data_bci[biomecol]
  data_clim_station <- data_bci[climcol]

  # selecting rodentia data (+ eulipotyphla if needed)
  if (EUL){
    data_bci <- data_bci[eulrodcol]
  } else {
    data_bci <- data_bci[rodcol]
  }

  # keeping only asked columns
  data_bci <- data_bci[which(keepCol)]
  Names <- Names[which(keepCol)]

  # Linear Discriminant Analysis on data_bci depending on biomes
  Lda <- lda(data_bci, as.factor(station_zoneclim[, 1]))

  # predict classification from lda for given data in Names
  predict_class <- predict(Lda, Names)

  # extracting first two highest posterior probabilities
  my_df <- as.data.frame(predict_class$posterior)
  synthese <- cbind(rev(sort(my_df))[1:2], t(names(rev(sort(my_df))[1:2])))
  synthese <- synthese[, c(3, 1, 4, 2)]
  colnames(synthese) <- c("First_predite", "proba_value", "Second_predite",
                          "proba_value")

  if (!quantiv){
    return(synthese)
  } else {
    # prediction through multiple regressions

    # extracting variable names for regression
    BCI_VarNames <- c("bioclimI", "bioclimII", "bioclimIIetIII",
                      "bioclimIII", "bioclimIV", "bioclimV", "bioclimVI",
                      "bioclimVII", "bioclimVIII", "bioclimIX")[keepCol]
    Clim_VarNames <- colnames(data_clim_station)

    # setting newdataX for prediction via data from Names
    newdataX <- as.data.frame(t(Names))
    colnames(newdataX) <- BCI_VarNames
    colnames(data_bci) <- BCI_VarNames

    # loop over dependent climatic variables
    tempvalue_list <- list()
    Value_list <- lm_list <- list()
    for(j in 1:ncol(data_clim_station)){

      # building dataframe for lm with the jth climatic variable
      dtf <- cbind(data_clim_station[,j], data_bci)
      colnames(dtf)[1] <- Clim_VarNames[j]

      # building corresponding formula
      fo <- as.formula(paste(Clim_VarNames[j], "~",
                       paste(BCI_VarNames, collapse = " + ")))

      # multiple regression
      tmpLM <- lm(fo, data = dtf)

      # predicting y values for newdataX
      tmpPred <- predict.lm(tmpLM, newdata = newdataX, interval = interval,
                        level = 0.95, type = "response")

      # saving lm & predict.lm objects in lists
      lm_list[[j]] <- tmpLM
      Value_list[[j]] <- tmpPred

    }

    # extracting multiple regression coefficients from lm_list + summary statistics for the multiple regressions
    Coe <- sapply(lm_list, coef)
    colnames(Coe) <- Clim_VarNames
    Coe <- t(Coe)
    r2 <- sapply(lm_list, function(lmo){summary(lmo)$r.squared})
    adj_r2 <- sapply(lm_list, function(lmo){summary(lmo)$adj.r.squared})
    fstat <- sapply(lm_list, function(lmo){summary(lmo)$fstatistic})
    pval <- pf(fstat[1, ], fstat[2, ], fstat[3, ], lower.tail=FALSE)
    fstat <- fstat[1, ]
    Coe <- cbind(Coe, r2, adj_r2, fstat, pval)

    # converting Value_list as a dataframe
    Value_list <- as.data.frame(Value_list)
    colnames(Value_list) <- paste0(rep(Clim_VarNames, each=3), c("_fit","_lwr","_upr"))

    # storing results of predictions (multiple regression coefficients being stored as an attribute to the exported object)
    synthese <- data.frame(synthese, Value_list)
    attr(synthese, "Coefficients") <- Coe
  }

  return(synthese)
}



ReadFaunalList <- function(filename, sep = "\t"){

  # scanning file containg faunal list by column
  fl <- scan(filename, what = "character", sep = sep, quiet = TRUE)

  # converting fl as a list: each element being a line in the orignal file
  # empty cells being converted as ""
  Lfl <- lapply(fl, f <- function(v){unlist(strsplit(v, ";"))})

  # number of Species and faunal lists
  nSp <- length(Lfl)
  nFau <- length(Lfl[[1]])

  # in Lfl, some "" could miss at the end of each line: adding them if needed...
  Lfl <- lapply(Lfl, f <- function(v){
                            N <- length(v)
                            if(N < nFau){
                               n <- nFau - N
                               v <- c(v, rep("", n))
                            }
                            return(v)
                          })

  # converting Lfl (faunal list not by line) as a matrix (faunal list by column)
  Mfl <- t(matrix(unlist(Lfl), nFau, nSp))

  # converting back to a list (faunal list by line)
  Lfl <- as.list(as.data.frame(Mfl[2:nSp, ]))
  names(Lfl) <- Mfl[1, ]

  # suppressing empty values "" in Lfl
  Lfl <- lapply(Lfl, f <- function(v){
                     v <- as.character(v)
                     idx <- which(nchar(v) < 1)[1] - 1
                     if (!is.na(idx)){
                       v <- v[1:idx]
                     }
                     return(v)
                   })

  return(Lfl)

}
