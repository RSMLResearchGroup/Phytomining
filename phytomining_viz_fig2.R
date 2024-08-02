source("phytomining_viz_setup.R")
library(svglite)
svg("phytomining_viz_fig2.svg", width = 8, height = 10)
print(
  (draw_bar(success_species, "Species", FACTOR_LEVELS_SPECIES, y_label="Success Rate (%)", italic_x = TRUE) +
    draw_bar(success_soil, "Soil", FACTOR_LEVELS_SOIL, y_label="Success Rate (%)", x_label="Soil Treatment") +
    draw_bar(success_water, "Water", FACTOR_LEVELS_WATER, y_label="Success Rate (%)", x_label = "Water Treatment")) /
  (draw_box("Dry_mass", "Species", FACTOR_LEVELS_SPECIES, "Dry Biomass (grams)", italic_x = TRUE) + 
    draw_box("Dry_mass", "Soil", FACTOR_LEVELS_SOIL, "Dry Biomass (grams)", x_label = "Soil Treatment") +
    draw_box("Dry_mass", "Water", FACTOR_LEVELS_WATER, "Dry Biomass (grams)", x_label = "Water Treatment")) /
  (draw_box("Bioore_weight", "Species", FACTOR_LEVELS_SPECIES, "Bio-ore Mass (grams)", italic_x = TRUE) +
    draw_box("Bioore_weight", "Soil", FACTOR_LEVELS_SOIL, "Bio-ore Mass (grams)", x_label = "Soil Treatment") +
    draw_box("Bioore_weight", "Water", FACTOR_LEVELS_WATER, "Bio-ore Mass (grams)", x_label = "Water Treatment")) /
  (draw_box("BF", "Species", FACTOR_LEVELS_SPECIES, "Bioaccumulation Factor", italic_x = TRUE) +
    draw_box("BF", "Soil", FACTOR_LEVELS_SOIL, "Bioaccumulation Factor", x_label = "Soil Treatment") +
    draw_box("BF", "Water", FACTOR_LEVELS_WATER, "Bioaccumulation Factor", x_label = "Water Treatment"))
)
dev.off()
