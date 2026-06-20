#################################################
# Climate Change and Apis dorsata Distribution
# Southeast Asia SDM using Random Forest
#################################################

# Load packages
library(terra)
library(geodata)
library(randomForest)

#################################################
# 1. Load occurrence data
#################################################

occ <- read.delim("occurrence.txt")

table(occ$species)

#################################################
# 2. Filter Apis dorsata
#################################################

dorsata <- subset(
  occ,
  species == "Apis dorsata"
)

# Remove missing coordinates
dorsata <- dorsata[
  !is.na(dorsata$decimalLongitude) &
  !is.na(dorsata$decimalLatitude),
]

# Remove duplicate coordinates
dorsata <- dorsata[
  !duplicated(
    dorsata[, c(
      "decimalLongitude",
      "decimalLatitude"
    )]
  ),
]

nrow(dorsata)

#################################################
# 3. Load climate variables
#################################################

bio <- worldclim_global(
  var = "bio",
  res = 10,
  path = "worldclim"
)

#################################################
# 4. Crop to Southeast Asia
#################################################

sea <- ext(
  90,
  150,
  -15,
  25
)

bio_sea <- crop(
  bio,
  sea
)

#################################################
# 5. Select predictor variables
#################################################

predictors <- bio_sea[[c(
  "wc2.1_10m_bio_1",
  "wc2.1_10m_bio_4",
  "wc2.1_10m_bio_12",
  "wc2.1_10m_bio_15"
)]]

#################################################
# 6. Extract climate values
#################################################

pres <- vect(
  dorsata,
  geom = c(
    "decimalLongitude",
    "decimalLatitude"
  ),
  crs = "EPSG:4326"
)

pres_vals <- extract(
  predictors,
  pres
)

#################################################
# 7. Generate background points
#################################################

bg <- spatSample(
  predictors,
  size = nrow(dorsata),
  method = "random",
  xy = TRUE
)

bg_vals <- extract(
  predictors,
  bg[, c("x", "y")]
)

#################################################
# 8. Prepare model dataset
#################################################

pres_data <- data.frame(
  presence = 1,
  pres_vals[, -1]
)

bg_data <- data.frame(
  presence = 0,
  bg_vals[, -1]
)

model_data <- rbind(
  pres_data,
  bg_data
)

model_data <- na.omit(
  model_data
)

model_data$presence <- as.factor(
  model_data$presence
)

#################################################
# 9. Train Random Forest
#################################################

rf_test <- randomForest(
  presence ~ .,
  data = model_data,
  ntree = 100
)

print(rf_test)

importance(rf_test)

#################################################
# 10. Current suitability
#################################################

rf_map <- predict(
  predictors,
  rf_test,
  type = "prob",
  index = 2
)

plot(rf_map)

#################################################
# 11. SSP245 Projection
#################################################

future245 <- cmip6_world(
  model = "BCC-CSM2-MR",
  ssp = "245",
  time = "2041-2060",
  var = "bio",
  res = 10,
  path = "future_climate"
)

future245_sea <- crop(
  future245,
  sea
)

future_pred <- future245_sea[[c(
  "bio01",
  "bio04",
  "bio12",
  "bio15"
)]]

names(future_pred) <- c(
  "wc2.1_10m_bio_1",
  "wc2.1_10m_bio_4",
  "wc2.1_10m_bio_12",
  "wc2.1_10m_bio_15"
)

future_map <- predict(
  future_pred,
  rf_test,
  type = "prob",
  index = 2
)

#################################################
# 12. SSP585 Projection
#################################################

future585 <- cmip6_world(
  model = "BCC-CSM2-MR",
  ssp = "585",
  time = "2041-2060",
  var = "bio",
  res = 10,
  path = "future_climate"
)

future585_sea <- crop(
  future585,
  sea
)

future585_pred <- future585_sea[[c(
  "bio01",
  "bio04",
  "bio12",
  "bio15"
)]]

names(future585_pred) <- c(
  "wc2.1_10m_bio_1",
  "wc2.1_10m_bio_4",
  "wc2.1_10m_bio_12",
  "wc2.1_10m_bio_15"
)

future585_map <- predict(
  future585_pred,
  rf_test,
  type = "prob",
  index = 2
)

#################################################
# 13. Habitat Change
#################################################

current_binary <- rf_map > 0.5
future245_binary <- future_map > 0.5
future585_binary <- future585_map > 0.5

change245 <- future245_binary - current_binary
change585 <- future585_binary - current_binary

freq(change245)
freq(change585)

#################################################
# 14. Save model
#################################################

saveRDS(
  rf_test,
  "outputs/rf_model.rds"
)