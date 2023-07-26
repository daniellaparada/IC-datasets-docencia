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

# Sismos en Argentina Continental (saco TdF porque se corre mucho el mapa)
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
         Provincia != "PARAGUAY",
         Provincia != "LIM. ARG-CHILE",
         Provincia != "LIM.ARGENTINA-CHILE",
         Provincia != "LIM.CHILE-ARGENTINA",
         Provincia != "LIMITE ARGENTINA-CHILE",
         Provincia != "LIMITE ARGENTINA CHILE",
         Provincia != "TIERRA DEL FUEGO",
         Provincia != "ISLAS GEORGIAS Y SANDWICH DEL SUR")

table(sismos_arg$Provincia)

# Recodifico provincias
sismos_arg <- sismos_arg %>%
  mutate(Provincia=recode(Provincia,
                          "BUENOS AIRES"= "Buenos Aires",
                          "CATAMARCA" = "Catamarca",
                          "CATAMARCA}" = "Catamarca",
                          "CATAMARCA LIM. TUCUMAN" = "Catamarca",
                          "CATAMARCA(LIM.CON TUCUMAN)" = "Catamarca",
                          "CATAMARCA(LIM.CON TUCUMÁN)" = "Catamarca",
                          "CHACO" = "Chaco",
                          "CHUBUT" = "Chubut",
                          "CORDOBA" = "Córdoba",
                          "CORDOBA(LIM.CON SAN LUIS)" = "Córdoba",
                          "CORDOBA LIM. SAN LUIS" = "Córdoba",
                          "CORRIENTES" = "Corrientes",
                          "ENTRE RIOS" = "Entre Ríos",
                          "FORMOSA" = "Formosa",
                          "jujuy" = "Jujuy",
                          "JUJUY" = "Jujuy",
                          "JUJUY(LIM.CON SALTA)" = "Jujuy",
                          "LA PAMPA" = "La Pampa",
                          "LA RIOJA" = "La Rioja",
                          "LA RIOJA LIM. SAN JUAN" = "La Rioja",
                          "LA RIOJA(LIM.CON CATAMARCA)" = "La Rioja",
                          "LA RIOJA(LIM.CON SAN JUAN)" = "La Rioja",
                          "LIM. CATAMARCA-TUCUMAN" = "Catamarca",
                          "LIM. LA RIOJA - SAN JUAN" = "La Rioja",
                          "LIMITE CATAMARCA - TUCUMAN" = "Catamarca",
                          "LIMITE CORDOBA - SAN LUIS" = "Córdoba",
                          "LIMITE JUJUY-SALTA" = "Jujuy",
                          "LIMITE JUJUY - SALTA" = "Jujuy",
                          "LIMITE LA RIOJA-CATAMARCA" = "La Rioja",
                          "LIMITE MENDOZA-SAN JUAN" = "Mendoza",
                          "LIMITE MENDOZA - SAN JUAN" = "Mendoza",
                          "LIMITE SALTA-JUJUY" = "Salta",
                          "LIMITE SALTA - CATAMARCA" = "Salta",
                          "LIMITE SALTA - JUJUY" = "Salta",
                          "LIMITE SAN JUAN-MENDOZA" = "San Juan",
                          "LIMITE SAN JUAN - LA RIOJA" = "San Juan",
                          "LIMITE SAN JUAN - MENDOZA" = "San Juan",
                          "LIMITE SAN JUAN SAN LUIS" = "San Juan",
                          "LIMITE SAN LUIS-SAN JUAN" = "San Luis",
                          "LIMITE TUCUMAN - CATAMARCA" = "Tucumán",
                          "MENDOZa" = "Mendoza",
                          "MENDOZA" = "Mendoza",
                          "MENDOZA(LIM.CON SAN JUAN)" = "Mendoza",
                          "MENDOZA}" = "Mendoza",
                          "MMENDOZA" = "Mendoza",
                          "NEUQUEN" = "Neuquén",
                          "RIO NEGRO" = "Río Negro",
                          "SALTA" = "Salta",
                          "SALTA (limite con Jujuy)" = "Salta",
                          "SALTA LIM. JUJUY" = "Salta",
                          "SALTA(LIM.CON JUJUY)" = "Salta",
                          "SALTA(LIM.CON TUCUMAN)" = "Salta",
                          "SAN JUAN LIM. MENDOZA" = "San Juan",
                          "SAN JUAN (LIM.CON SAN LUIS)" = "San Juan",
                          "SAN JUAN LIM. LA RIOJA" = "San Juan",
                          "SAN JUAN LIM.CON SAN LUIS" = "San Juan",
                          "SAN JUAN LIM.CON MENDOZA" = "San Juan",
                          "SAN JUAN LIM. MENDOZA" = "San Juan",
                          "SAN JUAN(LIM.ARG-CHI)" = "San Juan",
                          "SAN JUAN(LIM.CON LA RIOJA)" = "San Juan",
                          "LIMITE SAN JUAN - SAN LUIS" = "San Juan",
                          "LIMITE SAN JUAN LA RIOJA" = "San Juan",
                          "SAN JUAN(LIM.CON MENDOZA)" = "San Juan",
                          "SAN JUA" = "San Juan",
                          "SAn JUAN" = "San Juan",
                          "SAN JUAN" = "San Juan",
                          "LIMITE SAN JUAN MENDOZA" = "San Juan",
                          "SAN JUAN(LIM.CON SAN LUIS)" = "San Juan",
                          "SAN LUIS" = "San Luis",
                          "SANTA CRUZ" = "Santa Cruz",
                          "SANTIAGO DEL ESTERO" = "Santiago del Estero",
                          "SGO.DEL ESTERO LIM.CON CATAMARCA" = "Santiago del Estero",
                          "TUCUMAN" = "Tucumán",
                          "TUCUMÁN" = "Tucumán",
                          "TUCUMAN LIM. SALTA" = "Tucumán",
                          "TUCUMAN(LIM.CON CATAMARCA)" = "Tucumán"))

sort(-table(sismos_arg$Provincia))

# Elijo variables
sismos_arg <- sismos_arg %>%
  select(c(2,3,4,5,9,10,11,12))

# Plot
pal1 <- colorNumeric(palette = c("deeppink2", "deeppink4"), domain = sismos_arg$Profundidad)
pal2 <- colorNumeric(palette = c("dodgerblue2", "dodgerblue4"), domain = sismos_arg$Profundidad)

mapa_arg <- sismos_arg %>% 
  leaflet(options = leafletOptions(attributionControl=FALSE))%>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenTopoMap", group = "Topográfico",
                   options = providerTileOptions(opacity=0.5)) %>%
  addCircleMarkers(data=sismos_arg%>% 
                     filter(Percibido==FALSE),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=0.1,
                   radius=~Magnitud,
                   color = ~pal2(Profundidad),
                   stroke = FALSE, 
                   group = "Sismos no percibidos") %>% 
  addCircleMarkers(data=sismos_arg%>% 
               filter(Percibido==TRUE),
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

                       
# Plot del top 7 de provincias, intensidad por color
top <- c("San Juan", "Salta", "Jujuy", "La Rioja", "Mendoza", "Catamarca", "Córdoba")
pal3 <- colorNumeric(palette = c("gold", "sienna1","firebrick", "darkred", "orangered4"), domain = sismos_arg$Magnitud)

mapa_arg_top <- sismos_arg %>% 
  leaflet(options = leafletOptions(attributionControl=FALSE))%>%
  addTiles(group = "OSM (default)") %>%
  addProviderTiles("OpenTopoMap", group = "Topográfico",
                   options = providerTileOptions(opacity=0.5)) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[1]),
                     lng= ~Longitud, 
                     lat= ~Latitud,
                     fillOpacity=1,
                     radius=~Magnitud*1000,
                     color=~pal3(Magnitud),
                     stroke = FALSE, 
                     group = top[1]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[2]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[2]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[3]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[3]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[4]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[4]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[5]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[5]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[6]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[6]) %>%
  addCircles(data=sismos_arg%>% 
                     filter(Provincia==top[7]),
                   lng= ~Longitud, 
                   lat= ~Latitud,
                   fillOpacity=1,
                   radius=~Magnitud*1000,
             color=~pal3(Magnitud),
                   stroke = FALSE, 
                   group = top[7]) %>%
  addLayersControl(baseGroups = c("OSM (default)", "Topográfico"),
                   overlayGroups = top,
                   options = layersControlOptions(collapsed = TRUE))
mapa_arg_top

# Guardo datos de sismos de Arg
# guardo el dataset
write.csv(sismos_arg,
          "~\\GitHub\\datasets-docencia\\fuente\\04_visualizacion\\sismos-arg.csv", 
          row.names=FALSE, fileEncoding = "UTF-8")

# Resúmenes por provincia
prov <- group_by(sismos_arg, Provincia) %>% 
  count()

df1 <- group_by(sismos_arg, Provincia) %>% 
  summarise(nperc = sum(Percibido==TRUE),
            Magmed = median(Magnitud),
            Profmed = median(Profundidad))

df2 <- group_by(sismos_arg, Provincia) %>% 
  count() 

sismos_prov <- left_join(df2, df1, by = c("Provincia" = "Provincia"))

sismos_prov_porc <- sismos_prov %>%
  filter(n>1000) %>%
  group_by(Provincia) %>% 
  summarise(pperc = nperc/n*100)

# Miramos San Juan
library(lubridate)
sismos_arg <- sismos_arg %>%
  mutate(FechaHora = paste(Fecha,Hora,sep=" "))
sismos_arg$FechaHora <- ymd_hms(sismos_arg$FechaHora)

sismos_SJ <- sismos_arg %>%
  filter(Provincia == "San Juan") %>%
  arrange(FechaHora) 

sismos_SJ_dia <- sismos_SJ %>%
  group_by(Fecha) %>%
  count()

# mejorar
hist(sismos_SJ_dia$n, xlim=c(0,40), 
     breaks=118, probability=TRUE)
plot(sismos_SJ_dia$Fecha, sismos_SJ_dia$n)

sismos_SJ <- sismos_SJ %>%
  mutate(Año = format(Fecha, format="%Y"))

df <- sismos_SJ %>%
  group_by(Magnitud, Año) %>%
  count()

# mejorar G-R estimación
plot(df$Magnitud, log(df$n, 10))
ajuste <- lm(log(n,10)~Magnitud, data=df)
a <- ajuste$coefficients[1]
b <- ajuste$coefficients[2]
lines(df$Magnitud, b*df$Magnitud+a, col="red")

# Miro los percibidos
df <- sismos_SJ %>%
  filter(Percibido==TRUE)

# Tiempo transcurrido entre dos percibidos (días)
tiempo <- c()
for(i in 1:(nrow(df)-1))
tiempo[i] <- difftime(df$FechaHora[i+1],df$FechaHora[i], units = "days")
hist(tiempo, probability = TRUE, xlim=c(0,50))
curve(dexp(x, rate = 1/mean(tiempo)), xlim = c(0,50),add=TRUE, col="red")

