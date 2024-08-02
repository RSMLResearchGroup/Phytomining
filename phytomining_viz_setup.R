# Libraries ====================================================================

library(readxl)
library(ggplot2)
library(ggtext)
library(viridis)
library(patchwork)

# Docopt =======================================================================

'Generate data visualization.

Usage:
  phytomining_viz_{pdf,png,svg}.R [--species=<sp>]

Options:
  -h --help     Show this screen.
  --species=<sp>  Species: one of "P. arundinacea", "S. nigrum", "P. americana", "B. juncea"

' -> doc

library(docopt)
opt <- docopt(doc)

# Constants ====================================================================

SPECIES_ORDER <- c("P. arundinacea", "P. americana", "S. nigrum", "B. juncea")
FACTOR_LEVELS_SPECIES <- c("P. arundinacea", "S. nigrum", "P. americana", "B. juncea")
SOIL_ORDER <- c("Untreated", "Fertilizer", "Biochar")
FACTOR_LEVELS_SOIL <- c("Untreated", "Fertilizer", "Biochar")
WATER_ORDER <- c("Untreated", "Citric Acid")
FACTOR_LEVELS_WATER <- c("Untreated", "Citric Acid")

# Data preprocessing ===========================================================

agro <- read_excel("Agromining_Results.xlsx", sheet="Sheet1")
agro[["Species"]] <- as.factor(sapply(agro[["Species"]], function(i) SPECIES_ORDER[i]))
agro[["Soil"]] <- as.factor(sapply(agro[["Soil"]], function(i) SOIL_ORDER[i]))
agro[["Water"]] <- as.factor(sapply(agro[["Water"]], function(i) WATER_ORDER[i]))
agro[["Total_target"]] <- rowSums(agro[,c("Ce","La","Nd","Pr","Y")])
agro[["Target_soil"]] <- rowSums(agro[,c("Ce_soil","La_soil","Nd_soil","Pr_soil","Y_soil")])
agro[["BF"]] <- agro[["Total_target"]] / agro[["Target_soil"]]

success_species <- data.frame(Species = FACTOR_LEVELS_SPECIES, Success_rate = sapply(FACTOR_LEVELS_SPECIES, function(x) sum(agro[,"Species"] == x & !is.na(agro[,"Total_target"]))/sum(agro[,"Species"] == x)*100))
success_soil <- data.frame(Soil = FACTOR_LEVELS_SOIL, Success_rate = sapply(FACTOR_LEVELS_SOIL, function(x) sum(agro[,"Soil"] == x & !is.na(agro[,"Total_target"]))/sum(agro[,"Soil"] == x)*100))
success_water <- data.frame(Water = FACTOR_LEVELS_WATER, Success_rate = sapply(FACTOR_LEVELS_WATER, function(x) sum(agro[,"Water"] == x & !is.na(agro[,"Total_target"]))/sum(agro[,"Water"] == x)*100))

if (!is.null(opt[["species"]])) {
    agro <- agro[agro[["Species"]] == opt[["species"]],]
    FACTOR_LEVELS_SPECIES <- opt[["species"]]
}

# Functions ====================================================================

draw_bar <- function(df, variable, factor_levels, italic_x = FALSE, x_label=NULL, y_label=NULL) {
    base_plot <- ggplot(df, aes(x = factor(.data[[variable]], levels=factor_levels), y = Success_rate, fill = factor(.data[[variable]], levels=factor_levels))) +
        geom_bar(color="black", stat="identity") + guides(fill = FALSE) + theme_classic() +
        scale_fill_viridis(option="viridis", discrete=TRUE) +
        labs(x = variable, y = "Success_rate") +
        theme(axis.text.x = element_markdown(angle = 30, hjust = 1))
    if (italic_x) {
        base_plot <- base_plot + scale_x_discrete(labels = paste0("*", factor_levels,"*"))
    }
    if (!is.null(x_label)) base_plot <- base_plot + xlab(x_label)
    if (!is.null(y_label)) base_plot <- base_plot + ylab(y_label)
    base_plot
}

draw_hist <- function(value, variable, factor_levels, x_label, legend_title = NULL, binwidth = 5000, italic_legend = FALSE) {
    base_plot <- ggplot(agro, aes(x = .data[[value]], fill = factor(.data[[variable]], levels=factor_levels))) +
        geom_histogram(binwidth=binwidth, color="black") + theme_classic() +
        scale_fill_viridis(option="viridis", discrete=TRUE) +
        labs(x = x_label, y = "N. Samples", fill=variable) +
        theme(axis.text.x = element_text(angle = 30, hjust = 1))
    if (italic_legend) {
        base_plot <- base_plot + scale_fill_viridis(
            labels = paste0("*", factor_levels,"*"), discrete=TRUE
        ) + theme(legend.text = element_markdown())
    }
    if (!is.null(legend_title)) {
        base_plot <- base_plot + scale_fill_viridis(name = legend_title, discrete = TRUE)
    }
    base_plot
}

draw_box <- function(value, variable, factor_levels, y_label, x_label=NULL, italic_x = FALSE) {
    base_plot <- ggplot(agro, aes(x = factor(.data[[variable]], levels=factor_levels), y = .data[[value]],
        fill = factor(.data[[variable]], levels=factor_levels))) +
    geom_boxplot(width=0.7, varwidth=TRUE) + guides(fill = FALSE) + theme_classic() +
    scale_fill_viridis(option="viridis", discrete=TRUE) +
    labs(x = variable, y = y_label) +
    theme(axis.text.x = element_markdown(angle = 30, hjust = 1), axis.text.y = element_text(angle = 30, hjust = 1))
    if (italic_x) {
        base_plot <- base_plot + scale_x_discrete(
            labels = paste0("*", factor_levels,"*")
        )
    }
    if (!is.null(x_label)) base_plot <- base_plot + xlab(x_label)
    base_plot
}

draw_points <- function(x, y, variable, factor_levels, x_label, y_label, legend_title = NULL, italic_legend = FALSE) {
    base_plot <- ggplot(agro, aes(x = .data[[x]], y = .data[[y]], fill = factor(.data[[variable]], levels=factor_levels))) +
        geom_point(size = 3, shape = 21, color="black") + theme_classic() +
        scale_fill_viridis(option="viridis", discrete=TRUE) +
        labs(x = x_label, y = y_label, fill=variable) +
        theme(axis.text.x = element_text(angle = 30, hjust = 1))
    if (italic_legend) {
        base_plot <- base_plot + scale_fill_viridis(
            labels = paste0("*", factor_levels,"*"), discrete = TRUE
        ) + theme(legend.text = element_markdown())
    }
    if (!is.null(legend_title)) {
        base_plot <- base_plot + scale_fill_viridis(name = legend_title, discrete = TRUE)
    }
    base_plot
}
