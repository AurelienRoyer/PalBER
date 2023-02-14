# PalBER
## User Manual – September 2020

File : <br>
PalBER.R<br>
Script including all functions for Paleartic bioclim method<br>
Need following files to work: <br>
data_species_biozone.csv <br>
bioclimatic spectra and climate.csv<br>

## Description 
Compute qualitative and quantitative data from faunal list (Rodentia, Rodentia +Eulipotyphla)<br>
 
Func_BIOCLIM2 (x, EUL = TRUE, verif = FALSE, interval = “prediction”, quantiv = TRUE, as_list = FALSE)
Func_BCI_Calcul (x, EUL = TRUE, verif= FALSE, as_list = FALSE)
Func_LDA (y, EUL = TRUE, quantiv = TRUE, interval = “prediction”, as_list = FALSE)
 
Arguments <br>
x                            a list of fauna. <br>
y                      a list of 10 numeric BCI values for each plus the total number of fauna used<br>
EUL                       a logical value indicating whether Eulipotyphla taxa should be stripped before the computation proceeds. TRUE, include Eulipotyphla in computation. False, exclude it.<br>
VERIF                   function determining if a verification of faunal elements should be given. Verification allows to know what elements are excluded, which can be related to three reasons: not good taxonomic name, error in species name or name not in the database<br>
Interval                Type of interval calculation. Confidence or Prediction.<br>
Quantiv                a logical value indicating whether func_LDA should be done.<br>
as_list             To organize results as list (TRUE) or as table (FALSE).<br>
 
Details <br>
Method to infer past climate zones and quantify past climate condition by using small mammal fossil associations. It consists of two parts: the first is to predict a climate zone from Linear Discriminant Analysis (LDA) using the relationship between climatical typology of Walter (1970) and mammal communities; the second is to quantify climatic parameters from general multiple regression models using the weight of the mammal communities in each climatical zone. Two models were developed, the first based on Rodentia, and the second based on Rodentia and Eulipotyphla. <br>
The “Func_BCI_Calcul” function allows to calculate the BCI values for each small mammal associations <br>
The “Func_BCI_Calcul” function allows to predict the climate zone through an LDA and to quantify past climate factors <br>
The “Func_BIOCLIM2” function include both functions “Func_BCI_Calcul” and “Func_LDA” <br> 
New faunal species can be add or modify by directly modifying the “data_species_biozone.csv” file dataset <br>

## Example
### Creating a faunal list with real species and Fake_species, which does not exist in the database, in order to show how works the option “verif” (if species names are wrongly written or exist).

LVLn_of_siteS <- c("Dicrostonyx_torquatus", "Alexandromys_oeconomus","Microtus_arvalis", "Sorex_araneus", "Neomys_fodiens", "Fake_species")  

### Calcul of BCI from Rodentia and Eulipotyphla, with verification of faunal list used for calculation

BCI_LVLn_of_siteS <- Func_BCI_Calcul(LVLn_of_siteS, EUL = TRUE, verif = TRUE)
 > The dataset is constituted by 3 rodents and 2 eulipotyphles.
> Fake_species was not included.
  > BCI calculated with Rodentia and Eulipotyphla:
>       I       II   II/III      III       IV        V       VI      VII     VIII       IX
> 0.00000  0.00000  0.00000  0.00000  0.00000  0.00000 28.33333  5.00000 28.33333 38.33333
>      nb
> 5.00000

### Estimation of climate climate with the Rodentia and Eulipotyphla list and confidence interval
res_lda <- func_LDA(BCI_LVLn_of_siteS, EUL = TRUE, interval = "confidence" ) <br>
res_lda


### Getting the coefficients from the multiple regressions on the reference dataset as well as other summary statistics (r2, adjusted r2, F statistics and associated p-value)
only available if quantiv argument is set to TRUE <br>
attr(res_lda, "Coefficients")


LVLn1_of_siteS <- c("Dicrostonyx_torquatus", "Alexandromys_oeconomus","Microtus_arvalis") <br>
LVLn2_of_siteS <- c("Microtus_arvalis", "Microtus_agrestis","Alexandromys_oeconomus", "Arvicola_amphibius", "Apodemus_sylvaticus", "Microtus_lusitanicus","Chionomys_nivalis")<br>
LVLn3_of_siteS <- c("Arvicola_sapidus", "Castor_fiber","Clethrionomys_glareolus", "Crocidura_leucodon","Eliomys_quercinus", "Glis_glis","Micromys_minutus", "Microtus_agrestis", "Microtus_arvalis")<br>
List <- list(LVLn1_of_siteS, LVLn2_of_siteS, LVLn3_of_siteS)<br>
List <- list(LVLn1_of_siteS, LVLn2_of_siteS, LVLn3_of_siteS)<br>
Func_BIOCLIM2(List, EUL = FALSE, verif = FALSE, interval= “prediction”)<br>
 
## Reference
Royer, A., Yelo, B. A. G., Laffont, R., & Fernández, M. H. (2020). New bioclimatic models for the quaternary palaearctic based on insectivore and rodent communities. Palaeogeography, Palaeoclimatology, Palaeoecology, 560, 110040. https://doi.org/10.1016/j.palaeo.2020.110040

