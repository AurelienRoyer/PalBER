# setting working directory
setwd("C:/Work/Analyses chercheurs/Analyses Aurélien Royer/new/clean")

# loading the file with functions
source("PalBER.R")

# creating a faunal list
LVLn_of_siteS <- c("Dicrostonyx_torquatus", "Alexandromys_oeconomus",
                   "Microtus_arvalis", "Sorex_araneus", "Neomys_fodiens",
                   "Fake_species", "Choloepus_hoffmanni")

#########################################
# calling the main function Func_BIOCLIM2
#########################################
# From the given faunal list contained in LVLn_of_siteS, it computes:
# - the BCI values for this faunal list from the reference CRI data contained in data_species_biozone.csv list
#   considering both rodents and Eulipotyphla (argument EUL=TRUE), and checking species names given by user
#   (argument verif=TRUE)
# - a LDA on reference data to differentiate BCI values depending on bioclimatic zones (=> computations of discriminant functions)
# - the prediction of bioclimatic zones for the given faunal list based on discriminant functions determined on the reference dataset
# - multiple regressions (one for each of the climatic variables: TP, MAT, ...) of climatic variables depending on BCI spectra
# - predictions of those climatic variables for the given datase from the regression models
results <- Func_BIOCLIM2(LVLn_of_siteS, EUL = TRUE ,interval = "predict", verif = TRUE)

################################################
# detail for each function inside func_Bioclim2:
# Calcul of BCI from rodentia and eulipotyphla, with verification of faunal list used for calculation
BCI_LVLn_of_siteS <- Func_BCI_Calcul(LVLn_of_siteS, EUL = TRUE, verif = TRUE)
# Estimation and confidence interval of climate with those BCI values through LDA and multiple regressions
res_lda <- func_LDA(BCI_LVLn_of_siteS)
res_lda
# Getting the coefficients from the multiple regressions on the reference dataset
# (only available if quantiv argument is set to TRUE) as well as other summary statistics
attr(res_lda, "Coefficients")

# Calcul of BCI from rodentia and eulipotyphla, without verification of faunal list used for calculation
BCI_LVLn_of_siteS <- Func_BCI_Calcul(LVLn_of_siteS, EUL = TRUE, verif = FALSE)
# Estimation and confidence interval of climate with those BCI values through LDA and multiple regressions
res_lda <- func_LDA(BCI_LVLn_of_siteS)
res_lda

#Calcul of BCI from rodentia, with verification of faunal list used for calculation
BCI_LVLn_of_siteS <- Func_BCI_Calcul(LVLn_of_siteS, EUL = FALSE, verif = TRUE)
# Estimation and confidence interval of climate with those BCI values through LDA and multiple regressions
res_lda <- func_LDA(BCI_LVLn_of_siteS)
res_lda

#Calcul of BCI from rodentia, without verification of faunal list used for calculation
BCI_LVLn_of_siteS <- Func_BCI_Calcul(LVLn_of_siteS, EUL = FALSE, verif = FALSE)
# Estimation and confidence interval of climate with those BCI values through LDA and multiple regressions
res_lda <- func_LDA(BCI_LVLn_of_siteS)
res_lda

##################################
# Exemple with several faunal list
#creation of data
LVLn1_of_siteS <- c("Dicrostonyx_torquatus", "Alexandromys_oeconomus",
                    "Microtus_arvalis", "Sorex_araneus", "Neomys_fodiens",
                    "Fake_species", "Choloepus_hoffmanni")
LVLn2_of_siteS <- c("Microtus_arvalis", "Microtus_agrestis",
                    "Alexandromys_oeconomus", "Arvicola_amphibius",
                    "Apodemus_sylvaticus", "Microtus_lusitanicus",
                    "Chionomys_nivalis", "Sorex_araneus", "Talpa_europaea")
LVLn3_of_siteS <- c("Arvicola_sapidus", "Castor_fiber",
                    "Clethrionomys_glareolus", "Crocidura_leucodon",
                    "Crocidura_russula", "Crocidura_suaveolens",
                    "Eliomys_quercinus", "Erinaceus_europaeus", "Glis_glis",
                    "Micromys_minutus", "Microtus_agrestis", "Microtus_arvalis",
                    "Microtus_pyrenaicus", "Microtus_subterraneus",
                    "Mus_musculus", "Muscardinus_avellanarius",
                    "Myocastor_coypus", "Neomys_fodiens", "Ondatra_zibethicus",
                    "Rattus_norvegicus", "Rattus_rattus", "Sciurus_vulgaris",
                    "Sorex_araneus", "Sorex_coronatus", "Sorex_minutus",
                    "Suncus_etruscus")
List <- list(LVLn1_of_siteS, LVLn2_of_siteS, LVLn3_of_siteS)

lbci <- Func_BCI_Calcul(List, EUL = TRUE, verif = TRUE)
llda <- func_LDA(lbci, quantiv = TRUE)
ltot <- Func_BIOCLIM2(List, EUL = TRUE, verif = TRUE)



#######################################
# Importing a csv file as a faunal list
the_list <- ReadFaunalList("Faunal_List_Example.csv") # 'the_list' object is identical to the object 'List'
ltot <- Func_BIOCLIM2(List, EUL = TRUE, verif = TRUE)
