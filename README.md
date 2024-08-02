# REE Phytomining

## Data

The excel file `Agromining_Results.xlsx` contains the experimental data.

## Visualization

The R script `phytomining_viz_fig2.R` contains code to generate plots of bio-ore weight,bioacumulation factor, pot success rate, and dry biomass. For example, generate a SVG file by:

```sh
Rscript phytomining_viz_fig2.R
```

## Statistical analysis

The R script `phytomining_analysis.R` contains code to execute ANOVA (default) or GLM analysis of bio-ore weight (default), bioaccumulation factor, pot success rate, or dry biomass. For example:

```sh
Rscript phytomining_analysis.R # ANOVA of bio-ore weight
Rscript phytomining_analysis.R --value bf # ANOVA of BF
Rscript phytomining_analysis.R --model glm # GLM of bio-ore weight
Rscript phytomining_analysis.R --model glm --value bf # GLM of BF
Rscript phytomining_analysis.R --model glm --value success # GLM of success rate
Rscript phytomining_analysis.R --model glm --value drymass # GLM of dry biomass
```
