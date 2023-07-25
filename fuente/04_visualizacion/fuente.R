# datasets: 
# fuente sismos: http://contenidos.inpres.gob.ar/buscar_sismo
# sismos scrappeado: "sismos_all.csv" (del 01/07/2012 al 18/05/2022)
# shape argentina: https://geodata.ucdavis.edu/gadm/gadm4.1/shp/gadm41_ARG_shp.zip
# Geopackage: https://geodata.ucdavis.edu/gadm/gadm4.1/gpkg/gadm41_ARG.gpkg


require(ggplot2)
require(tidyverse)
require(ggfortify)
require(plotly)
require(vroom)
require(sp)
require(RColorBrewer)
require(tmap)
require(sf)

# importo datos de sismos
sismos <- vroom("sismos_all.csv")
sismos$Fecha <- as.Date(sismos$Fecha,tryFormats = c("%d/%m/%Y"))
min(sismos$Fecha)
max(sismos$Fecha)

# mapa de argentina
argentina <- st_read(dsn = "gadm41_ARG_0.shp") %>% st_as_sf()
provincias <- st_read(dsn = "gadm41_ARG_1.shp") %>% st_as_sf()
localidades <- st_read(dsn = "gadm41_ARG_2.shp") %>% st_as_sf()

# Verificamos el crs: 4326
st_crs(provincias)

tm_shape(provincias) +
  tm_fill(col = "lightgray") +
  tm_text("NAME_1", size = 0.3) +
  tm_borders(lwd = 1, col = "black")

# primeras pruebas para plotear datos
sismos_filt <- sismos %>%
  filter(Intensidad != "NA",
         Provincia != "OCEANO PACIFICO",
         Provincia != "CHILE",
         Provincia != "MAULE - CHILE",
         Provincia != "REPÚBLICA DE CHILE",
         Provincia != "REPUBLICA DE CHILE",
         Provincia != "SUR DE CHILE",
         Provincia != "TFAIAS")

table(sismos_filt$Provincia)

sismos_pos <- st_as_sf(x=sismos_filt,
                     coords = c("Longitud" ,"Latitud"),
                     crs = 4326)

tm_shape(provincias) +
  tm_fill(col = "lightgray") +
  tm_text("NAME_1", size = 0.3) +
  tm_borders(lwd = 1, col = "black") +
  tm_shape(sismos_pos) + 
  tm_dots(size = 0.1)

m <- #tm_shape(provincias) +
  #tm_fill(col = "white") +
  #tm_text("NAME_1", size = 0.3) +
  #tm_borders(lwd = 1, col = "black") +
  tm_shape(sismos_pos) + 
  tm_dots(size = 0.1)

tmap_leaflet(m)

