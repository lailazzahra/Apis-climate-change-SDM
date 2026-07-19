# Overview
This study uses an ensemble of statistical algorithms implemented via the biomod2 package in R, with future projections under SSP245 (moderate emissions) and SSP585 (high emissions) scenarios. It also investigates the dominant environmental drivers of the species' range and discusses the socio-economic implications of habitat loss for pollinator-dependent agriculture and rural honey economies in the region.

# Research Question
How will climate change alter the suitable range of _Apis dorsata_ across Southeast Asia by 2050?
What are the ecological and socio-economic consequences of these shifts?

# Methodology
1. Data extraction from GBIF, WorldClim, RiverSHEDS, Global Forest Change
2. Multicollinearity assessment and predictor selection
3. Presence & pseudo absence data
4. SDM model training & evaluation
5. Variable importance & response curves
6. Ensemble model building
7. Habitat suitability projections under SSP245 and SSP585

# Key Findings
## Dominant Predictors
1. BIO4 (Seasonality Temperature) (mean permutation importance = 0.82)
2. Distance to River (mean permutation imp = 0.22)
3. Other predictors ( < 0.10 each)
## Current Range
Mainland Southeast Asia, Malay Peninsula, Sundaland
## Projected Habitat Loss by 2050
1. Thailand (approx. 51,000 km2)
2. Myanmar (approx. 46,500 km2)
3. Indonesia (approx. 32,000 km2)
4. Other countries are projected to experience smaller losses
## Response Curves
1. BIO4: steep monotonic decline after a threshold (400-600)
2. Distance to River: linear decline to 0 at 4,000 m
3. Tree Cover: nearly linear decline from 0.9 to 0.4
## Socio-Economic Implications
Climate-driven habitat loss of _A. dorsata_ will result in loss of:
1. Pollinator-dependent agriculture (Malaysia, Thailand, Indonesia mainly)
2. Rural honey economies (Indonesia)
3. Tropical biodiversity hotspots

# Repository contains
1. Manuscript
2. RStudio Project File
3. Figures (current suitable habitats, future habitat change, variable importance boxplot, validation/calibration dataset, response curves, habitat change percentage)
4. CSV (habitat change by country, model evaluation, variable importance summary)
5. RDS (ensemble model)

# Status
Indepedent study
