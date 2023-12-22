library("raster")
library("here")
library("sf")
# Spécifier le chemin vers le fichier TIFF
path = here()
img_path = paste0(path, "/wc2.1_30s_tmin/wc2.1_30s_tmin_12.tif")
shp_path = paste0(path, "/gadm41_CIV_shp/gadm41_CIV_0.shp")
regions_path = paste0(path, "/gadm41_CIV_shp/gadm41_CIV_1.shp")

country = read_sf(shp_path)

# Charger l'image TIFF
img_tiff = raster(img_path)

# Recouper les données raster pour le pays/région
civ_cut = raster :: crop(img_tiff, country)
plot(civ_cut, main = "Côte d'ivoire")
plot(regions)

regions = read_sf(regions_path)

civ = mask(civ_cut, country)
civ = rasterize(civ)
plot(civ)
plot(regions, col = "transparent", border = "black", add = TRUE)

temp_by_region <- extract(civ, regions, fun = mean, na.rm = TRUE)

# Ajouter la moyenne de température à vos données de région
regions$temp_mean <- temp_by_region

# Visualiser la température moyenne par région
plot(regions["temp_mean"], main = "Température moyenne par région en Côte d'Ivoire")

# Génération aléatoire de coordonnées dans le pays/région
nb_pts = 100
random_pts <- sampleRandom(civ, nb_pts, sp=TRUE)

# Extraction des informations météorologiques aux coordonnées aléatoires
temperature <- extract(img_tiff, random_pts)
evaporation <- extract(img_tiff, random_pts)

# Affichage des points aléatoires sur la carte
plot(civ)
points(random_pts, col = "red", pch = 16, add=TRUE)
