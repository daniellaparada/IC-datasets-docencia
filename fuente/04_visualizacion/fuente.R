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
require(leaflet)

# importo datos de sismos
sismos <- vroom("sismos_all.csv")
sismos$Fecha <- as.Date(sismos$Fecha,tryFormats = c("%d/%m/%Y"))

# info de casi 10 años
min(sismos$Fecha)
max(sismos$Fecha)

# dummy para los percibidos
sismos <- sismos %>% 
  mutate(Percibido = !is.na(Intensidad),
         Magnitud = Magn.,
         Profundidad = Profund.) 

# Quitamos las unidades km. en intensidad
sismos$Profundidad <- as.numeric(str_sub(sismos$Profundidad, 1, -4))

# Sismos en Argentina Continental
sismos_arg <- sismos %>%
  filter(Provincia != "OCEANO PACIFICO",
         Provincia != "CHILE",
         Provincia != "MAULE - CHILE",
         Provincia != "REPÚBLICA DE CHILE",
         Provincia != "REPUBLICA DE CHILE",
         Provincia != "SUR DE CHILE",
         Provincia != "TFAIAS",
         Provincia != "NORTH ISLAND, NEW ZEALAND",
         Provincia != "REGION NOT FOUND.",
         Provincia != "PERU",
         Provincia != "PENINSULA ANTARTICA",
         Provincia != "PASAJE DE DRAKE",
         Provincia != "NORTHWEST OF KURIL ISLANDS",
         Provincia != "NTARTIDA",
         Provincia != "MAR DE SCOTIA",
         Provincia != "MAR ARGENTINO",
         Provincia != "ISLAS SANDWICH DEL SUR",
         Provincia != "ISLAS SANDWICH",
         Provincia != "ISLAS SHETLAND",
         Provincia != "ISLAS SHETLAND DEL SUR",
         Provincia != "ESTRECHO DE DRAKE",
         Provincia != "FILIPINAS",
         Provincia != "I.SANDWICH DEL SUR",
         Provincia != "ISLAS SANDWICH",
         Provincia != "ISLAS SHETLAND",
         Provincia != "ISLAS SHETLAND DEL SUR",
         Provincia != "ESTRECHO DE DRAKE",
         Provincia != "SECTOR ANTARTICO",
         Provincia != "IS. SHETLAND DEL SUR",
         Provincia != "ISLAS GEORGIA DEL SUR",
         Provincia != "ISLAS GEORGIAS DEL SUR",
         Provincia != "ISLAS GEORGIAS y SANDWICH DEL SUR",
         Provincia != "ISLAS GIORGIA Y SANDWICH DEL SUR",
         Provincia != "ISLAS ORCADAS",
         Provincia != "ISLAS ORCADAS DEL SUR",
         Provincia != "ATLANTICO SUR",
         Provincia != "BOLIVIA",
         Provincia != "ISLAS GEORGIAS Y SANDWICH DEL SUR",
         Provincia != "PARAGUAY",
         Provincia != "LIM. ARG-CHILE",
         Provincia != "LIM.ARGENTINA-CHILE",
         Provincia != "LIM.CHILE-ARGENTINA",
         Provincia != "LIMITE ARGENTINA-CHILE",
         Provincia != "LIMITE ARGENTINA CHILE",
         Provincia != "TIERRA DEL FUEGO")

table(sismos_arg$Provincia)

pal1 <- colorNumeric(palette = c("deeppink2", "deeppink4"), domain = sismos_arg$Profundidad)
pal2 <- colorNumeric(palette = c("dodgerblue2", "dodgerblue4"), domain = sismos_arg$Profundidad)

mapa_arg <- sismos_arg %>% 
  leaflet(options = leafletOptions(attributionControl=FALSE))%>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenTopoMap", group = "Topográfico",
                   options = providerTileOptions(opacity=0.5)) %>%
  addCircleMarkers(data=sismos_arg%>% 
                     filter(is.na(Intensidad)),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.1,
                   radius=~Magnitud,
                   color = ~pal2(Profundidad),
                   stroke = FALSE, 
                   group = "Sismos no percibidos") %>% 
  addCircleMarkers(data=sismos_arg%>% 
               filter(Intensidad != "NA"),
             lng= ~Longitud, 
             lat= ~Latitud,
             fillOpacity=0.1,
             radius=~Magnitud,
             color = ~pal1(Profundidad),
             stroke = FALSE, 
             group = "Sismos percibidos") %>% 
  addLayersControl(baseGroups = c("OSM (default)", "Topográfico"),
                   overlayGroups = c("Sismos no percibidos", "Sismos percibidos"),
                   options = layersControlOptions(collapsed = TRUE))
mapa_arg

mapa_arg_perc <- sismos_arg_perc %>% 
  leaflet(options = leafletOptions(attributionControl=FALSE))%>%
  addProviderTiles("OpenStreetMap",
                   options = providerTileOptions(opacity=1)) %>%
  addCircleMarkers(lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.15,
                   radius=~Magnitud,
                   color = ~pal(Profundidad),
                   stroke = FALSE) 
mapa_arg_perc

# Sismos percibidos en San Juan
sismos_SJ_perc <- sismos_arg_perc %>%
  filter(Provincia == "SAN JUAN")

mapa_SJ_perc <- sismos_SJ_perc %>% 
  leaflet(options = leafletOptions(attributionControl=FALSE))%>%
  addProviderTiles("OpenStreetMap",
                   options = providerTileOptions(opacity=1)) %>%
  addCircleMarkers(lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.25,
                   radius=~Magnitud,
                   color = ~pal(Profundidad),
                   stroke = FALSE) 
mapa_SJ_perc

# Sismos en San Juan

