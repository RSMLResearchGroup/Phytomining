# This script loads the results file Agromining_Results.xlsx and performs ANOVA
# and GLM analyses on bio-ore weight and bioaccumulation factor
# Libraries ====================================================================

library(readxl)

# Docopt =======================================================================

'Perform ANOVA and GLM analysis on bio-ore weight, bioaccumulation factor, or
pot success rate.

Usage:
  phytomining_analysis.R [--model=<model>] [--value=<value>] [--intercept-species=<species>]

Options:
  -h --help     Show this screen.
  --model=<model>  One of "anova" or "glm"
  --value=<value>  One of "bioore", "bf", "success", or "drymass"
  --intercept-species=<species>  One of "Parundinacea", "Pamericana", "Snigrum" or "Bjuncea"

' -> doc

library(docopt)
opt <- docopt(doc)
if (is.null(opt[["model"]])) opt[["model"]] <- "anova"
if (is.null(opt[["value"]])) opt[["value"]] <- "bioore"
if (is.null(opt[["intercept_species"]])) opt[["intercept_species"]] <- "Pamericana"

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
  ref=SPECIES_RELEVEL[[opt[["intercept_species"]]]])
agro[["Soil"]] <- relevel(as.factor(sapply(agro[["Soil"]], function(i) SOIL_ORDER[i])), ref=3)
agro[["Water"]] <- relevel(as.factor(sapply(agro[["Water"]], function(i) WATER_ORDER[i])), ref=2)
agro[["Success"]] <- !is.na(agro[,"Total_target"])

# Analysis =====================================================================

if (opt["model"] == "anova" && opt["value"] == "bioore") {
  aov_bioore <- aov(Bioore_weight ~ Species * Soil * Water, data=agro)
  print(summary(aov_bioore))
}

if (opt["model"] == "anova" && opt["value"] == "bf") {
  aov_bf <- aov(BF ~ Species * Soil * Water, data=agro)
  print(summary(aov_bf))
}

if (opt["model"] == "anova" && opt["value"] == "success") {
  aov_success <- aov(Success ~ Species * Soil * Water, data=agro)
  print(summary(aov_success))
}

if (opt["model"] == "anova" && opt["value"] == "drymass") {
  aov_drymass <- aov(Dry_mass ~ Species * Soil * Water, data=agro)
  print(summary(aov_drymass))
}

if (opt["model"] == "glm" && opt["value"] == "bioore") {
  glm_bioore <- glm(Bioore_weight ~ Soil + Water + Species, 
                  family = Gamma(link = "log"), data = agro)
  print(summary(glm_bioore))
}

if (opt["model"] == "glm" && opt["value"] == "bf") {
  glm_bf <- glm(BF ~ Soil + Water + Species, 
                  family = Gamma(link = "log"), data = agro)
  print(summary(glm_bf))
}

if (opt["model"] == "glm" && opt["value"] == "success") {
  glm_success <- glm(Success ~ Soil + Water + Species, 
                  family = binomial(link = "logit"), data = agro)
  print(summary(glm_success))
}

if (opt["model"] == "glm" && opt["value"] == "drymass") {
  glm_drymass <- glm(Dry_mass ~ Soil + Water + Species, 
                  family = Gamma(link = "log"), data = agro)
  print(summary(glm_drymass))
}
