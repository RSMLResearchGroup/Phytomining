# This script loads the results file Agromining_Results.xlsx and performs ANOVA
# and GLM analyses on bio-ore weight and bioaccumulation factor
# Libraries ====================================================================

library(readxl)

# Constants ====================================================================

SPECIES_ORDER <- c("P. arundinacea", "P. americana", "S. nigrum", "B. juncea")
FACTOR_LEVELS_SPECIES <- c("P. arundinacea", "S. nigrum", "P. americana", "B. juncea")
SOIL_ORDER <- c("Untreated", "Fertilizer", "Biochar")
FACTOR_LEVELS_SOIL <- c("Untreated", "Fertilizer", "Biochar")
WATER_ORDER <- c("Untreated", "Citric Acid")
FACTOR_LEVELS_WATER <- c("Untreated", "Citric Acid")
SPECIES_RELEVEL <- list(Bjuncea=1, Pamericana=2, Parundinacea=3, Snigrum=4)

# Data preprocessing ===========================================================

agro <- read_excel("Agromining_Results.xlsx", sheet="Sheet1")
agro[["Species"]] <- relevel(as.factor(sapply(agro[["Species"]], function(i) SPECIES_ORDER[i])),
  ref=SPECIES_RELEVEL[["Pamericana"]])
agro[["Soil"]] <- relevel(as.factor(sapply(agro[["Soil"]], function(i) SOIL_ORDER[i])), ref=3)
agro[["Water"]] <- relevel(as.factor(sapply(agro[["Water"]], function(i) WATER_ORDER[i])), ref=2)
agro[["Success"]] <- !is.na(agro[,"Total_target"])

# Analysis =====================================================================

aov_bioore <- aov(Bioore_weight ~ Species * Soil * Water, data=agro)
print(summary(aov_bioore))

aov_bf <- aov(BF ~ Species * Soil * Water, data=agro)
print(summary(aov_bf))

aov_success <- aov(Success ~ Species * Soil * Water, data=agro)
print(summary(aov_success))

aov_drymass <- aov(Dry_mass ~ Species * Soil * Water, data=agro)
print(summary(aov_drymass))

glm_bioore <- glm(Bioore_weight ~ Soil + Water + Species, 
                family = Gamma(link = "log"), data = agro)
print(summary(glm_bioore))

glm_bf <- glm(BF ~ Soil + Water + Species, 
                family = Gamma(link = "log"), data = agro)
print(summary(glm_bf))

glm_success <- glm(Success ~ Soil + Water + Species, 
                family = binomial(link = "logit"), data = agro)
print(summary(glm_success))

glm_drymass <- glm(Dry_mass ~ Soil + Water + Species, 
                family = Gamma(link = "log"), data = agro)
print(summary(glm_drymass))
